// SPDX-License-Identifier: CC-BY-SA-4.0

// Version of Solidity compiler this program was written for
pragma solidity >=0.8.0 <0.9.0;

// Our first contract is a faucet!
contract Faucet {
    // Accept any incoming amount
    receive() external payable {}

    // Give out ether to anyone who asks
    function withdraw(uint withdraw_amount) public {
        // Limit withdrawal amount
        require(withdraw_amount <= 1e18);

        // Send the amount to the address that requested it
        payable(msg.sender).transfer(withdraw_amount);
        //(bool success, ) = payable(msg.sender).call{value: withdraw_amount}("");
        //require(success, "Transfer failed");
    }
}
