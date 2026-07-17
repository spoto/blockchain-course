// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity >=0.8.0 <0.9.0;

contract Ponzi3 {
    address payable public currentInvestor;
    uint public currentInvestment = 0;

    function invest() payable public {
        uint minimumInvestment = currentInvestment * 11 / 10;
        require(msg.value >= minimumInvestment, "investment too low");
        address payable previousInvestor = currentInvestor;
        currentInvestor = payable(msg.sender);
        currentInvestment = msg.value;

        // we avoid burning money
        if (previousInvestor != address(0))
            // for malicious investors it will return false but not fail;
            // moreover, it forwards the whole balance of the contract to
            // previousInvestor, so that nothings remains in the contract
            previousInvestor.call{value: address(this).balance}("");
    }
}

