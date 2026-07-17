// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity >=0.8.0 <0.9.0;

contract PonziGradual {
    address[] public investors; // dynamic array
    mapping (address => uint) public balances; // map
    uint constant public MINIMUM_INVESTMENT = 1000;

    constructor () {
        investors.push(msg.sender);
    }

    function invest() payable external {
        require(msg.value >= MINIMUM_INVESTMENT, "too small investment");
        // innvestors.length is never zero because the constructor
        // populates it with at least a first investor
        uint eachInvestorGets = msg.value / investors.length;
        // if there are too many investors, the subsequent loop would
        // require too much gas, more than the maximum allowed by Ethereum,
        // effectively making it impossible for new investors to join
        for (uint i = 0; i < investors.length; i++)
            balances[investors[i]] += eachInvestorGets;

        investors.push(msg.sender);
    }

    function withdraw() public returns (bool success) {
        uint payout = balances[msg.sender];
        balances[msg.sender] = 0;
        // transfer() would also be fine here since it is the last instruction of the function
        // and it forwards too little gas for reentrancy; in any case, it sends the whole payout
        // and to its correct investor and the previous line avoids the risk of sending it again
        // to an investor that already withdrew its balance; therefore reentrancy would be prevented
        // in this specific case
        //payable(msg.sender).transfer(payout);
        (success, ) = payable(msg.sender).call{value:payout}("");
    }
}
