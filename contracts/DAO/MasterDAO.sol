// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./utils/MasterDAOTools.sol";

contract MasterDAO is NFTTokenDAOStorageV1 {
    // // /////////////////////////////////////////////////////////////// TIME LOCK STATE VARS

    // voting period time, cannot be executed anymore
    uint256 public constant GRACE_PERIOD = 200;
    // min delay after create proposal to going active for vote
    uint256 public constant MINIMUM_DELAY = 10;
    // max delay after create proposal to going active for vote
    uint256 public constant MAXIMUM_DELAY = 10;

    // delay to start vote
    uint256 public delay;

    // mapping to find what transactions are ready to execute
    mapping(bytes32 => bool) public queuedTransactions;

    // // /////////////////////////////////////////////////////////////// GOV STATE VARS

    uint256 public constant MIN_PROPOSAL_THRESHOLD_BPS = 1; // 1 basis point or 0.01%
    uint256 public constant MAX_PROPOSAL_THRESHOLD_BPS = 1_000; // 1,000 basis points or 10%

    uint256 public constant MIN_VOTING_PERIOD = 5_760; // About 24 hours
    uint256 public constant MAX_VOTING_PERIOD = 80_640; // About 2 weeks

    uint256 public constant MIN_VOTING_DELAY = 1;
    uint256 public constant MAX_VOTING_DELAY = 40_320; // About 1 week

    uint256 public constant MIN_QUORUM_VOTES_BPS = 200; // 200 basis points or 2%
    uint256 public constant MAX_QUORUM_VOTES_BPS = 2_000; // 2,000 basis points or 20%

    uint256 public constant proposalMaxOperations = 10; // 10 actions

    struct ProposalTemp {
        uint256 totalSupply;
        uint256 proposalThreshold;
        uint256 latestProposalId;
        uint256 startBlock;
        uint256 endBlock;
    }

    function initialize(
        address NFTToken_,
        address vetoer_,
        uint256 votingPeriod_,
        uint256 votingDelay_
    ) public virtual {
        NFTToken = NFTTokenTokenLike(NFTToken_);
        vetoer = vetoer_;
        votingPeriod = votingPeriod_;
        votingDelay = votingDelay_;
    }

    // // /////////////////////////////////////////////////////////////// CREATE PROPOSAL

    function propose(
        address[] memory targets,
        uint256[] memory values,
        string[] memory signatures,
        bytes[] memory calldatas
    ) public returns (uint256) {
        ProposalTemp memory temp;

        temp.totalSupply = NFTToken.totalSupply();

        temp.proposalThreshold = bps2Uint(
            proposalThresholdBPS,
            temp.totalSupply
        );

        require(
            targets.length != 0,
            "NFTTokenDAO::propose: must provide actions"
        );
        require(targets.length <= proposalMaxOperations, "too many actions");

        temp.latestProposalId = latestProposalIds[msg.sender];

        if (temp.latestProposalId != 0) {
            ProposalState proposersLatestProposalState = state(
                temp.latestProposalId
            );
            require(
                proposersLatestProposalState != ProposalState.Active,
                "found an already active proposal"
            );
            require(
                proposersLatestProposalState != ProposalState.Pending,
                "found an already pending proposal"
            );
        }

        temp.startBlock = block.number + votingDelay;
        temp.endBlock = temp.startBlock + votingPeriod;

        proposalCount++;
        Proposal storage newProposal = proposals[proposalCount];

        newProposal.id = proposalCount;
        newProposal.proposer = msg.sender;
        newProposal.proposalThreshold = temp.proposalThreshold;
        newProposal.quorumVotes = bps2Uint(quorumVotesBPS, temp.totalSupply);
        newProposal.eta = 0;
        newProposal.targets = targets;
        newProposal.values = values;
        newProposal.signatures = signatures;
        newProposal.calldatas = calldatas;
        newProposal.startBlock = temp.startBlock;
        newProposal.endBlock = temp.endBlock;
        newProposal.forVotes = 0;
        newProposal.againstVotes = 0;
        newProposal.abstainVotes = 0;
        newProposal.canceled = false;
        newProposal.executed = false;
        newProposal.vetoed = false;

        latestProposalIds[newProposal.proposer] = newProposal.id;

        return newProposal.id;
    }

    // // /////////////////////////////////////////////////////////////// TIMELOCK

    function queue(uint256 proposalId) external {
        require(
            state(proposalId) == ProposalState.Succeeded,
            "queue: proposal can only be queued if it is succeeded"
        );
        Proposal storage proposal = proposals[proposalId];
        uint256 eta = block.timestamp + delay;
        for (uint256 i = 0; i < proposal.targets.length; i++) {
            if (
                !queuedTransactions[
                    keccak256(
                        abi.encode(proposal.targets[i], proposal.values[i], eta)
                    )
                ]
            ) {
                queueTransaction(proposal.targets[i], proposal.values[i], eta);
            }
        }
        proposal.eta = eta;
    }

    function queueTransaction(
        address target,
        uint256 value,
        uint256 eta
    ) public returns (bytes32) {
        require(
            eta >= getBlockTimestamp() + delay,
            "Estimated execution block must satisfy delay."
        );

        bytes32 txHash = keccak256(abi.encode(target, value, eta));
        queuedTransactions[txHash] = true;

        return txHash;
    }

    function execute(uint256 proposalId) external {
        // require(
        //     state(proposalId) == ProposalState.Queued,
        //     "execute: proposal can only be executed if it is queued"
        // );
        Proposal storage proposal = proposals[proposalId];
        proposal.executed = true;
        for (uint256 i = 0; i < proposal.targets.length; i++) {
            executeTransaction(
                proposal.targets[i],
                proposal.values[i],
                proposal.eta
            );
        }
    }

    function executeTransaction(
        address target,
        uint256 value,
        uint256 eta
    ) public {
        bytes32 txHash = keccak256(abi.encode(target, value, eta));
        require(
            queuedTransactions[txHash],
            ":executeTransaction: Transaction hasn't been queued."
        );
        require(
            getBlockTimestamp() >= eta,
            "executeTransaction: Transaction hasn't surpassed time lock."
        );
        require(
            getBlockTimestamp() <= eta + GRACE_PERIOD,
            "executeTransaction: Transaction is stale."
        );

        queuedTransactions[txHash] = false;

        // solium-disable-next-line security/no-call-value
        (bool success, ) = target.call{value: value}("");
        require(success, "executeTransaction: Transaction execution reverted.");
    }

    function getBlockTimestamp() internal view returns (uint256) {
        return block.timestamp;
    }

    // // /////////////////////////////////////////////////////////////// VOTE

    function castVote(uint256 proposalId, uint8 support) external {
        castVoteInternal(msg.sender, proposalId, support);
    }

    function castVoteInternal(
        address voter,
        uint256 proposalId,
        uint8 support
    ) internal returns (uint96) {
        require(
            state(proposalId) == ProposalState.Active,
            "castVoteInternal: voting is closed"
        );
        require(support <= 2, "castVoteInternal: invalid vote type");
        Proposal storage proposal = proposals[proposalId];
        Receipt storage receipt = proposal.receipts[voter];
        require(
            receipt.hasVoted == false,
            "castVoteInternal: voter already voted"
        );

        uint96 votes = NFTToken.getPriorVotes(
            voter,
            proposal.startBlock - votingDelay
        );

        if (support == 0) {
            proposal.againstVotes = proposal.againstVotes + votes;
        } else if (support == 1) {
            proposal.forVotes = proposal.forVotes + votes;
        } else if (support == 2) {
            proposal.abstainVotes = proposal.abstainVotes + votes;
        }

        receipt.hasVoted = true;
        receipt.support = support;
        receipt.votes = votes;

        return votes;
    }

    // // /////////////////////////////////////////////////////////////// GETTER

    function getReceipt(uint256 proposalId, address voter)
        external
        view
        returns (Receipt memory)
    {
        return proposals[proposalId].receipts[voter];
    }

    function state(uint256 proposalId) public view returns (ProposalState) {
        require(proposalCount >= proposalId, "state: invalid proposal id");
        Proposal storage proposal = proposals[proposalId];
        if (proposal.vetoed) {
            return ProposalState.Vetoed;
        } else if (proposal.canceled) {
            return ProposalState.Canceled;
        } else if (block.number <= proposal.startBlock) {
            return ProposalState.Pending;
        } else if (block.number <= proposal.endBlock) {
            return ProposalState.Active;
        } else if (
            proposal.forVotes <= proposal.againstVotes ||
            proposal.forVotes < proposal.quorumVotes
        ) {
            return ProposalState.Defeated;
        } else if (proposal.eta == 0) {
            return ProposalState.Succeeded;
        } else if (proposal.executed) {
            return ProposalState.Executed;
        } else if (block.timestamp >= proposal.eta + timelock.GRACE_PERIOD()) {
            return ProposalState.Expired;
        } else {
            return ProposalState.Queued;
        }
    }

    function bps2Uint(uint256 bps, uint256 number)
        internal
        pure
        returns (uint256)
    {
        return (number * bps) / 10000;
    }

    receive() external payable {}

    fallback() external payable {}
}
