pragma solidity ^0.4.21;

contract GradualPonzi {
    address[] public investors; // dynamic array
    mapping (address => uint) public balances; // map
    uint public constant MINIMUM_INVESTMENT = 1e15;

    constructor () public {
        investors.push(msg.sender);
    }

    function () public payable {
        require(msg.value >= MINIMUM_INVESTMENT);
        uint eachInvestorGets = msg.value / investors.length;
        for (uint i = 0; i < investors.length; i++)
            balances[investors[i]] += eachInvestorGets;
        investors.push(msg.sender);
    }

    function withdraw() public {
        uint payout = balances[msg.sender];
        balances[msg.sender] = 0;
        msg.sender.transfer(payout);
    }
}
