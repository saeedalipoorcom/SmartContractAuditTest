/**
 *Submitted for verification at Etherscan.io on 2022-06-28
 */

pragma solidity =0.6.6;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this;
        return msg.data;
    }
}

pragma solidity =0.6.6;

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() public {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

pragma solidity >=0.6.2;

interface IRARESwapRouter01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

pragma solidity >=0.6.2;

interface IRARESwapRouter is IRARESwapRouter01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

pragma solidity >=0.5.0;

interface IToken {
    function addPair(address pair, address token) external;

    function depositLPFee(uint256 amount, address token) external;
}

pragma solidity >=0.5.0;

interface IWETH {
    function deposit() external payable;

    function transfer(address to, uint256 value) external returns (bool);

    function withdraw(uint256) external;
}

pragma solidity >=0.5.0;

interface IERC20 {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}

pragma solidity =0.6.6;

// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)

library SafeMath {
    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x + y) >= x, "ds-math-add-overflow");
    }

    function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x - y) <= x, "ds-math-sub-underflow");
    }

    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
    }

    function div(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require(y > 0, "ds-math-div-underflow");
        z = x / y;
    }
}

pragma solidity >=0.5.0;

interface IRARESwapPair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function baseToken() external view returns (address);

    function getTotalFee() external view returns (uint256);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function updateTotalFee(uint256 totalFee) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast,
            address _baseToken
        );

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(address to)
        external
        returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        uint256 amount0Fee,
        uint256 amount1Fee,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;

    function setBaseToken(address _baseToken) external;
}

pragma solidity >=0.5.0;

interface IRARESwapFactory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function pairExist(address pair) external view returns (bool);

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;

    function routerInitialize(address) external;

    function routerAddress() external view returns (address);
}

pragma solidity =0.6.6;

abstract contract FeeStore is Ownable {
    uint256 public adminFee;
    address public adminFeeAddress;
    address public factoryAddress;
    mapping(address => address) public pairFeeAddress;

    function initialize(
        address _factory,
        uint256 _adminFee,
        address _adminFeeAddress
    ) internal {
        factoryAddress = _factory;
        adminFee = _adminFee;
        adminFeeAddress = _adminFeeAddress;
    }

    function feeAdddressSetWhileSwap(address pair, address tokenAddress)
        public
        onlyOwner
    {
        require(
            IRARESwapFactory(factoryAddress).pairExist(pair),
            "RARESwap FeeStore: Pair is not Exist"
        );
        require(
            IRARESwapPair(pair).token0() == tokenAddress ||
                IRARESwapPair(pair).token1() == tokenAddress,
            "RARESwap FeeStore: Invalid token address"
        );

        pairFeeAddress[pair] = tokenAddress;
    }

    function feeAddressGet() public view returns (address) {
        return (
            adminFeeAddress == address(0) ? address(this) : adminFeeAddress
        );
    }

    function setAdminFee(address _adminFeeAddress, uint256 _adminFee)
        external
        onlyOwner
    {
        require(_adminFee <= 100, "RARESwap: Fee exceeds 1%");
        adminFeeAddress = _adminFeeAddress;
        adminFee = _adminFee;
    }
}

pragma solidity >=0.5.0;

