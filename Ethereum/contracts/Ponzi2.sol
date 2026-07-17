// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity >=0.8.0 <0.9.0;

contract Ponzi2 {
    address payable public currentInvestor;
    uint public currentInvestment = 0;

    function invest() payable public {
        uint minimumInvestment = currentInvestment * 11 / 10;
        require(msg.value >= minimumInvestment, "investment too low");
        address payable previousInvestor = currentInvestor;
        currentInvestor = payable(msg.sender);
        currentInvestment = msg.value;
        // for malicious investors it will return false but not fail;
        // however, in that case ETH will remain locked in the contract,
        // without any possible way of pulling it out; moreover, the first
        // investor finds previousInvestor unset and burns its money for nothing
        previousInvestor.call{value: msg.value}("");
    }
}
