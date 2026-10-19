// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity >=0.8.0 <0.9.0;

contract Ponzi {
    address payable public currentInvestor;
    uint public currentInvestment = 0;
    mapping (address => uint) pendingWithdrawals;

    function invest() payable public {
        uint minimumInvestment = currentInvestment * 11 / 10;
        require(msg.value >= minimumInvestment, "investment too low");
        address payable previousInvestor = currentInvestor;
        currentInvestor = payable(msg.sender);
        currentInvestment = msg.value;
        pendingWithdrawals[previousInvestor] += msg.value;
    }

    function withdraw() public returns (bool success) {
        uint value = pendingWithdrawals[msg.sender];
	pendingWithdrawals[msg.sender] = 0;
        (success, ) = msg.sender.call{value: value}("");
        if (!success)
	   pendingWithdrawals[msg.sender] = value;
    }
}
