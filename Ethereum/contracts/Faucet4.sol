// SPDX-License-Identifier: CC-BY-SA-4.0

pragma solidity >=0.7.0 <0.9.0;

import "./Faucet3.sol"; // this defines Stoppable
import "./Faucet.sol"; // this defines Faucet

contract Faucet4 is Stoppable {
    Faucet private faucet;

    constructor() {
        faucet = new Faucet();
    }

    receive() external payable {
        payable(address(faucet)).transfer(msg.value);
    }

    function withdraw(uint withdraw_amount) public {
        require(!stopped);
        faucet.withdraw(withdraw_amount);
    }
}

