// SPDX-License-Identifier: CC-BY-SA-4.0

pragma solidity >=0.7.0 <0.9.0;

contract GradualPonzi {
    address[] public investors; // dynamic array
    mapping (address => uint) public balances; // map
    uint public constant MINIMUM_INVESTMENT = 1000;

    constructor () { investors.push(msg.sender); }

    function invest() payable external {
        require(msg.value >= MINIMUM_INVESTMENT);
        uint eachInvestorGets = msg.value / investors.length;
        for (uint i = 0; i < investors.length; i++)
            balances[investors[i]] += eachInvestorGets;
        investors.push(msg.sender);
    }

    function withdraw() public {
        uint payout = balances[msg.sender];
        balances[msg.sender] = 0;
        payable(msg.sender).transfer(payout);
    }
}


