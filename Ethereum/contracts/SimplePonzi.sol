// SPDX-License-Identifier: CC-BY-SA-4.0

pragma solidity >=0.7.0 <0.9.0;

contract SimplePonzi {
    address payable public currentInvestor;
    uint public currentInvestment = 0;

    function invest() payable external {
        uint minimumInvestment = currentInvestment * 11 / 10;
        require(msg.value >= minimumInvestment);
        address payable previousInvestor = currentInvestor;
        currentInvestor = payable(msg.sender);
        currentInvestment = msg.value;
        // for malicious investors it will return false but not fail
        previousInvestor.send(msg.value);
    }
}


