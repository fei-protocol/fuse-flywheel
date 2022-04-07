// Sources flattened with hardhat v2.8.4 https://hardhat.org

// File @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol@v3.4.2

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
//pragma solidity >=0.6.2 <0.8.0;
pragma experimental ABIEncoderV2;


/**
 * @dev Collection of functions related to the address type
 */
library AddressUpgradeable {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {UpgradeableProxy-constructor}.
 *
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 */
abstract contract Initializable {

    /**
     * @dev Indicates that the contract has been initialized.
     */
    bool private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /**
     * @dev Modifier to protect an initializer function from being invoked twice.
     */
    modifier initializer() {
        require(_initializing || _isConstructor() || !_initialized, "Initializable: contract is already initialized");

        bool isTopLevelCall = !_initializing;
        if (isTopLevelCall) {
            _initializing = true;
            _initialized = true;
        }

        _;

        if (isTopLevelCall) {
            _initializing = false;
        }
    }

    /// @dev Returns true if and only if the function is running in the constructor
    function _isConstructor() private view returns (bool) {
        return !AddressUpgradeable.isContract(address(this));
    }
}

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMathUpgradeable {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract ContextUpgradeable is Initializable {
    function __Context_init() internal initializer {
        __Context_init_unchained();
    }

    function __Context_init_unchained() internal initializer {
    }
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
    uint256[50] private __gap;
}


/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20Upgradeable {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}





/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20Upgradeable is Initializable, ContextUpgradeable, IERC20Upgradeable {
    using SafeMathUpgradeable for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    function __ERC20_init(string memory name_, string memory symbol_) internal initializer {
        __Context_init_unchained();
        __ERC20_init_unchained(name_, symbol_);
    }

    function __ERC20_init_unchained(string memory name_, string memory symbol_) internal initializer {
        _name = name_;
        _symbol = symbol_;
        _decimals = 18;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
     * called.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Sets {decimals} to a value other than the default one of 18.
     *
     * WARNING: This function should only be called from the constructor. Most
     * applications that interact with token contracts will not expect
     * {decimals} to ever change, and may work incorrectly if it does.
     */
    function _setupDecimals(uint8 decimals_) internal virtual {
        _decimals = decimals_;
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
    uint256[44] private __gap;
}


/**
 * @title Compound's CToken Contract
 * @notice Abstract base for CTokens
 * @author Compound
 */
interface CToken {
    function admin() external view returns (address);
    function adminHasRights() external view returns (bool);
    function fuseAdminHasRights() external view returns (bool);
    function symbol() external view returns (string memory);
    function comptroller() external view returns (address);
    function adminFeeMantissa() external view returns (uint256);
    function fuseFeeMantissa() external view returns (uint256);
    function reserveFactorMantissa() external view returns (uint256);
    function totalReserves() external view returns (uint);
    function totalAdminFees() external view returns (uint);
    function totalFuseFees() external view returns (uint);

    function isCToken() external view returns (bool);
    function isCEther() external view returns (bool);

    function balanceOf(address owner) external view returns (uint);
    function balanceOfUnderlying(address owner) external returns (uint);
    function borrowRatePerBlock() external view returns (uint);
    function supplyRatePerBlock() external view returns (uint);
    function totalBorrowsCurrent() external returns (uint);
    function borrowBalanceStored(address account) external view returns (uint);
    function exchangeRateStored() external view returns (uint);
    function getCash() external view returns (uint);

    function redeem(uint redeemTokens) external returns (uint);
    function redeemUnderlying(uint redeemAmount) external returns (uint);
}


interface PriceOracle {
    /**
      * @notice Get the underlying price of a cToken asset
      * @param cToken The cToken to get the underlying price of
      * @return The underlying asset price mantissa (scaled by 1e18).
      *  Zero means the price is unavailable.
      */
    function getUnderlyingPrice(CToken cToken) external view returns (uint);
}


/**
 * @title ComptrollerCore
 * @dev Storage for the comptroller is at this address, while execution is delegated to the `comptrollerImplementation`.
 * CTokens should reference this contract as their comptroller.
 */
interface Unitroller {
    function _setPendingImplementation(address newPendingImplementation) external returns (uint);
    function _setPendingAdmin(address newPendingAdmin) external returns (uint);
}

/**
 * @title RewardsDistributor
 * @author Compound
 */
interface RewardsDistributor {
    /// @dev The token to reward (i.e., COMP)
    function rewardToken() external view returns (address);

    /// @notice The portion of compRate that each market currently receives
    function compSupplySpeeds(address) external view returns (uint);

    /// @notice The portion of compRate that each market currently receives
    function compBorrowSpeeds(address) external view returns (uint);

    /// @notice The COMP accrued but not yet transferred to each user
    function compAccrued(address) external view returns (uint);

    /**
     * @notice Keeps the flywheel moving pre-mint and pre-redeem
     * @dev Called by the Comptroller
     * @param cToken The relevant market
     * @param supplier The minter/redeemer
     */
    function flywheelPreSupplierAction(address cToken, address supplier) external;

    /**
     * @notice Keeps the flywheel moving pre-borrow and pre-repay
     * @dev Called by the Comptroller
     * @param cToken The relevant market
     * @param borrower The borrower
     */
    function flywheelPreBorrowerAction(address cToken, address borrower) external;

    /**
     * @notice Returns an array of all markets.
     */
    function getAllMarkets() external view returns (CToken[] memory);
}



/**
 * @title Compound's Comptroller Contract
 * @author Compound
 */
interface Comptroller {
    function admin() external view returns (address);
    function adminHasRights() external view returns (bool);
    function fuseAdminHasRights() external view returns (bool);

    function oracle() external view returns (PriceOracle);
    function closeFactorMantissa() external view returns (uint);
    function liquidationIncentiveMantissa() external view returns (uint);

    function markets(address cToken) external view returns (bool, uint);

    function getAssetsIn(address account) external view returns (CToken[] memory);
    function checkMembership(address account, CToken cToken) external view returns (bool);
    function getAccountLiquidity(address account) external view returns (uint, uint, uint);

    function _setPriceOracle(PriceOracle newOracle) external returns (uint);
    function _setCloseFactor(uint newCloseFactorMantissa) external returns (uint256);
    function _setLiquidationIncentive(uint newLiquidationIncentiveMantissa) external returns (uint);
    function _become(Unitroller unitroller) external;

    function borrowGuardianPaused(address cToken) external view returns (bool);

    function getRewardsDistributors() external view returns (RewardsDistributor[] memory);
    function getAllMarkets() external view returns (CToken[] memory);
    function getAllBorrowers() external view returns (address[] memory);
    function suppliers(address account) external view returns (bool);
    function enforceWhitelist() external view returns (bool);
    function whitelist(address account) external view returns (bool);

    function _setWhitelistEnforcement(bool enforce) external returns (uint);
    function _setWhitelistStatuses(address[] calldata _suppliers, bool[] calldata statuses) external returns (uint);

    function _toggleAutoImplementations(bool enabled) external returns (uint);
}

/**
 * @title Compound's CErc20 Contract
 * @notice CTokens which wrap an EIP-20 underlying
 * @author Compound
 */
interface CErc20 is CToken {
    function underlying() external view returns (address);
    function liquidateBorrow(address borrower, uint repayAmount, CToken cTokenCollateral) external returns (uint);
}


interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    function __Ownable_init() internal initializer {
        __Context_init_unchained();
        __Ownable_init_unchained();
    }

    function __Ownable_init_unchained() internal initializer {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
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
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
    uint256[49] private __gap;
}





/**
 * @title FusePoolDirectory
 * @author David Lucid <david@rari.capital> (https://github.com/davidlucid)
 * @notice FusePoolDirectory is a directory for Fuse interest rate pools.
 */
contract FusePoolDirectory is OwnableUpgradeable {
    /**
     * @dev Initializes a deployer whitelist if desired.
     * @param _enforceDeployerWhitelist Boolean indicating if the deployer whitelist is to be enforced.
     * @param _deployerWhitelist Array of Ethereum accounts to be whitelisted.
     */
    function initialize(bool _enforceDeployerWhitelist, address[] memory _deployerWhitelist) public initializer {
        __Ownable_init();
        enforceDeployerWhitelist = _enforceDeployerWhitelist;
        for (uint256 i = 0; i < _deployerWhitelist.length; i++) deployerWhitelist[_deployerWhitelist[i]] = true;
    }

    /**
     * @dev Struct for a Fuse interest rate pool.
     */
    struct FusePool {
        string name;
        address creator;
        address comptroller;
        uint256 blockPosted;
        uint256 timestampPosted;
    }

    /**
     * @dev Array of Fuse interest rate pools.
     */
    FusePool[] public pools;

    /**
     * @dev Maps Ethereum accounts to arrays of Fuse pool indexes.
     */
    mapping(address => uint256[]) private _poolsByAccount;

    /**
     * @dev Maps Fuse pool Comptroller addresses to bools indicating if they have been registered via the directory.
     */
    mapping(address => bool) public poolExists;

    /**
     * @dev Emitted when a new Fuse pool is added to the directory.
     */
    event PoolRegistered(uint256 index, FusePool pool);

    /**
     * @dev Booleans indicating if the deployer whitelist is enforced.
     */
    bool public enforceDeployerWhitelist;

    /**
     * @dev Maps Ethereum accounts to booleans indicating if they are allowed to deploy pools.
     */
    mapping(address => bool) public deployerWhitelist;

    /**
     * @dev Controls if the deployer whitelist is to be enforced.
     * @param enforce Boolean indicating if the deployer whitelist is to be enforced.
     */
    function _setDeployerWhitelistEnforcement(bool enforce) external onlyOwner {
        enforceDeployerWhitelist = enforce;
    }

    /**
     * @dev Adds/removes Ethereum accounts to the deployer whitelist.
     * @param deployers Array of Ethereum accounts to be whitelisted.
     * @param status Whether to add or remove the accounts.
     */
    function _editDeployerWhitelist(address[] calldata deployers, bool status) external onlyOwner {
        require(deployers.length > 0, "No deployers supplied.");
        for (uint256 i = 0; i < deployers.length; i++) deployerWhitelist[deployers[i]] = status;
    }

    /**
     * @dev Adds a new Fuse pool to the directory (without checking msg.sender).
     * @param name The name of the pool.
     * @param comptroller The pool's Comptroller proxy contract address.
     * @return The index of the registered Fuse pool.
     */
    function _registerPool(string memory name, address comptroller) internal returns (uint256) {
        require(!poolExists[comptroller], "Pool already exists in the directory.");
        require(!enforceDeployerWhitelist || deployerWhitelist[msg.sender], "Sender is not on deployer whitelist.");
        require(bytes(name).length <= 100, "No pool name supplied.");
        FusePool memory pool = FusePool(name, msg.sender, comptroller, block.number, block.timestamp);
        pools.push(pool);
        _poolsByAccount[msg.sender].push(pools.length - 1);
        poolExists[comptroller] = true;
        emit PoolRegistered(pools.length - 1, pool);
        return pools.length - 1;
    }

    /**
     * @dev Deploys a new Fuse pool and adds to the directory.
     * @param name The name of the pool.
     * @param implementation The Comptroller implementation contract address.
     * @param enforceWhitelist Boolean indicating if the pool's supplier/borrower whitelist is to be enforced.
     * @param closeFactor The pool's close factor (scaled by 1e18).
     * @param liquidationIncentive The pool's liquidation incentive (scaled by 1e18).
     * @param priceOracle The pool's PriceOracle contract address.
     * @return The index of the registered Fuse pool and the Unitroller proxy address.
     */
    function deployPool(string memory name, address implementation, bool enforceWhitelist, uint256 closeFactor, uint256 liquidationIncentive, address priceOracle) external virtual returns (uint256, address) {
        // Input validation
        require(implementation != address(0), "No Comptroller implementation contract address specified.");
        require(priceOracle != address(0), "No PriceOracle contract address specified.");

        // Deploy Unitroller using msg.sender, name, and block.number as a salt
        bytes memory unitrollerCreationCode = hex"60806040526001805460ff60a81b1960ff60a01b19909116600160a01b1716600160a81b17905534801561003257600080fd5b50600080546001600160a01b03191633179055610ae1806100546000396000f3fe6080604052600436106100a75760003560e01c8063bb82aa5e11610064578063bb82aa5e14610437578063c1e803341461044c578063dcfbc0c714610461578063e992a04114610476578063e9c714f2146104a9578063f851a440146104be576100a7565b80630225ab9d1461032b5780630a755ec21461036957806326782247146103925780632f1069ba146103c35780636f63af0b146103d8578063b71d1a0c14610404575b3330146102a85760408051600481526024810182526020810180516001600160e01b0316633757348b60e21b1781529151815160009360609330939092909182918083835b6020831061010b5780518252601f1990920191602091820191016100ec565b6001836020036101000a038019825116818451168082178552505050505050905001915050600060405180830381855afa9150503d806000811461016b576040519150601f19603f3d011682016040523d82523d6000602084013e610170565b606091505b5091509150600082156101975781806020019051602081101561019257600080fd5b505190505b80156102a4576002546040805163bbcdd6d360e01b81526001600160a01b0390921660048301525160009173a731585ab05fc9f83555cf9bff8f58ee94e18f859163bbcdd6d391602480820192602092909190829003018186803b1580156101fe57600080fd5b505afa158015610212573d6000803e3d6000fd5b505050506040513d602081101561022857600080fd5b50516002549091506001600160a01b038083169116146102a257600280546001600160a01b038381166001600160a01b0319831617928390556040805192821680845293909116602083015280517fd604de94d45953f9138079ec1b82d533cb2160c906d1076d1f7ed54befbca97a9281900390910190a1505b505b5050505b6002546040516000916001600160a01b031690829036908083838082843760405192019450600093509091505080830381855af49150503d806000811461030b576040519150601f19603f3d011682016040523d82523d6000602084013e610310565b606091505b505090506040513d6000823e818015610327573d82f35b3d82fd5b34801561033757600080fd5b506103576004803603602081101561034e57600080fd5b503515156104d3565b60408051918252519081900360200190f35b34801561037557600080fd5b5061037e61056f565b604080519115158252519081900360200190f35b34801561039e57600080fd5b506103a761057f565b604080516001600160a01b039092168252519081900360200190f35b3480156103cf57600080fd5b5061037e61058e565b3480156103e457600080fd5b50610357600480360360208110156103fb57600080fd5b5035151561059e565b34801561041057600080fd5b506103576004803603602081101561042757600080fd5b50356001600160a01b031661063a565b34801561044357600080fd5b506103a76106bd565b34801561045857600080fd5b506103576106cc565b34801561046d57600080fd5b506103a76107c7565b34801561048257600080fd5b506103576004803603602081101561049957600080fd5b50356001600160a01b03166107d6565b3480156104b557600080fd5b506103576108f6565b3480156104ca57600080fd5b506103a76109dc565b60006104dd6109eb565b6104f4576104ed60016005610a46565b905061056a565b60015460ff600160a81b90910416151582151514156105145760006104ed565b60018054831515600160a81b810260ff60a81b199092169190911790915560408051918252517f10f9a0a95673b0837d1dce21fd3bffcb6d760435e9b5300b75a271182f75f8229181900360200190a160005b90505b919050565b600154600160a81b900460ff1681565b6001546001600160a01b031681565b600154600160a01b900460ff1681565b60006105a86109eb565b6105b8576104ed60016005610a46565b60015460ff600160a01b90910416151582151514156105d85760006104ed565b60018054831515600160a01b90810260ff60a01b199092169190911791829055604080519190920460ff161515815290517fabb56a15fd39488c914b324690b88f30d7daec63d2131ca0ef47e5739068c86e9181900360200190a16000610567565b60006106446109eb565b610654576104ed60016010610a46565b600180546001600160a01b038481166001600160a01b0319831681179093556040805191909216808252602082019390935281517fca4f2f25d0898edd99413412fb94012f9e54ec8142f9b093e7720646a95b16a9929181900390910190a160005b9392505050565b6002546001600160a01b031681565b6003546000906001600160a01b0316331415806106f257506003546001600160a01b0316155b1561070957610702600180610a46565b90506107c4565b60028054600380546001600160a01b038082166001600160a01b031980861682179687905590921690925560408051938316808552949092166020840152815190927fd604de94d45953f9138079ec1b82d533cb2160c906d1076d1f7ed54befbca97a92908290030190a1600354604080516001600160a01b038085168252909216602083015280517fe945ccee5d701fc83f9b8aa8ca94ea4219ec1fcbd4f4cab4f0ea57c5c3e1d8159281900390910190a160005b925050505b90565b6003546001600160a01b031681565b60006107e06109eb565b6107f0576104ed60016012610a46565b60025460408051639d244f9f60e01b81526001600160a01b03928316600482015291841660248301525173a731585ab05fc9f83555cf9bff8f58ee94e18f8591639d244f9f916044808301926020929190829003018186803b15801561085557600080fd5b505afa158015610869573d6000803e3d6000fd5b505050506040513d602081101561087f57600080fd5b5051610891576104ed60016011610a46565b600380546001600160a01b038481166001600160a01b0319831617928390556040805192821680845293909116602083015280517fe945ccee5d701fc83f9b8aa8ca94ea4219ec1fcbd4f4cab4f0ea57c5c3e1d8159281900390910190a160006106b6565b6001546000906001600160a01b031633141580610911575033155b156109225761070260016000610a46565b60008054600180546001600160a01b038082166001600160a01b031980861682179687905590921690925560408051938316808552949092166020840152815190927ff9ffabca9c8276e99321725bcb43fb076a6c66a54b7f21c4e8146d8519b417dc92908290030190a1600154604080516001600160a01b038085168252909216602083015280517fca4f2f25d0898edd99413412fb94012f9e54ec8142f9b093e7720646a95b16a99281900390910190a160006107bf565b6000546001600160a01b031681565b600080546001600160a01b031633148015610a0f5750600154600160a81b900460ff165b80610a4157503373a731585ab05fc9f83555cf9bff8f58ee94e18f85148015610a415750600154600160a01b900460ff165b905090565b60007f45b96fe442630264581b197e84bbada861235052c5a1aadfff9ea4e40a969aa0836015811115610a7557fe5b83601b811115610a8157fe5b604080519283526020830191909152600082820152519081900360600190a18260158111156106b657fefea265627a7a72315820a5cf9491a370c17ee98b3c08c728cc0ddad83bd43ca76c92dc106835bfccb25664736f6c63430005110032";
        bytes32 salt = keccak256(abi.encodePacked(msg.sender, name, block.number));
        address proxy;

        assembly {
            proxy := create2(0, add(unitrollerCreationCode, 32), mload(unitrollerCreationCode), salt)
            if iszero(extcodesize(proxy)) {
                revert(0, "Failed to deploy Unitroller.")
            }
        }

        // Setup Unitroller
        Unitroller unitroller = Unitroller(proxy);
        require(unitroller._setPendingImplementation(implementation) == 0, "Failed to set pending implementation on Unitroller."); // Checks Comptroller implementation whitelist
        Comptroller comptrollerImplementation = Comptroller(implementation);
        comptrollerImplementation._become(unitroller);
        Comptroller comptrollerProxy = Comptroller(proxy);

        // Set pool parameters
        require(comptrollerProxy._setCloseFactor(closeFactor) == 0, "Failed to set pool close factor.");
        require(comptrollerProxy._setLiquidationIncentive(liquidationIncentive) == 0, "Failed to set pool liquidation incentive.");
        require(comptrollerProxy._setPriceOracle(PriceOracle(priceOracle)) == 0, "Failed to set pool price oracle.");

        // Whitelist
        if (enforceWhitelist) require(comptrollerProxy._setWhitelistEnforcement(true) == 0, "Failed to enforce supplier/borrower whitelist.");

        // Enable auto-implementation
        require(comptrollerProxy._toggleAutoImplementations(true) == 0, "Failed to enable pool auto implementations.");

        // Make msg.sender the admin
        require(unitroller._setPendingAdmin(msg.sender) == 0, "Failed to set pending admin on Unitroller.");

        // Register the pool with this FusePoolDirectory
        return (_registerPool(name, proxy), proxy);
    }

    /**
     * @notice Returns arrays of all Fuse pools' data.
     * @dev This function is not designed to be called in a transaction: it is too gas-intensive.
     */
    function getAllPools() external view returns (FusePool[] memory) {
        return pools;
    }

    /**
     * @notice Returns arrays of all public Fuse pool indexes and data.
     * @dev This function is not designed to be called in a transaction: it is too gas-intensive.
     */
    function getPublicPools() external view returns (uint256[] memory, FusePool[] memory) {
        uint256 arrayLength = 0;

        for (uint256 i = 0; i < pools.length; i++) {
            try Comptroller(pools[i].comptroller).enforceWhitelist() returns (bool enforceWhitelist) {
                if (enforceWhitelist) continue;
            } catch { }

            arrayLength++;
        }

        uint256[] memory indexes = new uint256[](arrayLength);
        FusePool[] memory publicPools = new FusePool[](arrayLength);
        uint256 index = 0;

        for (uint256 i = 0; i < pools.length; i++) {
            try Comptroller(pools[i].comptroller).enforceWhitelist() returns (bool enforceWhitelist) {
                if (enforceWhitelist) continue;
            } catch { }

            indexes[index] = i;
            publicPools[index] = pools[i];
            index++;
        }

        return (indexes, publicPools);
    }

    /**
     * @notice Returns arrays of Fuse pool indexes and data created by `account`.
     */
    function getPoolsByAccount(address account) external view returns (uint256[] memory, FusePool[] memory) {
        uint256[] memory indexes = new uint256[](_poolsByAccount[account].length);
        FusePool[] memory accountPools = new FusePool[](_poolsByAccount[account].length);

        for (uint256 i = 0; i < _poolsByAccount[account].length; i++) {
            indexes[i] = _poolsByAccount[account][i];
            accountPools[i] = pools[_poolsByAccount[account][i]];
        }

        return (indexes, accountPools);
    }

    /**
     * @dev Maps Ethereum accounts to arrays of Fuse pool Comptroller proxy contract addresses.
     */
    mapping(address => address[]) private _bookmarks;

    /**
     * @notice Returns arrays of Fuse pool Unitroller (Comptroller proxy) contract addresses bookmarked by `account`.
     */
    function getBookmarks(address account) external view returns (address[] memory) {
        return _bookmarks[account];
    }

    /**
     * @notice Bookmarks a Fuse pool Unitroller (Comptroller proxy) contract addresses.
     */
    function bookmarkPool(address comptroller) external {
        _bookmarks[msg.sender].push(comptroller);
    }

    /**
     * @notice Modify existing Fuse pool name.
     */
    function setPoolName(uint256 index, string calldata name) external {
        Comptroller _comptroller = Comptroller(pools[index].comptroller);
        require(msg.sender == _comptroller.admin() && _comptroller.adminHasRights() || msg.sender == owner());
        pools[index].name = name;
    }

    /**
     * @dev Maps Ethereum accounts to booleans indicating if they are a whitelisted admin.
     */
    mapping(address => bool) public adminWhitelist;

    /**
     * @dev Event emitted when the admin whitelist is updated.
     */
    event AdminWhitelistUpdated(address[] admins, bool status);

    /**
     * @dev Adds/removes Ethereum accounts to the admin whitelist.
     * @param admins Array of Ethereum accounts to be whitelisted.
     * @param status Whether to add or remove the accounts.
     */
    function _editAdminWhitelist(address[] calldata admins, bool status) external onlyOwner {
        require(admins.length > 0, "No admins supplied.");
        for (uint256 i = 0; i < admins.length; i++) adminWhitelist[admins[i]] = status;
        emit AdminWhitelistUpdated(admins, status);
    }

    /**
     * @notice Returns arrays of all public Fuse pool indexes and data with whitelisted admins.
     * @dev This function is not designed to be called in a transaction: it is too gas-intensive.
     */
    function getPublicPoolsByVerification(bool whitelistedAdmin) external view returns (uint256[] memory, FusePool[] memory) {
        uint256 arrayLength = 0;

        for (uint256 i = 0; i < pools.length; i++) {
            Comptroller comptroller = Comptroller(pools[i].comptroller);

            try comptroller.enforceWhitelist() returns (bool enforceWhitelist) {
                if (enforceWhitelist) continue;

                try comptroller.admin() returns (address admin) {
                    if (whitelistedAdmin != adminWhitelist[admin]) continue;
                } catch { }
            } catch { }

            arrayLength++;
        }

        uint256[] memory indexes = new uint256[](arrayLength);
        FusePool[] memory publicPools = new FusePool[](arrayLength);
        uint256 index = 0;

        for (uint256 i = 0; i < pools.length; i++) {
            Comptroller comptroller = Comptroller(pools[i].comptroller);

            try comptroller.enforceWhitelist() returns (bool enforceWhitelist) {
                if (enforceWhitelist) continue;

                try comptroller.admin() returns (address admin) {
                    if (whitelistedAdmin != adminWhitelist[admin]) continue;
                } catch { }
            } catch { }

            indexes[index] = i;
            publicPools[index] = pools[i];
            index++;
        }

        return (indexes, publicPools);
    }
}


/**
 * @title BasePriceOracle
 * @notice Returns prices of underlying tokens directly without the caller having to specify a cToken address.
 * @dev Implements the `PriceOracle` interface.
 * @author David Lucid <david@rari.capital> (https://github.com/davidlucid)
 */
interface BasePriceOracle is PriceOracle {
    /**
     * @notice Get the price of an underlying asset.
     * @param underlying The underlying asset to get the price of.
     * @return The underlying asset price in ETH as a mantissa (scaled by 1e18).
     * Zero means the price is unavailable.
     */
    function price(address underlying) external view returns (uint);
}



/**
 * @title MasterPriceOracle
 * @notice Use a combination of price oracles.
 * @dev Implements `PriceOracle`.
 * @author David Lucid <david@rari.capital> (https://github.com/davidlucid)
 */
contract MasterPriceOracle is Initializable, PriceOracle, BasePriceOracle {
    /**
     * @dev Maps underlying token addresses to `PriceOracle` contracts (can be `BasePriceOracle` contracts too).
     */
    mapping(address => PriceOracle) public oracles;

    /**
     * @dev Default/fallback `PriceOracle`.
     */
    PriceOracle public defaultOracle;

    /**
     * @dev The administrator of this `MasterPriceOracle`.
     */
    address public admin;

    /**
     * @dev Controls if `admin` can overwrite existing assignments of oracles to underlying tokens.
     */
    bool internal noAdminOverwrite;

    /**
     * @dev Returns a boolean indicating if `admin` can overwrite existing assignments of oracles to underlying tokens.
     */
    function canAdminOverwrite() external view returns (bool) {
        return !noAdminOverwrite;
    }

    /**
     * @dev Event emitted when `admin` is changed.
     */
    event NewAdmin(address oldAdmin, address newAdmin);

    /**
     * @dev Event emitted when the default oracle is changed.
     */
    event NewDefaultOracle(address oldOracle, address newOracle);

    /**
     * @dev Event emitted when an underlying token's oracle is changed.
     */
    event NewOracle(address underlying, address oldOracle, address newOracle);

    /**
     * @dev Constructor to initialize state variables.
     * @param underlyings The underlying ERC20 token addresses to link to `_oracles`.
     * @param _oracles The `PriceOracle` contracts to be assigned to `underlyings`.
     * @param _defaultOracle The default `PriceOracle` contract to use.
     * @param _admin The admin who can assign oracles to underlying tokens.
     * @param _canAdminOverwrite Controls if `admin` can overwrite existing assignments of oracles to underlying tokens.
     */
    function initialize(address[] memory underlyings, PriceOracle[] memory _oracles, PriceOracle _defaultOracle, address _admin, bool _canAdminOverwrite) external initializer {
        // Input validation
        require(underlyings.length == _oracles.length, "Lengths of both arrays must be equal.");

        // Initialize state variables
        for (uint256 i = 0; i < underlyings.length; i++) {
            address underlying = underlyings[i];
            PriceOracle newOracle = _oracles[i];
            oracles[underlying] = newOracle;
            emit NewOracle(underlying, address(0), address(newOracle));
        }

        defaultOracle = _defaultOracle;
        admin = _admin;
        noAdminOverwrite = !_canAdminOverwrite;
    }

    /**
     * @dev Sets `_oracles` for `underlyings`.
     */
    function add(address[] calldata underlyings, PriceOracle[] calldata _oracles) external onlyAdmin {
        // Input validation
        require(underlyings.length > 0 && underlyings.length == _oracles.length, "Lengths of both arrays must be equal and greater than 0.");

        // Assign oracles to underlying tokens
        for (uint256 i = 0; i < underlyings.length; i++) {
            address underlying = underlyings[i];
            address oldOracle = address(oracles[underlying]);
            if (noAdminOverwrite) require(oldOracle == address(0), "Admin cannot overwrite existing assignments of oracles to underlying tokens.");
            PriceOracle newOracle = _oracles[i];
            oracles[underlying] = newOracle;
            emit NewOracle(underlying, oldOracle, address(newOracle));
        }
    }

    /**
     * @dev Changes the admin and emits an event.
     */
    function setDefaultOracle(PriceOracle newOracle) external onlyAdmin {
        PriceOracle oldOracle = defaultOracle;
        defaultOracle = newOracle;
        emit NewDefaultOracle(address(oldOracle), address(newOracle));
    }

    /**
     * @dev Changes the admin and emits an event.
     */
    function changeAdmin(address newAdmin) external onlyAdmin {
        address oldAdmin = admin;
        admin = newAdmin;
        emit NewAdmin(oldAdmin, newAdmin);
    }

    /**
     * @dev Modifier that checks if `msg.sender == admin`.
     */
    modifier onlyAdmin {
        require(msg.sender == admin, "Sender is not the admin.");
        _;
    }

    /**
     * @notice Returns the price in ETH of the token underlying `cToken`.
     * @dev Implements the `PriceOracle` interface for Fuse pools (and Compound v2).
     * @return Price in ETH of the token underlying `cToken`, scaled by `10 ** (36 - underlyingDecimals)`.
     */
    function getUnderlyingPrice(CToken cToken) external override view returns (uint) {
        // Get underlying ERC20 token address
        address underlying = address(CErc20(address(cToken)).underlying());

        // Return 1e18 for ETH
        if (underlying == address(0)) return 1e18;

        // Get underlying price from assigned oracle
        PriceOracle oracle = oracles[underlying];
        if (address(oracle) != address(0)) return oracle.getUnderlyingPrice(cToken);
        if (address(defaultOracle) != address(0)) return defaultOracle.getUnderlyingPrice(cToken);
        revert("Price oracle not found for this underlying token address.");
    }

    /**
     * @dev Attempts to return the price in ETH of `underlying` (implements `BasePriceOracle`).
     */
    function price(address underlying) external override view returns (uint) {
        // Get underlying price from assigned oracle
        PriceOracle oracle = oracles[underlying];
        if (address(oracle) != address(0)) return BasePriceOracle(address(oracle)).price(underlying);
        if (address(defaultOracle) != address(0)) return BasePriceOracle(address(defaultOracle)).price(underlying);
        revert("Price oracle not found for this underlying token address.");
    }
}









/**
 * @title FusePoolLens
 * @author David Lucid <david@rari.capital> (https://github.com/davidlucid)
 * @notice FusePoolLens returns data on Fuse interest rate pools in mass for viewing by dApps, bots, etc.
 */
contract FusePoolLens is Initializable {
    using SafeMathUpgradeable for uint256;

    /**
     * @notice Constructor to set the `FusePoolDirectory` contract object.
     */
    function initialize(FusePoolDirectory _directory) public initializer {
        require(address(_directory) != address(0), "FusePoolDirectory instance cannot be the zero address.");
        directory = _directory;
    }

    /**
     * @notice `FusePoolDirectory` contract object.
     */
    FusePoolDirectory public directory;

    /**
     * @dev Struct for Fuse pool summary data.
     */
    struct FusePoolData {
        uint256 totalSupply;
        uint256 totalBorrow;
        address[] underlyingTokens;
        string[] underlyingSymbols;
        bool whitelistedAdmin;
    }

    /**
     * @notice Returns arrays of all public Fuse pool indexes, data, total supply balances (in ETH), total borrow balances (in ETH), arrays of underlying token addresses, arrays of underlying asset symbols, and booleans indicating if retrieving each pool's data failed.
     * @dev This function is not designed to be called in a transaction: it is too gas-intensive.
     * Ideally, we can add the `view` modifier, but many cToken functions potentially modify the state.
     */
    function getPublicPoolsWithData() external returns (uint256[] memory, FusePoolDirectory.FusePool[] memory, FusePoolData[] memory, bool[] memory) {
        (uint256[] memory indexes, FusePoolDirectory.FusePool[] memory publicPools) = directory.getPublicPools();
        (FusePoolData[] memory data, bool[] memory errored) = getPoolsData(publicPools);
        return (indexes, publicPools, data, errored);
    }

    /**
     * @notice Returns arrays of all whitelisted public Fuse pool indexes, data, total supply balances (in ETH), total borrow balances (in ETH), arrays of underlying token addresses, arrays of underlying asset symbols, and booleans indicating if retrieving each pool's data failed.
     * @dev This function is not designed to be called in a transaction: it is too gas-intensive.
     * Ideally, we can add the `view` modifier, but many cToken functions potentially modify the state.
     */
    function getPublicPoolsByVerificationWithData(bool whitelistedAdmin) external returns (uint256[] memory, FusePoolDirectory.FusePool[] memory, FusePoolData[] memory, bool[] memory) {
        (uint256[] memory indexes, FusePoolDirectory.FusePool[] memory publicPools) = directory.getPublicPoolsByVerification(whitelistedAdmin);
        (FusePoolData[] memory data, bool[] memory errored) = getPoolsData(publicPools);
        return (indexes, publicPools, data, errored);
    }

    /**
     * @notice Returns arrays of the indexes of Fuse pools created by `account`, data, total supply balances (in ETH), total borrow balances (in ETH), arrays of underlying token addresses, arrays of underlying asset symbols, and booleans indicating if retrieving each pool's data failed.
     * @dev This function is not designed to be called in a transaction: it is too gas-intensive.
     * Ideally, we can add the `view` modifier, but many cToken functions potentially modify the state.
     */
    function getPoolsByAccountWithData(address account) external returns (uint256[] memory, FusePoolDirectory.FusePool[] memory, FusePoolData[] memory, bool[] memory) {
        (uint256[] memory indexes, FusePoolDirectory.FusePool[] memory accountPools) = directory.getPoolsByAccount(account);
        (FusePoolData[] memory data, bool[] memory errored) = getPoolsData(accountPools);
        return (indexes, accountPools, data, errored);
    }

    /**
     * @notice Internal function returning arrays of requested Fuse pool indexes, data, total supply balances (in ETH), total borrow balances (in ETH), arrays of underlying token addresses, arrays of underlying asset symbols, and booleans indicating if retrieving each pool's data failed.
     * @dev This function is not designed to be called in a transaction: it is too gas-intensive.
     * Ideally, we can add the `view` modifier, but many cToken functions potentially modify the state.
     */
    function getPoolsData(FusePoolDirectory.FusePool[] memory pools) internal returns (FusePoolData[] memory, bool[] memory) {
        FusePoolData[] memory data = new FusePoolData[](pools.length);
        bool[] memory errored = new bool[](pools.length);
        
        for (uint256 i = 0; i < pools.length; i++) {
            try this.getPoolSummary(Comptroller(pools[i].comptroller)) returns (uint256 _totalSupply, uint256 _totalBorrow, address[] memory _underlyingTokens, string[] memory _underlyingSymbols, bool _whitelistedAdmin) {
                data[i] = FusePoolData(_totalSupply, _totalBorrow, _underlyingTokens, _underlyingSymbols, _whitelistedAdmin);
            } catch {
                errored[i] = true;
            }
        }

        return (data, errored);
    }

    /**
     * @notice Returns total supply balance (in ETH), total borrow balance (in ETH), underlying token addresses, and underlying token symbols of a Fuse pool.
     */
    function getPoolSummary(Comptroller comptroller) external returns (uint256, uint256, address[] memory, string[] memory, bool) {
        uint256 totalBorrow = 0;
        uint256 totalSupply = 0;
        CToken[] memory cTokens = comptroller.getAllMarkets();
        address[] memory underlyingTokens = new address[](cTokens.length);
        string[] memory underlyingSymbols = new string[](cTokens.length);
        PriceOracle oracle = comptroller.oracle();

        for (uint256 i = 0; i < cTokens.length; i++) {
            CToken cToken = cTokens[i];
            (bool isListed, ) = comptroller.markets(address(cToken));
            if (!isListed) continue;
            uint256 assetTotalBorrow = cToken.totalBorrowsCurrent();
            uint256 assetTotalSupply = cToken.getCash().add(assetTotalBorrow).sub(cToken.totalReserves().add(cToken.totalAdminFees()).add(cToken.totalFuseFees()));
            uint256 underlyingPrice = oracle.getUnderlyingPrice(cToken);
            totalBorrow = totalBorrow.add(assetTotalBorrow.mul(underlyingPrice).div(1e18));
            totalSupply = totalSupply.add(assetTotalSupply.mul(underlyingPrice).div(1e18));

            if (cToken.isCEther()) {
                underlyingTokens[i] = address(0);
                underlyingSymbols[i] = "ETH";
            } else {
                underlyingTokens[i] = CErc20(address(cToken)).underlying();
                (, underlyingSymbols[i]) = getTokenNameAndSymbol(underlyingTokens[i]);
            }
        }

        bool whitelistedAdmin = directory.adminWhitelist(comptroller.admin());
        return (totalSupply, totalBorrow, underlyingTokens, underlyingSymbols, whitelistedAdmin);
    }

    /**
     * @dev Struct for a Fuse pool asset.
     */
    struct FusePoolAsset {
        address cToken;
        address underlyingToken;
        string underlyingName;
        string underlyingSymbol;
        uint256 underlyingDecimals;
        uint256 underlyingBalance;
        uint256 supplyRatePerBlock;
        uint256 borrowRatePerBlock;
        uint256 totalSupply;
        uint256 totalBorrow;
        uint256 supplyBalance;
        uint256 borrowBalance;
        uint256 liquidity;
        bool membership;
        uint256 exchangeRate; // Price of cTokens in terms of underlying tokens
        uint256 underlyingPrice; // Price of underlying tokens in ETH (scaled by 1e18)
        address oracle;
        uint256 collateralFactor;
        uint256 reserveFactor;
        uint256 adminFee;
        uint256 fuseFee;
        bool borrowGuardianPaused;
    }

    /**
     * @notice Returns data on the specified assets of the specified Fuse pool.
     * @dev This function is not designed to be called in a transaction: it is too gas-intensive.
     * Ideally, we can add the `view` modifier, but many cToken functions potentially modify the state.
     * @param comptroller The Comptroller proxy contract address of the Fuse pool.
     * @param cTokens The cToken contract addresses of the assets to query.
     * @param user The user for which to get account data.
     * @return An array of Fuse pool assets.
     */
    function getPoolAssetsWithData(Comptroller comptroller, CToken[] memory cTokens, address user) internal returns (FusePoolAsset[] memory) {
        uint256 arrayLength = 0;

        for (uint256 i = 0; i < cTokens.length; i++) {
            (bool isListed, ) = comptroller.markets(address(cTokens[i]));
            if (isListed) arrayLength++;
        }

        FusePoolAsset[] memory detailedAssets = new FusePoolAsset[](arrayLength);
        uint256 index = 0;
        PriceOracle oracle = comptroller.oracle();

        for (uint256 i = 0; i < cTokens.length; i++) {
            // Check if market is listed and get collateral factor
            (bool isListed, uint256 collateralFactorMantissa) = comptroller.markets(address(cTokens[i]));
            if (!isListed) continue;

            // Start adding data to FusePoolAsset
            FusePoolAsset memory asset;
            CToken cToken = cTokens[i];
            asset.cToken = address(cToken);

            // Get underlying asset data
            if (cToken.isCEther()) {
                asset.underlyingName = "Ethereum";
                asset.underlyingSymbol = "ETH";
                asset.underlyingDecimals = 18;
                asset.underlyingBalance = user.balance;
            } else {
                asset.underlyingToken = CErc20(address(cToken)).underlying();
                ERC20Upgradeable underlying = ERC20Upgradeable(asset.underlyingToken);
                (asset.underlyingName, asset.underlyingSymbol) = getTokenNameAndSymbol(asset.underlyingToken);
                asset.underlyingDecimals = underlying.decimals();
                asset.underlyingBalance = underlying.balanceOf(user);
            }

            // Get cToken data
            asset.supplyRatePerBlock = cToken.supplyRatePerBlock();
            asset.borrowRatePerBlock = cToken.borrowRatePerBlock();
            asset.liquidity = cToken.getCash();
            asset.totalBorrow = cToken.totalBorrowsCurrent();
            asset.totalSupply = asset.liquidity.add(asset.totalBorrow).sub(cToken.totalReserves().add(cToken.totalAdminFees()).add(cToken.totalFuseFees()));
            asset.supplyBalance = cToken.balanceOfUnderlying(user);
            asset.borrowBalance = cToken.borrowBalanceStored(user); // We would use borrowBalanceCurrent but we already accrue interest above
            asset.membership = comptroller.checkMembership(user, cToken);
            asset.exchangeRate = cToken.exchangeRateStored(); // We would use exchangeRateCurrent but we already accrue interest above
            asset.underlyingPrice = oracle.getUnderlyingPrice(cToken);

            // Get oracle for this cToken
            asset.oracle = address(oracle);

            try MasterPriceOracle(asset.oracle).oracles(asset.underlyingToken) returns (PriceOracle _oracle) {
                asset.oracle = address(_oracle);
            } catch { }

            // More cToken data
            asset.collateralFactor = collateralFactorMantissa;
            asset.reserveFactor = cToken.reserveFactorMantissa();
            asset.adminFee = cToken.adminFeeMantissa();
            asset.fuseFee = cToken.fuseFeeMantissa();
            asset.borrowGuardianPaused = comptroller.borrowGuardianPaused(address(cToken));

            // Add to assets array and increment index
            detailedAssets[index] = asset;
            index++;
        }

        return (detailedAssets);
    }

    /**
     * @notice Returns the `name` and `symbol` of `token`.
     * Supports Uniswap V2 and SushiSwap LP tokens as well as MKR.
     * @param token An ERC20 token contract object.
     * @return The `name` and `symbol`.
     */
    function getTokenNameAndSymbol(address token) internal view returns (string memory, string memory) {
        // MKR is a DSToken and uses bytes32
        if (token == 0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2) return ("Maker", "MKR");
        if (token == 0xB8c77482e45F1F44dE1745F52C74426C631bDD52) return ("BNB", "BNB");

        // Get name and symbol from token contract
        ERC20Upgradeable tokenContract = ERC20Upgradeable(token);
        string memory name = tokenContract.name();
        string memory symbol = tokenContract.symbol();

        // Check for Uniswap V2/SushiSwap pair
        try IUniswapV2Pair(token).token0() returns (address _token0) {
            bool isUniswapToken = keccak256(abi.encodePacked(name)) == keccak256(abi.encodePacked("Uniswap V2")) && keccak256(abi.encodePacked(symbol)) == keccak256(abi.encodePacked("UNI-V2"));
            bool isSushiSwapToken = !isUniswapToken && keccak256(abi.encodePacked(name)) == keccak256(abi.encodePacked("SushiSwap LP Token")) && keccak256(abi.encodePacked(symbol)) == keccak256(abi.encodePacked("SLP"));

            if (isUniswapToken || isSushiSwapToken) {
                ERC20Upgradeable token0 = ERC20Upgradeable(_token0);
                ERC20Upgradeable token1 = ERC20Upgradeable(IUniswapV2Pair(token).token1());
                name = string(abi.encodePacked(isSushiSwapToken ? "SushiSwap " : "Uniswap ", token0.symbol(), "/", token1.symbol(), " LP"));
                symbol = string(abi.encodePacked(token0.symbol(), "-", token1.symbol()));
            }
        } catch { }

        return (name, symbol);
    }

    /**
     * @notice Returns the assets of the specified Fuse pool.
     * @dev This function is not designed to be called in a transaction: it is too gas-intensive.
     * Ideally, we can add the `view` modifier, but many cToken functions potentially modify the state.
     * @param comptroller The Comptroller proxy contract of the Fuse pool.
     * @return An array of Fuse pool assets.
     */
    function getPoolAssetsWithData(Comptroller comptroller) external returns (FusePoolAsset[] memory) {
        return getPoolAssetsWithData(comptroller, comptroller.getAllMarkets(), msg.sender);
    }

    /**
     * @dev Struct for a Fuse pool user.
     */
    struct FusePoolUser {
        address account;
        uint256 totalBorrow;
        uint256 totalCollateral;
        uint256 health;
        FusePoolAsset[] assets;
    }

    /**
     * @notice Returns the borrowers of the specified Fuse pool.
     * @dev This function is not designed to be called in a transaction: it is too gas-intensive.
     * Ideally, we can add the `view` modifier, but many cToken functions potentially modify the state.
     * @param comptroller The Comptroller proxy contract of the Fuse pool.
     * @param maxHealth The maximum health (scaled by 1e18) for which to return data.
     * @return An array of Fuse pool users, the pool's close factor, and the pool's liquidation incentive.
     */
    function getPoolUsersWithData(Comptroller comptroller, uint256 maxHealth) external returns (FusePoolUser[] memory, uint256, uint256) {
        address[] memory users = comptroller.getAllBorrowers();
        uint256 arrayLength = 0;

        for (uint256 i = 0; i < users.length; i++) {
            uint256 totalBorrow = 0;
            uint256 totalCollateral = 0;
            FusePoolAsset[] memory assets = getPoolAssetsWithData(comptroller, comptroller.getAssetsIn(users[i]), users[i]);

            for (uint256 j = 0; j < assets.length; j++) {
                totalBorrow = totalBorrow.add(assets[j].borrowBalance.mul(assets[j].underlyingPrice).div(1e18));
                if (assets[j].membership) totalCollateral = totalCollateral.add(assets[j].supplyBalance.mul(assets[j].underlyingPrice).div(1e18).mul(assets[j].collateralFactor).div(1e18));
            }

            uint256 health = totalBorrow > 0 ? totalCollateral.mul(1e18).div(totalBorrow) : 1e36;
            if (health <= maxHealth) arrayLength++;
        }

        FusePoolUser[] memory detailedUsers = new FusePoolUser[](arrayLength);
        uint256 index = 0;

        for (uint256 i = 0; i < users.length; i++) {
            uint256 totalBorrow = 0;
            uint256 totalCollateral = 0;
            FusePoolAsset[] memory assets = getPoolAssetsWithData(comptroller, comptroller.getAssetsIn(users[i]), users[i]);

            for (uint256 j = 0; j < assets.length; j++) {
                totalBorrow = totalBorrow.add(assets[j].borrowBalance.mul(assets[j].underlyingPrice).div(1e18));
                if (assets[j].membership) totalCollateral = totalCollateral.add(assets[j].supplyBalance.mul(assets[j].underlyingPrice).div(1e18).mul(assets[j].collateralFactor).div(1e18));
            }

            uint256 health = totalBorrow > 0 ? totalCollateral.mul(1e18).div(totalBorrow) : 1e36;
            if (health > maxHealth) continue;
            detailedUsers[index] = FusePoolUser(users[i], totalBorrow, totalCollateral, health, assets);
            index++;
        }

        return (detailedUsers, comptroller.closeFactorMantissa(), comptroller.liquidationIncentiveMantissa());
    }

    /**
     * @notice Returns the users of each public Fuse pool.
     * @dev This function is not designed to be called in a transaction: it is too gas-intensive.
     * Ideally, we can add the `view` modifier, but many cToken functions potentially modify the state.
     * @param maxHealth The maximum health (scaled by 1e18) for which to return data.
     * @return An array of pools' Comptroller proxy addresses, an array of arrays of Fuse pool users, an array of pools' close factors, an array of pools' liquidation incentives, and an array of booleans indicating if retrieving each pool's data failed.
     */
    function getPublicPoolUsersWithData(uint256 maxHealth) external returns (Comptroller[] memory, FusePoolUser[][] memory, uint256[] memory, uint256[] memory, bool[] memory) {
        // Get Comptroller addresses of all public pools
        Comptroller[] memory comptrollers;

        // Scope to avoid "stack too deep" error
        {
            (, FusePoolDirectory.FusePool[] memory publicPools) = directory.getPublicPools();
            comptrollers = new Comptroller[](publicPools.length);
            for (uint256 i = 0; i < publicPools.length; i++) comptrollers[i] = Comptroller(publicPools[i].comptroller);
        }

        // Get all public pools' data
        (FusePoolUser[][] memory users, uint256[] memory closeFactors, uint256[] memory liquidationIncentives, bool[] memory errored) = getPoolUsersWithData(comptrollers, maxHealth);
        return (comptrollers, users, closeFactors, liquidationIncentives, errored);
    }

    /**
     * @notice Returns the users of the specified Fuse pools.
     * @dev This function is not designed to be called in a transaction: it is too gas-intensive.
     * Ideally, we can add the `view` modifier, but many cToken functions potentially modify the state.
     * @param comptrollers The Comptroller proxy contracts of the Fuse pools.
     * @param maxHealth The maximum health (scaled by 1e18) for which to return data.
     * @return An array of arrays of Fuse pool users, an array of pools' close factors, an array of pools' liquidation incentives, and an array of booleans indicating if retrieving each pool's data failed.
     */
    function getPoolUsersWithData(Comptroller[] memory comptrollers, uint256 maxHealth) public returns (FusePoolUser[][] memory, uint256[] memory, uint256[] memory, bool[] memory) {
        FusePoolUser[][] memory users = new FusePoolUser[][](comptrollers.length);
        uint256[] memory closeFactors = new uint256[](comptrollers.length);
        uint256[] memory liquidationIncentives = new uint256[](comptrollers.length);
        bool[] memory errored = new bool[](comptrollers.length);

        for (uint256 i = 0; i < comptrollers.length; i++) {
            try this.getPoolUsersWithData(Comptroller(comptrollers[i]), maxHealth) returns (FusePoolUser[] memory _users, uint256 closeFactor, uint256 liquidationIncentive) {
                users[i] = _users;
                closeFactors[i] = closeFactor;
                liquidationIncentives[i] = liquidationIncentive;
            } catch {
                errored[i] = true;
            }
        }

        return (users, closeFactors, liquidationIncentives, errored);
    }

    /**
     * @notice Returns arrays of Fuse pool indexes and data supplied to by `account`.
     * @dev This function is not designed to be called in a transaction: it is too gas-intensive.
     */
    function getPoolsBySupplier(address account) public view returns (uint256[] memory, FusePoolDirectory.FusePool[] memory) {
        FusePoolDirectory.FusePool[] memory pools = directory.getAllPools();
        uint256 arrayLength = 0;

        for (uint256 i = 0; i < pools.length; i++) {
            Comptroller comptroller = Comptroller(pools[i].comptroller);

            try comptroller.suppliers(account) returns (bool isSupplier) {
                if (isSupplier) {
                    CToken[] memory allMarkets = comptroller.getAllMarkets();

                    for (uint256 j = 0; j < allMarkets.length; j++) if (allMarkets[j].balanceOf(account) > 0) {
                        arrayLength++;
                        break;
                    }
                }
            } catch {}
        }

        uint256[] memory indexes = new uint256[](arrayLength);
        FusePoolDirectory.FusePool[] memory accountPools = new FusePoolDirectory.FusePool[](arrayLength);
        uint256 index = 0;

        for (uint256 i = 0; i < pools.length; i++) {
            Comptroller comptroller = Comptroller(pools[i].comptroller);

            try comptroller.suppliers(account) returns (bool isSupplier) {
                if (isSupplier) {
                    CToken[] memory allMarkets = comptroller.getAllMarkets();

                    for (uint256 j = 0; j < allMarkets.length; j++) if (allMarkets[j].balanceOf(account) > 0) {
                        indexes[index] = i;
                        accountPools[index] = pools[i];
                        index++;
                        break;
                    }
                }
            } catch {}
        }

        return (indexes, accountPools);
    }

    /**
     * @notice Returns arrays of the indexes of Fuse pools supplied to by `account`, data, total supply balances (in ETH), total borrow balances (in ETH), arrays of underlying token addresses, arrays of underlying asset symbols, and booleans indicating if retrieving each pool's data failed.
     * @dev This function is not designed to be called in a transaction: it is too gas-intensive.
     * Ideally, we can add the `view` modifier, but many cToken functions potentially modify the state.
     */
    function getPoolsBySupplierWithData(address account) external returns (uint256[] memory, FusePoolDirectory.FusePool[] memory, FusePoolData[] memory, bool[] memory) {
        (uint256[] memory indexes, FusePoolDirectory.FusePool[] memory accountPools) = getPoolsBySupplier(account);
        (FusePoolData[] memory data, bool[] memory errored) = getPoolsData(accountPools);
        return (indexes, accountPools, data, errored);
    }

    /**
     * @notice Returns the total supply balance (in ETH) and the total borrow balance (in ETH) of the caller across all pools.
     * @dev This function is not designed to be called in a transaction: it is too gas-intensive.
     * Ideally, we can add the `view` modifier, but many cToken functions potentially modify the state.
     */
    function getUserSummary(address account) external returns (uint256, uint256, bool) {
        FusePoolDirectory.FusePool[] memory pools = directory.getAllPools();
        uint256 borrowBalance = 0;
        uint256 supplyBalance = 0;
        bool errors = false;

        for (uint256 i = 0; i < pools.length; i++) {
            try this.getPoolUserSummary(Comptroller(pools[i].comptroller), account) returns (uint256 poolSupplyBalance, uint256 poolBorrowBalance) {
                supplyBalance = supplyBalance.add(poolSupplyBalance);
                borrowBalance = borrowBalance.add(poolBorrowBalance);
            } catch {
                errors = true;
            }
        }

        return (supplyBalance, borrowBalance, errors);
    }

    /**
     * @notice Returns the total supply balance (in ETH) and the total borrow balance (in ETH) of the caller in the specified pool.
     * @dev This function is not designed to be called in a transaction: it is too gas-intensive.
     * Ideally, we can add the `view` modifier, but many cToken functions potentially modify the state.
     */
    function getPoolUserSummary(Comptroller comptroller, address account) external returns (uint256, uint256) {
        uint256 borrowBalance = 0;
        uint256 supplyBalance = 0;

        if (!comptroller.suppliers(account)) return (0, 0);
        CToken[] memory cTokens = comptroller.getAllMarkets();
        PriceOracle oracle = comptroller.oracle();

        for (uint256 i = 0; i < cTokens.length; i++) {
            CToken cToken = cTokens[i];
            (bool isListed, ) = comptroller.markets(address(cToken));
            if (!isListed) continue;
            uint256 assetSupplyBalance = cToken.balanceOfUnderlying(account);
            uint256 assetBorrowBalance = cToken.borrowBalanceStored(account); // We would use borrowBalanceCurrent but we already accrue interest above
            uint256 underlyingPrice = oracle.getUnderlyingPrice(cToken);
            borrowBalance = borrowBalance.add(assetBorrowBalance.mul(underlyingPrice).div(1e18));
            supplyBalance = supplyBalance.add(assetSupplyBalance.mul(underlyingPrice).div(1e18));
        }

        return (supplyBalance, borrowBalance);
    }

    /**
     * @notice Returns arrays of Fuse pool indexes and data with a whitelist containing `account`.
     * Note that the whitelist does not have to be enforced.
     * @dev This function is not designed to be called in a transaction: it is too gas-intensive.
     */
    function getWhitelistedPoolsByAccount(address account) public view returns (uint256[] memory, FusePoolDirectory.FusePool[] memory) {
        FusePoolDirectory.FusePool[] memory pools = directory.getAllPools();
        uint256 arrayLength = 0;

        for (uint256 i = 0; i < pools.length; i++) {
            Comptroller comptroller = Comptroller(pools[i].comptroller);

            if (comptroller.whitelist(account)) arrayLength++;
        }

        uint256[] memory indexes = new uint256[](arrayLength);
        FusePoolDirectory.FusePool[] memory accountPools = new FusePoolDirectory.FusePool[](arrayLength);
        uint256 index = 0;

        for (uint256 i = 0; i < pools.length; i++) {
            Comptroller comptroller = Comptroller(pools[i].comptroller);

            if (comptroller.whitelist(account)) {
                indexes[index] = i;
                accountPools[index] = pools[i];
                index++;
                break;
            }
        }

        return (indexes, accountPools);
    }

    /**
     * @notice Returns arrays of the indexes of Fuse pools with a whitelist containing `account`, data, total supply balances (in ETH), total borrow balances (in ETH), arrays of underlying token addresses, arrays of underlying asset symbols, and booleans indicating if retrieving each pool's data failed.
     * @dev This function is not designed to be called in a transaction: it is too gas-intensive.
     * Ideally, we can add the `view` modifier, but many cToken functions potentially modify the state.
     */
    function getWhitelistedPoolsByAccountWithData(address account) external returns (uint256[] memory, FusePoolDirectory.FusePool[] memory, FusePoolData[] memory, bool[] memory) {
        (uint256[] memory indexes, FusePoolDirectory.FusePool[] memory accountPools) = getWhitelistedPoolsByAccount(account);
        (FusePoolData[] memory data, bool[] memory errored) = getPoolsData(accountPools);
        return (indexes, accountPools, data, errored);
    }
}
