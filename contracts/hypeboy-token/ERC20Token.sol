// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "./ERC20.sol";
import "./ERC20Burnable.sol";
import "./ERC20Lockable.sol";
import "./Ownable.sol";

contract ERC20Token is ERC20, ERC20Burnable, ERC20Lockable, Ownable {
    string private constant _name = "Testtt Token";
    string private constant _symbol = "Testtt";
    uint8 private constant _decimals = 18;

    constructor() {
        _mint(msg.sender, 100 ether);
    }

    /* ======================================================= */
    /* ===================== ERC20 Method ==================== */
    /* ======================================================= */

    function transfer(
        address to,
        uint256 amount
    ) external override checkLock(msg.sender, amount) returns (bool success) {
        require(to != address(0), "transfer : Should not send to zero address");
        _transfer(msg.sender, to, amount);
        success = true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external override checkLock(from, amount) returns (bool success) {
        require(
            to != address(0),
            "transferFrom : Should not send to zero address"
        );
        _transfer(from, to, amount);
        _approve(from, msg.sender, _allowances[from][msg.sender] - amount);
        success = true;
    }

    function approve(
        address spender,
        uint256 amount
    ) external override returns (bool success) {
        require(
            spender != address(0),
            "approve : Should not approve zero address"
        );
        _approve(msg.sender, spender, amount);
        success = true;
    }

    /* ======================================================= */
    /* =================== Lockable Method =================== */
    /* ======================================================= */

    function releaseLock(
        address from
    ) external onlyOwner returns (bool success) {
        for (uint256 i = 0; i < _locks[from].length; ) {
            i++;
            if (_unlock(from, i - 1)) {
                i--;
            }
        }
        success = true;
    }

    function transferWithLockUp(
        address recipient,
        uint256 amount,
        uint256 due
    ) external onlyOwner returns (bool success) {
        require(
            recipient != address(0),
            "ERC20Lockable/transferWithLockUp : Cannot send to zero address"
        );
        _transfer(msg.sender, recipient, amount);
        _lock(recipient, amount, due);
        success = true;
    }

    /* ======================================================= */
    /* ================== Token Information ================== */
    /* ======================================================= */

    function name() external pure override returns (string memory tokenName) {
        tokenName = _name;
    }

    function symbol()
        external
        pure
        override
        returns (string memory tokenSymbol)
    {
        tokenSymbol = _symbol;
    }

    function decimals() external pure override returns (uint8 tokenDecimals) {
        tokenDecimals = _decimals;
    }
}