library RARESwapLibrary {
    using SafeMath for uint256;

    // returns sorted token addresses, used to handle return values from pairs sorted in this order
    function sortTokens(address tokenA, address tokenB)
        internal
        pure
        returns (address token0, address token1)
    {
        require(tokenA != tokenB, "RARESwapLibrary: IDENTICAL_ADDRESSES");
        (token0, token1) = tokenA < tokenB
            ? (tokenA, tokenB)
            : (tokenB, tokenA);
        require(token0 != address(0), "RARESwapLibrary: ZERO_ADDRESS");
    }

    // calculates the CREATE2 address for a pair without making any external calls
    function pairFor(
        address factory,
        address tokenA,
        address tokenB
    ) internal pure returns (address pair) {
        (address token0, address token1) = sortTokens(tokenA, tokenB);
        pair = address(
            uint256(
                keccak256(
                    abi.encodePacked(
                        hex"ff",
                        factory,
                        keccak256(abi.encodePacked(token0, token1)),
                        hex"00e0302f607cfb8dc4a8f86d6824aba4dce40e6e9ec96315bee5b786f7553438" // init code hash
                    )
                )
            )
        );
    }

    // fetches and sorts the reserves for a pair
    function getReserves(
        address factory,
        address tokenA,
        address tokenB
    ) internal view returns (uint256 reserveA, uint256 reserveB) {
        (address token0, ) = sortTokens(tokenA, tokenB);
        (uint256 reserve0, uint256 reserve1, , ) = IRARESwapPair(
            pairFor(factory, tokenA, tokenB)
        ).getReserves();
        (reserveA, reserveB) = tokenA == token0
            ? (reserve0, reserve1)
            : (reserve1, reserve0);
    }

    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) internal pure returns (uint256 amountB) {
        require(amountA > 0, "RARESwapLibrary: INSUFFICIENT_AMOUNT");
        require(
            reserveA > 0 && reserveB > 0,
            "RARESwapLibrary: INSUFFICIENT_LIQUIDITY"
        );
        amountB = amountA.mul(reserveB) / reserveA;
    }

    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut,
        bool tokenFee,
        uint256 totalFee
    ) internal pure returns (uint256 amountOut) {
        require(amountIn > 0, "RARESwapLibrary: INSUFFICIENT_INPUT_AMOUNT");
        require(
            reserveIn > 0 && reserveOut > 0,
            "RARESwapLibrary: INSUFFICIENT_LIQUIDITY"
        );
        uint256 amountInMultiplier = tokenFee ? 10000 - totalFee : 10000;
        uint256 amountInWithFee = amountIn.mul(amountInMultiplier);
        uint256 numerator = amountInWithFee.mul(reserveOut);
        uint256 denominator = reserveIn.mul(10000).add(amountInWithFee);
        amountOut = numerator / denominator;
    }

    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut,
        bool tokenFee,
        uint256 totalFee
    ) internal pure returns (uint256 amountIn) {
        require(amountOut > 0, "RARESwapLibrary: INSUFFICIENT_OUTPUT_AMOUNT");
        require(
            reserveIn > 0 && reserveOut > 0,
            "RARESwapLibrary: INSUFFICIENT_LIQUIDITY"
        );
        uint256 amountOutMultiplier = tokenFee ? 10000 - totalFee : 10000;
        uint256 numerator = reserveIn.mul(amountOut).mul(10000);
        uint256 denominator = reserveOut.sub(amountOut).mul(
            amountOutMultiplier
        );
        amountIn = (numerator / denominator).add(1);
    }

    // performs chained getAmountOut calculations on any number of pairs
    function getAmountsOut(
        address factory,
        uint256 amountIn,
        address[] memory path
    ) internal view returns (uint256[] memory amounts) {
        require(path.length >= 2, "RARESwapLibrary: INVALID_PATH");
        amounts = new uint256[](path.length);
        amounts[0] = amountIn;
        for (uint256 i; i < path.length - 1; i++) {
            IRARESwapPair pair = IRARESwapPair(
                pairFor(factory, path[i], path[i + 1])
            );
            address baseToken = pair.baseToken();
            uint256 totalFee = pair.getTotalFee();
            (uint256 reserveIn, uint256 reserveOut) = getReserves(
                factory,
                path[i],
                path[i + 1]
            );
            amounts[i + 1] = getAmountOut(
                amounts[i],
                reserveIn,
                reserveOut,
                baseToken != address(0),
                totalFee
            );
        }
    }

    // performs chained getAmountIn calculations on any number of pairs
    function getAmountsIn(
        address factory,
        uint256 amountOut,
        address[] memory path
    ) internal view returns (uint256[] memory amounts) {
        require(path.length >= 2, "RARESwapLibrary: INVALID_PATH");
        amounts = new uint256[](path.length);
        amounts[amounts.length - 1] = amountOut;
        for (uint256 i = path.length - 1; i > 0; i--) {
            IRARESwapPair pair = IRARESwapPair(
                pairFor(factory, path[i - 1], path[i])
            );
            address baseToken = pair.baseToken();
            uint256 totalFee = pair.getTotalFee();
            (uint256 reserveIn, uint256 reserveOut) = getReserves(
                factory,
                path[i - 1],
                path[i]
            );
            amounts[i - 1] = getAmountIn(
                amounts[i],
                reserveIn,
                reserveOut,
                baseToken != address(0),
                totalFee
            );
        }
    }

    function adminFeeCalculation(uint256 _amounts, uint256 _adminFee)
        internal
        pure
        returns (uint256, uint256)
    {
        uint256 adminFeeDeduct = (_amounts.mul(_adminFee)) / (10000);
        _amounts = _amounts.sub(adminFeeDeduct);

        return (_amounts, adminFeeDeduct);
    }
}

