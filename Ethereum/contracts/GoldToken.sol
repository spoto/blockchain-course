// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GoldToken is ERC20 {
    address private owner;

    constructor(uint256 initialSupply) ERC20("Gold", "GLD") {
        owner = msg.sender;
        _mint(owner, initialSupply);
    }

    function mint(uint amount) public {
        if (msg.sender != owner)
            revert("Only the contract owner can mint new tokens");

        _mint(owner, amount);
    }
}
