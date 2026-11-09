// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity >=0.8.0 <0.9.0;

contract Ponzi {
    address payable public lastInvestor;
    uint public lastInvestment;

    constructor() payable {
    	lastInvestor = payable(msg.sender);
	lastInvestment = msg.value;
    }

    function invest() payable public {
        require(msg.value >= lastInvestment * 11 / 10, "investment too low");
	lastInvestor.send(msg.value);
        lastInvestor = payable(msg.sender);
        lastInvestment = msg.value;
    }
}