pragma solidity >=0.6.0;

// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
library TransferHelper {
    function safeApprove(
        address token,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(0x095ea7b3, to, value)
        );
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            "TransferHelper::safeApprove: approve failed"
        );
    }

    function safeTransfer(
        address token,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(0xa9059cbb, to, value)
        );
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            "TransferHelper::safeTransfer: transfer failed"
        );
    }

    function safeTransferFrom(
        address token,
        address from,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(0x23b872dd, from, to, value)
        );
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            "TransferHelper::transferFrom: transferFrom failed"
        );
    }

    function safeTransferETH(address to, uint256 value) internal {
        (bool success, ) = to.call{value: value}(new bytes(0));
        require(
            success,
            "TransferHelper::safeTransferETH: ETH transfer failed"
        );
    }
}

pragma solidity =0.6.6;

abstract contract SupportingSwap is FeeStore, IRARESwapRouter {
    using SafeMath for uint256;

    address public override factory;
    address public override WETH;

    modifier ensure(uint256 deadline) {
        require(deadline >= block.timestamp, "RARESwapRouter: EXPIRED");
        _;
    }

    function _swap(
        uint256[] memory amounts,
        address[] memory path,
        address _to
    ) internal virtual {
        for (uint256 i; i < path.length - 1; i++) {
            (address input, address output) = (path[i], path[i + 1]);
            (address token0, ) = RARESwapLibrary.sortTokens(input, output);
            uint256 amountOut = amounts[i + 1];
            (uint256 amount0Out, uint256 amount1Out) = input == token0
                ? (uint256(0), amountOut)
                : (amountOut, uint256(0));
            (uint256 amount0Fee, uint256 amount1Fee) = _calculateFees(
                input,
                output,
                amounts[i],
                amount0Out,
                amount1Out
            );
            address to = i < path.length - 2
                ? RARESwapLibrary.pairFor(factory, output, path[i + 2])
                : _to;
            IRARESwapPair(RARESwapLibrary.pairFor(factory, input, output)).swap(
                    amount0Out,
                    amount1Out,
                    amount0Fee,
                    amount1Fee,
                    to,
                    new bytes(0)
                );
        }
    }

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    )
        external
        virtual
        override
        ensure(deadline)
        returns (uint256[] memory amounts)
    {
        require(path.length == 2, "RARESwapRouter: ONLY_TWO_TOKENS_ALLOWED");
        address pair = RARESwapLibrary.pairFor(factory, path[0], path[1]);

        uint256 adminFeeDeduct;
        if (path[0] == pairFeeAddress[pair]) {
            (amountIn, adminFeeDeduct) = RARESwapLibrary.adminFeeCalculation(
                amountIn,
                adminFee
            );
            TransferHelper.safeTransferFrom(
                path[0],
                msg.sender,
                feeAddressGet(),
                adminFeeDeduct
            );
        }

        amounts = RARESwapLibrary.getAmountsOut(factory, amountIn, path);
        require(
            amounts[amounts.length - 1] >= amountOutMin,
            "RARESwapRouter: INSUFFICIENT_OUTPUT_AMOUNT"
        );
        TransferHelper.safeTransferFrom(path[0], msg.sender, pair, amounts[0]);
        _swap(amounts, path, to);
    }

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    )
        external
        virtual
        override
        ensure(deadline)
        returns (uint256[] memory amounts)
    {
        require(path.length == 2, "RARESwapRouter: ONLY_TWO_TOKENS_ALLOWED");
        address pair = RARESwapLibrary.pairFor(factory, path[0], path[1]);
        uint256 adminFeeDeduct;
        if (path[0] == pairFeeAddress[pair]) {
            amounts = RARESwapLibrary.getAmountsIn(factory, amountOut, path);
            require(
                amounts[0] <= amountInMax,
                "RARESwapRouter: EXCESSIVE_INPUT_AMOUNT"
            );
            (amounts[0], adminFeeDeduct) = RARESwapLibrary.adminFeeCalculation(
                amounts[0],
                adminFee
            );
            TransferHelper.safeTransferFrom(
                path[0],
                msg.sender,
                feeAddressGet(),
                adminFeeDeduct
            );

            amounts = RARESwapLibrary.getAmountsOut(factory, amounts[0], path);
            TransferHelper.safeTransferFrom(
                path[0],
                msg.sender,
                pair,
                amounts[0]
            );
        } else {
            amounts = RARESwapLibrary.getAmountsIn(factory, amountOut, path);
            require(
                amounts[0] <= amountInMax,
                "RARESwapRouter: EXCESSIVE_INPUT_AMOUNT"
            );
            TransferHelper.safeTransferFrom(
                path[0],
                msg.sender,
                pair,
                amounts[0]
            );
        }

        _swap(amounts, path, to);
    }

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    )
        external
        payable
        virtual
        override
        ensure(deadline)
        returns (uint256[] memory amounts)
    {
        require(path.length == 2, "RARESwapRouter: ONLY_TWO_TOKENS_ALLOWED");
        require(path[0] == WETH, "RARESwapRouter: INVALID_PATH");

        uint256 bnb = msg.value;
        address pair = RARESwapLibrary.pairFor(factory, path[0], path[1]);
        uint256 adminFeeDeduct;
        if (path[0] == pairFeeAddress[pair]) {
            (bnb, adminFeeDeduct) = RARESwapLibrary.adminFeeCalculation(
                bnb,
                adminFee
            );
            if (address(this) != feeAddressGet()) {
                payable(feeAddressGet()).transfer(adminFeeDeduct);
            }
        }

        amounts = RARESwapLibrary.getAmountsOut(factory, msg.value, path);
        require(
            amounts[amounts.length - 1] >= amountOutMin,
            "RARESwapRouter: INSUFFICIENT_OUTPUT_AMOUNT"
        );
        IWETH(WETH).deposit{value: amounts[0]}();
        assert(IWETH(WETH).transfer(pair, amounts[0]));
        _swap(amounts, path, to);
    }

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    )
        external
        virtual
        override
        ensure(deadline)
        returns (uint256[] memory amounts)
    {
        require(path.length == 2, "RARESwapRouter: ONLY_TWO_TOKENS_ALLOWED");
        require(path[path.length - 1] == WETH, "RARESwapRouter: INVALID_PATH");

        uint256 adminFeeDeduct;
        address pair = RARESwapLibrary.pairFor(factory, path[0], path[1]);
        if (path[0] == pairFeeAddress[pair]) {
            amounts = RARESwapLibrary.getAmountsIn(factory, amountOut, path);
            require(
                amounts[0] <= amountInMax,
                "RARESwapRouter: EXCESSIVE_INPUT_AMOUNT"
            );
            (amounts[0], adminFeeDeduct) = RARESwapLibrary.adminFeeCalculation(
                amounts[0],
                adminFee
            );
            TransferHelper.safeTransferFrom(
                path[0],
                msg.sender,
                feeAddressGet(),
                adminFeeDeduct
            );
            amounts = RARESwapLibrary.getAmountsOut(factory, amounts[0], path);
            TransferHelper.safeTransferFrom(
                path[0],
                msg.sender,
                pair,
                amounts[0]
            );
        } else {
            amounts = RARESwapLibrary.getAmountsIn(factory, amountOut, path);
            require(
                amounts[0] <= amountInMax,
                "RARESwapRouter: EXCESSIVE_INPUT_AMOUNT"
            );
            TransferHelper.safeTransferFrom(
                path[0],
                msg.sender,
                pair,
                amounts[0]
            );
        }
        _swap(amounts, path, address(this));

        uint256 amountETHOut = amounts[amounts.length - 1];
        if (path[1] == pairFeeAddress[pair]) {
            (amountETHOut, adminFeeDeduct) = RARESwapLibrary
                .adminFeeCalculation(amountETHOut, adminFee);
        }
        IWETH(WETH).withdraw(amountETHOut);
        TransferHelper.safeTransferETH(to, amountETHOut);
    }

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    )
        external
        virtual
        override
        ensure(deadline)
        returns (uint256[] memory amounts)
    {
        require(path.length == 2, "RARESwapRouter: ONLY_TWO_TOKENS_ALLOWED");
        require(path[path.length - 1] == WETH, "RARESwapRouter: INVALID_PATH");

        uint256 adminFeeDeduct;
        address pair = RARESwapLibrary.pairFor(factory, path[0], path[1]);
        if (path[0] == pairFeeAddress[pair]) {
            (amountIn, adminFeeDeduct) = RARESwapLibrary.adminFeeCalculation(
                amountIn,
                adminFee
            );
            TransferHelper.safeTransferFrom(
                path[0],
                msg.sender,
                feeAddressGet(),
                adminFeeDeduct
            );
        }

        amounts = RARESwapLibrary.getAmountsOut(factory, amountIn, path);
        require(
            amounts[amounts.length - 1] >= amountOutMin,
            "RARESwapRouter: INSUFFICIENT_OUTPUT_AMOUNT"
        );
        TransferHelper.safeTransferFrom(path[0], msg.sender, pair, amounts[0]);
        _swap(amounts, path, address(this));

        uint256 amountETHOut = amounts[amounts.length - 1];
        if (path[1] == pairFeeAddress[pair]) {
            (amountETHOut, adminFeeDeduct) = RARESwapLibrary
                .adminFeeCalculation(amountETHOut, adminFee);
        }
        IWETH(WETH).withdraw(amountETHOut);
        TransferHelper.safeTransferETH(to, amountETHOut);
    }

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    )
        external
        payable
        virtual
        override
        ensure(deadline)
        returns (uint256[] memory amounts)
    {
        require(path.length == 2, "RARESwapRouter: ONLY_TWO_TOKENS_ALLOWED");
        require(path[0] == WETH, "RARESwapRouter: INVALID_PATH");

        address pair = RARESwapLibrary.pairFor(factory, path[0], path[1]);

        uint256 adminFeeDeduct;
        if (path[0] == pairFeeAddress[pair]) {
            amounts = RARESwapLibrary.getAmountsIn(factory, amountOut, path);
            require(
                amounts[0] <= msg.value,
                "RARESwapRouter: EXCESSIVE_INPUT_AMOUNT"
            );

            (amounts[0], adminFeeDeduct) = RARESwapLibrary.adminFeeCalculation(
                amounts[0],
                adminFee
            );
            if (address(this) != feeAddressGet()) {
                payable(feeAddressGet()).transfer(adminFeeDeduct);
            }
            amounts = RARESwapLibrary.getAmountsOut(factory, amounts[0], path);
            IWETH(WETH).deposit{value: amounts[0]}();
            assert(IWETH(WETH).transfer(pair, amounts[0]));
        } else {
            amounts = RARESwapLibrary.getAmountsIn(factory, amountOut, path);
            require(
                amounts[0] <= msg.value,
                "RARESwapRouter: EXCESSIVE_INPUT_AMOUNT"
            );
            IWETH(WETH).deposit{value: amounts[0]}();
            assert(
                IWETH(WETH).transfer(
                    RARESwapLibrary.pairFor(factory, path[0], path[1]),
                    amounts[0]
                )
            );
        }

        _swap(amounts, path, to);
        // refund dust eth, if any
        uint256 bal = amounts[0].add(adminFeeDeduct);
        if (msg.value > bal)
            TransferHelper.safeTransferETH(msg.sender, msg.value - bal);
    }

    function _calculateFees(
        address input,
        address output,
        uint256 amountIn,
        uint256 amount0Out,
        uint256 amount1Out
    ) internal view virtual returns (uint256 amount0Fee, uint256 amount1Fee) {
        IRARESwapPair pair = IRARESwapPair(
            RARESwapLibrary.pairFor(factory, input, output)
        );
        (address token0, ) = RARESwapLibrary.sortTokens(input, output);
        address baseToken = pair.baseToken();
        uint256 totalFee = pair.getTotalFee();
        amount0Fee = baseToken != token0 ? uint256(0) : input == token0
            ? amountIn.mul(totalFee).div(10**4)
            : amount0Out.mul(totalFee).div(10**4);
        amount1Fee = baseToken == token0 ? uint256(0) : input != token0
            ? amountIn.mul(totalFee).div(10**4)
            : amount1Out.mul(totalFee).div(10**4);
    }

    function _calculateAmounts(
        address input,
        address output,
        address token0
    ) internal view returns (uint256 amountInput, uint256 amountOutput) {
        IRARESwapPair pair = IRARESwapPair(
            RARESwapLibrary.pairFor(factory, input, output)
        );

        (uint256 reserve0, uint256 reserve1, , address baseToken) = pair
            .getReserves();
        uint256 totalFee = pair.getTotalFee();
        (uint256 reserveInput, uint256 reserveOutput) = input == token0
            ? (reserve0, reserve1)
            : (reserve1, reserve0);

        amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
        amountOutput = RARESwapLibrary.getAmountOut(
            amountInput,
            reserveInput,
            reserveOutput,
            baseToken != address(0),
            totalFee
        );
    }

    // **** SWAP (supporting fee-on-transfer tokens) ****
    // requires the initial amount to have already been sent to the first pair
    function _swapSupportingFeeOnTransferTokens(
        address[] memory path,
        address _to
    ) internal virtual {
        for (uint256 i; i < path.length - 1; i++) {
            (address input, address output) = (path[i], path[i + 1]);
            (address token0, ) = RARESwapLibrary.sortTokens(input, output);

            (uint256 amountInput, uint256 amountOutput) = _calculateAmounts(
                input,
                output,
                token0
            );
            (uint256 amount0Out, uint256 amount1Out) = input == token0
                ? (uint256(0), amountOutput)
                : (amountOutput, uint256(0));

            (uint256 amount0Fee, uint256 amount1Fee) = _calculateFees(
                input,
                output,
                amountInput,
                amount0Out,
                amount1Out
            );

            address to = i < path.length - 2
                ? RARESwapLibrary.pairFor(factory, output, path[i + 2])
                : _to;

            IRARESwapPair pair = IRARESwapPair(
                RARESwapLibrary.pairFor(factory, input, output)
            );
            pair.swap(
                amount0Out,
                amount1Out,
                amount0Fee,
                amount1Fee,
                to,
                new bytes(0)
            );
        }
    }

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external virtual override ensure(deadline) {
        require(path.length == 2, "RARESwapRouter: ONLY_TWO_TOKENS_ALLOWED");

        address pair = RARESwapLibrary.pairFor(factory, path[0], path[1]);
        uint256 adminFeeDeduct;
        if (path[0] == pairFeeAddress[pair]) {
            (amountIn, adminFeeDeduct) = RARESwapLibrary.adminFeeCalculation(
                amountIn,
                adminFee
            );
            TransferHelper.safeTransferFrom(
                path[0],
                msg.sender,
                feeAddressGet(),
                adminFeeDeduct
            );
        }

        TransferHelper.safeTransferFrom(path[0], msg.sender, pair, amountIn);
        uint256 balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
        _swapSupportingFeeOnTransferTokens(path, to);
        if (path[1] == pairFeeAddress[pair]) {
            (amountOutMin, adminFeeDeduct) = RARESwapLibrary
                .adminFeeCalculation(amountOutMin, adminFee);
        }
        require(
            IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >=
                amountOutMin,
            "RARESwapRouter: INSUFFICIENT_OUTPUT_AMOUNT"
        );
    }

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable virtual override ensure(deadline) {
        require(path.length == 2, "RARESwapRouter: ONLY_TWO_TOKENS_ALLOWED");
        require(path[0] == WETH, "RARESwapRouter: INVALID_PATH");
        uint256 amountIn = msg.value;

        address pair = RARESwapLibrary.pairFor(factory, path[0], path[1]);
        uint256 adminFeeDeduct;
        if (path[0] == pairFeeAddress[pair]) {
            (amountIn, adminFeeDeduct) = RARESwapLibrary.adminFeeCalculation(
                amountIn,
                adminFee
            );
            if (address(this) != feeAddressGet()) {
                payable(feeAddressGet()).transfer(adminFeeDeduct);
            }
        }

        IWETH(WETH).deposit{value: amountIn}();
        assert(IWETH(WETH).transfer(pair, amountIn));
        uint256 balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
        _swapSupportingFeeOnTransferTokens(path, to);
        if (path[1] == pairFeeAddress[pair]) {
            (amountOutMin, adminFeeDeduct) = RARESwapLibrary
                .adminFeeCalculation(amountOutMin, adminFee);
        }
        require(
            IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >=
                amountOutMin,
            "RARESwapRouter: INSUFFICIENT_OUTPUT_AMOUNT"
        );
    }

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external virtual override ensure(deadline) {
        require(path.length == 2, "RARESwapRouter: ONLY_TWO_TOKENS_ALLOWED");
        require(path[path.length - 1] == WETH, "RARESwapRouter: INVALID_PATH");
        address pair = RARESwapLibrary.pairFor(factory, path[0], path[1]);

        if (path[0] == pairFeeAddress[pair]) {
            uint256 adminFeeDeduct = (amountIn.mul(adminFee)) / (10000);
            amountIn = amountIn.sub(adminFeeDeduct);
            TransferHelper.safeTransferFrom(
                path[0],
                msg.sender,
                feeAddressGet(),
                adminFeeDeduct
            );
        }

        TransferHelper.safeTransferFrom(path[0], msg.sender, pair, amountIn);
        _swapSupportingFeeOnTransferTokens(path, address(this));
        uint256 amountOut = IERC20(WETH).balanceOf(address(this));
        amountOutMin;
        if (path[1] == pairFeeAddress[pair]) {
            uint256 adminFeeDeduct = (amountOut.mul(adminFee)) / (10000);
            amountOut = amountOut.sub(adminFeeDeduct);
        }
        IWETH(WETH).withdraw(amountOut);
        TransferHelper.safeTransferETH(to, amountOut);
    }

    // **** LIBRARY FUNCTIONS ****
    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) public pure virtual override returns (uint256 amountB) {
        return RARESwapLibrary.quote(amountA, reserveA, reserveB);
    }

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) public pure virtual override returns (uint256 amountOut) {
        return
            RARESwapLibrary.getAmountOut(
                amountIn,
                reserveIn,
                reserveOut,
                false,
                0
            );
    }

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) public pure virtual override returns (uint256 amountIn) {
        return
            RARESwapLibrary.getAmountIn(
                amountOut,
                reserveIn,
                reserveOut,
                false,
                0
            );
    }

    function getAmountsOut(uint256 amountIn, address[] memory path)
        public
        view
        virtual
        override
        returns (uint256[] memory amounts)
    {
        return RARESwapLibrary.getAmountsOut(factory, amountIn, path);
    }

    function getAmountsIn(uint256 amountOut, address[] memory path)
        public
        view
        virtual
        override
        returns (uint256[] memory amounts)
    {
        return RARESwapLibrary.getAmountsIn(factory, amountOut, path);
    }
}

