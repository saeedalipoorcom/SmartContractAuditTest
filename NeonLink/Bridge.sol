// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
	function owner() external view returns (address);
    function balanceOf(address account) external view returns (uint256);

	function mintTo(address account, uint256 amount) external;
	function burnFrom(address account, uint256 amount) external;
}

library TransferHelper {
	function safeTransfer(address token, address to, uint value) internal {
		(bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
		require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
	}

	function safeTransferFrom(address token, address from, address to, uint value) internal {
		(bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
		require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
	}

	function safeTransferETH(address to, uint value) internal {
		(bool success,) = to.call{value:value}(new bytes(0));
		require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
	}
}

library SafeMath {
	function add(uint256 a, uint256 b) internal pure returns (uint256) {
		uint256 c = a + b;
		require(c >= a, "SafeMath: addition overflow");

		return c;
	}
	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
		return sub(a, b, "SafeMath: subtraction overflow");
	}
	function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
		require(b <= a, errorMessage);
		uint256 c = a - b;

		return c;
	}
	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
		if (a == 0) {
			return 0;
		}

		uint256 c = a * b;
		require(c / a == b, "SafeMath: multiplication overflow");

		return c;
	}
	function div(uint256 a, uint256 b) internal pure returns (uint256) {
		return div(a, b, "SafeMath: division by zero");
	}
	function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
		require(b > 0, errorMessage);
		uint256 c = a / b;
		return c;
	}
	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
		return mod(a, b, "SafeMath: modulo by zero");
	}
	function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
		require(b != 0, errorMessage);
		return a % b;
	}
	function sqrt(uint256 y) internal pure returns (uint256 z) {
		if (y > 3) {
			z = y;
			uint256 x = y / 2 + 1;
			while (x < z) {
				z = x;
				x = (y / x + x) / 2;
			}
		} else if (y != 0) {
			z = 1;
		}
	}
}

contract Bridge {
	event Deposit(address indexed token, address indexed from, uint amount, uint targetChain);
	event Transfer(bytes32 indexed txId, uint amount);
	event AddLiquidity(address indexed sender, address indexed token, uint amount);
	event RemoveLiquidity(address indexed sender, address indexed token, uint amount);

	address public owner;
	address public admin;

	mapping(address=>bool) public isPeggingToken;
	mapping(bytes32=>bool) public exists;
	mapping(address=>mapping(address=>uint)) public pools;

	constructor(address _admin) {
		owner = msg.sender;
		admin = _admin;
	}

	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	modifier onlyAdmin() {
		require(msg.sender == admin || msg.sender == owner);
		_;
	}

	//  هر چی پول میاد برای فرستنده داخل استخر ادرس 0 پول زیاد میشه
	receive() external payable {
		pools[address(0)][msg.sender] += msg.value;
	}

	// اینجا میایم توکن پگ شده رو اضافه میکنیم / اما اول باید چک کنیم صاحب این توکن همین قرار داد بریدج باشه
	// ادمین هر توکنی با خصوصیت مالکیت رو میتونه اضافه کنه
	function addToken(address token) external onlyAdmin {
		require(IERC20(token).owner()==address(this), "bridge: owner is bridge.");
		isPeggingToken[token] = true;
	}

	// ادرس صفر همون اتریوم در نظر گرفته شده
	function addLiquidity(address token, uint amount) external payable {
		// 
		if (token==address(0)) {
			// اینجا برای ادد کردن اتریومه
			require(msg.value>0 ether);
			// استخر اتریوم برای فرستنده + مقدار جدید
			// امکان داره 2 مقدار امووونت و ولیو متفاوت باشن
			pools[token][msg.sender] += SafeMath.sub(msg.value, amount);
		} else {
			// در غیر اینصورت توکن ایی ار سی 20 هست و انتقال میدیم به ادرس قرار داد
			TransferHelper.safeTransferFrom(token, msg.sender, address(this), amount);
			// موجودی کار بر رو اضافه میکنیم
			pools[token][msg.sender] = SafeMath.add(pools[token][msg.sender], amount);
		}
		emit AddLiquidity(msg.sender, token, amount);
	}

	// هر کاربری میتونه لیکوویدیتی خودش رو حذف کنه
	function removeLiquidity(address token, uint amount) external payable {
		uint _value = pools[token][msg.sender];
		require(_value>=amount);
		if (token==address(0)) {
			// اگر کاربر قرار داد باشه / باید اینجا از رییی اینترنسی اتک استفاده کنیم
			TransferHelper.safeTransferETH(msg.sender, amount);
		} else {
			TransferHelper.safeTransfer(token, msg.sender, amount);
		}
		pools[token][msg.sender] = SafeMath.sub(_value, amount);
		emit RemoveLiquidity(msg.sender, token, amount);
	}

	// اوووونر میتونه اینجا بصورت اظطراری هر وقت هر مبلغی رو که میخاد برداشت کنه
	function emergencyWithdraw(address token, uint amount) external payable onlyOwner {
		if (token==address(0)) {
			TransferHelper.safeTransferETH(msg.sender, address(this).balance);
		} else {
			TransferHelper.safeTransfer(token, msg.sender, IERC20(token).balanceOf(address(this)));
		}
		emit RemoveLiquidity(msg.sender, token, amount);
	}

	function deposit(address target, address token, uint amount, uint targetChain) external payable {
		// چک میکنیم که کسی که توکن میفرسته کنتراکت باشه و میخاد بریدج کنه
		require(msg.sender.code.length==0, "bridge: only personal");
		// چک میکنیم آدرس زیرو رو برای   مقصد
		require(msg.sender!=address(0) && target!=address(0), "bridge: zero sender");
		// اگر اتریوم ذخیره میشه
		if (token==address(0)) {
			// ولیووو تراکنش و امووونت باید یکی باشن
			require(msg.value==amount, "bridge: amount");
		} else {
			// باید چک کنیم از مپینگ که این توکن بصورت پگ ساپورت میشه
			if (isPeggingToken[token]) {
				// اگر ساپورت میشه میایم مقدار رو از یوزر برن میکنیم !
				IERC20(token).burnFrom(msg.sender, amount);
			} else {
				// بعدی مقدار رو به ادرس کنتراکن منتقل میکنیم
				TransferHelper.safeTransferFrom(token, msg.sender, address(this), amount);
			}
		}
		emit Deposit(token, target, amount, targetChain);
	}

	function transfer(uint[][] memory args) external payable onlyAdmin {
		for(uint i=0; i<args.length; i++) {
			address _token 		= address(uint160(args[i][0]));
			address _to			= address(uint160(args[i][1]));
			uint _amount 		= args[i][2];
			bytes32 _extra 		= bytes32(args[i][3]);
			if (!exists[_extra]) {
				if (_token==address(0)) {
					TransferHelper.safeTransferETH(_to, _amount);
				} else {
					if (isPeggingToken[_token]) {
						IERC20(_token).mintTo(_to, _amount);
					} else {
						TransferHelper.safeTransfer(_token, _to, _amount);
					}
				}
				exists[_extra] = true;
				emit Transfer(_extra, _amount);
			}
		}
	}
}