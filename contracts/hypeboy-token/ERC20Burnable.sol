// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "./ERC20.sol";

abstract contract ERC20Burnable is ERC20 {
    event Burn(address indexed burned, uint256 amount);

    function burn(uint256 amount) external returns (bool success) {
        success = _burn(msg.sender, amount);
        emit Burn(msg.sender, amount);
        success = true;
    }

    function burnFrom(
        address burned,
        uint256 amount
    ) external returns (bool success) {
        _burn(burned, amount);
        emit Burn(burned, amount);
        success = _approve(
            burned,
            msg.sender,
            _allowances[burned][msg.sender] - amount
        );
    }
}