pragma solidity =0.6.6;

contract RARESwapRouter is SupportingSwap {
    using SafeMath for uint256;

    address private BUSD;

    constructor(
        address _factory,
        address _WETH,
        address _BUSD,
        uint256 _adminFee,
        address _adminFeeAddress
    ) public {
        factory = _factory;
        WETH = _WETH;
        BUSD = _BUSD;
        initialize(_factory, _adminFee, _adminFeeAddress);
        IRARESwapFactory(_factory).routerInitialize(address(this));
    }

    receive() external payable {
        assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
    }

    // **** ADD LIQUIDITY ****
    function _addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin
    ) internal virtual returns (uint256 amountA, uint256 amountB) {
        // create the pair if it doesn't exist yet
        if (getPair(tokenA, tokenB) == address(0)) {
            if (tokenA == WETH) {
                IRARESwapFactory(factory).createPair(tokenB, tokenA);
                pairFeeAddress[getPair(tokenA, tokenB)] = tokenA;
            } else {
                IRARESwapFactory(factory).createPair(tokenA, tokenB);
                pairFeeAddress[getPair(tokenA, tokenB)] = tokenB;
            }
        }
        (uint256 reserveA, uint256 reserveB) = RARESwapLibrary.getReserves(
            factory,
            tokenA,
            tokenB
        );
        if (reserveA == 0 && reserveB == 0) {
            (amountA, amountB) = (amountADesired, amountBDesired);
            if (tokenA == WETH) {
                pairFeeAddress[getPair(tokenA, tokenB)] = tokenA;
            } else if (tokenA == BUSD) {
                pairFeeAddress[getPair(tokenA, tokenB)] = tokenA;
            } else {
                pairFeeAddress[getPair(tokenA, tokenB)] = tokenB;
            }
        } else {
            uint256 amountBOptimal = RARESwapLibrary.quote(
                amountADesired,
                reserveA,
                reserveB
            );
            if (amountBOptimal <= amountBDesired) {
                require(
                    amountBOptimal >= amountBMin,
                    "RARESwapRouter: INSUFFICIENT_B_AMOUNT"
                );
                (amountA, amountB) = (amountADesired, amountBOptimal);
            } else {
                uint256 amountAOptimal = RARESwapLibrary.quote(
                    amountBDesired,
                    reserveB,
                    reserveA
                );
                assert(amountAOptimal <= amountADesired);
                require(
                    amountAOptimal >= amountAMin,
                    "RARESwapRouter: INSUFFICIENT_A_AMOUNT"
                );
                (amountA, amountB) = (amountAOptimal, amountBDesired);
            }
        }
    }

    function getPair(address tokenA, address tokenB)
        public
        view
        returns (address)
    {
        return IRARESwapFactory(factory).getPair(tokenA, tokenB);
    }

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        virtual
        override
        ensure(deadline)
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        )
    {
        (amountA, amountB) = _addLiquidity(
            tokenA,
            tokenB,
            amountADesired,
            amountBDesired,
            amountAMin,
            amountBMin
        );
        address pair = RARESwapLibrary.pairFor(factory, tokenA, tokenB);
        TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
        TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
        liquidity = IRARESwapPair(pair).mint(to);
    }

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        virtual
        override
        ensure(deadline)
        returns (
            uint256 amountETH,
            uint256 amountToken,
            uint256 liquidity
        )
    {
        (amountETH, amountToken) = _addLiquidity(
            WETH,
            token,
            msg.value,
            amountTokenDesired,
            amountETHMin,
            amountTokenMin
        );
        address pair = RARESwapLibrary.pairFor(factory, token, WETH);
        TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
        IWETH(WETH).deposit{value: amountETH}();
        assert(IWETH(WETH).transfer(pair, amountETH));
        liquidity = IRARESwapPair(pair).mint(to);
        // refund dust eth, if any
        if (msg.value > amountETH)
            TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
    }

    // **** REMOVE LIQUIDITY ****
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        public
        virtual
        override
        ensure(deadline)
        returns (uint256 amountA, uint256 amountB)
    {
        address pair = RARESwapLibrary.pairFor(factory, tokenA, tokenB);
        IRARESwapPair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
        (uint256 amount0, uint256 amount1) = IRARESwapPair(pair).burn(to);
        (address token0, ) = RARESwapLibrary.sortTokens(tokenA, tokenB);
        (amountA, amountB) = tokenA == token0
            ? (amount0, amount1)
            : (amount1, amount0);
        require(amountA >= amountAMin, "RARESwapRouter: INSUFFICIENT_A_AMOUNT");
        require(amountB >= amountBMin, "RARESwapRouter: INSUFFICIENT_B_AMOUNT");
    }

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        public
        virtual
        override
        ensure(deadline)
        returns (uint256 amountToken, uint256 amountETH)
    {
        (amountToken, amountETH) = removeLiquidity(
            token,
            WETH,
            liquidity,
            amountTokenMin,
            amountETHMin,
            address(this),
            deadline
        );
        TransferHelper.safeTransfer(token, to, amountToken);
        IWETH(WETH).withdraw(amountETH);
        TransferHelper.safeTransferETH(to, amountETH);
    }

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external virtual override returns (uint256 amountA, uint256 amountB) {
        address pair = RARESwapLibrary.pairFor(factory, tokenA, tokenB);
        uint256 value = approveMax ? uint256(-1) : liquidity;
        IRARESwapPair(pair).permit(
            msg.sender,
            address(this),
            value,
            deadline,
            v,
            r,
            s
        );
        (amountA, amountB) = removeLiquidity(
            tokenA,
            tokenB,
            liquidity,
            amountAMin,
            amountBMin,
            to,
            deadline
        );
    }

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    )
        external
        virtual
        override
        returns (uint256 amountToken, uint256 amountETH)
    {
        address pair = RARESwapLibrary.pairFor(factory, token, WETH);
        uint256 value = approveMax ? uint256(-1) : liquidity;
        IRARESwapPair(pair).permit(
            msg.sender,
            address(this),
            value,
            deadline,
            v,
            r,
            s
        );
        (amountToken, amountETH) = removeLiquidityETH(
            token,
            liquidity,
            amountTokenMin,
            amountETHMin,
            to,
            deadline
        );
    }

    // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) public virtual override ensure(deadline) returns (uint256 amountETH) {
        (, amountETH) = removeLiquidity(
            token,
            WETH,
            liquidity,
            amountTokenMin,
            amountETHMin,
            address(this),
            deadline
        );
        TransferHelper.safeTransfer(
            token,
            to,
            IERC20(token).balanceOf(address(this))
        );
        IWETH(WETH).withdraw(amountETH);
        TransferHelper.safeTransferETH(to, amountETH);
    }

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external virtual override returns (uint256 amountETH) {
        address pair = RARESwapLibrary.pairFor(factory, token, WETH);
        uint256 value = approveMax ? uint256(-1) : liquidity;
        IRARESwapPair(pair).permit(
            msg.sender,
            address(this),
            value,
            deadline,
            v,
            r,
            s
        );
        amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
            token,
            liquidity,
            amountTokenMin,
            amountETHMin,
            to,
            deadline
        );
    }
}
