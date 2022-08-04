// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.5.0;
contract ERC20Interface {
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

// ----------------------------------------------------------------------------
// Safe Math Library
// ----------------------------------------------------------------------------
contract SafeMath {
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a, "problem with safe add");
    }
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a); c = a - b; } function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);
        c = a / b;
    }
}


contract RLC is ERC20Interface, SafeMath {
    string public name;
    string public symbol;
    uint8 public decimals; // 18 decimals is the strongly suggested default, avoid changing it

    uint256 public _totalSupply;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    /**
     * Constrctor function
     *
     * Initializes contract with initial supply tokens to the creator of the contract
     */
    constructor() public {
        name = "RedLine Coin";
        symbol = "RLC";
        decimals = 18;
        _totalSupply = 3000000000 * 10**18;

        balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function totalSupply() public view returns (uint) {
        return _totalSupply  - balances[address(0)];
    }

    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }

    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transfer(address to, uint tokens) public returns (bool success) {
        // check msg.sender balance before any transfer
        require(balances[msg.sender] >= tokens , "there is not enough balance for transfer token");

        // decrease msg.sender balance
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);

        // increase to balance
        balances[to] = safeAdd(balances[to], tokens);

        // emit
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        // check from balance
        require(balances[from] >= tokens , "there is not enough balance for transfer token");

        // check allowance
        require(allowed[from][to] >= tokens , "there is not enough allowance for transfer token");

        // we are not checking allowance from ! to !! we are checking allowance of from and msg.sender !
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);

        // working code 
        // allowed[from][to] = safeSub(allowed[from][to], tokens);

        // decrease from balance
        balances[from] = safeSub(balances[from], tokens);
        //increase to balance 
        balances[to] = safeAdd(balances[to], tokens);

        // emit
        emit Transfer(from, to, tokens);
        return true;
    }
}