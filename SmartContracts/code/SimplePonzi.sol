pragma solidity ^0.4.21;

contract SimplePonzi {
    address public currentInvestor;
    uint public currentInvestment = 0;
    
    function () payable external {
        uint minimumInvestment = currentInvestment * 11 / 10;
        require(msg.value > minimumInvestment);
        address previousInvestor = currentInvestor;
        currentInvestor = msg.sender;
        currentInvestment = msg.value;
        // for malicious investors it will return false but not fail
        previousInvestor.send(msg.value);
    }
}
