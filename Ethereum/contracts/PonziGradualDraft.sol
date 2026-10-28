// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity >=0.8.0 <0.9.0;

// modify the code so that two minutes at least must pass
// between successive investments
contract PonziGradual {
    address[] public investors; // dynamic array
    uint constant public MINIMUM_INVESTMENT = 1000;

    constructor () {
        investors.push(msg.sender);
    }

    function invest() payable public {
        require(msg.value >= MINIMUM_INVESTMENT, "too small investment");

        uint eachInvestorGets = msg.value / investors.length;
        for (uint i = 0; i < investors.length; i++)
            investors[i].call{value: eachInvestorGets}("");

        investors.push(msg.sender);
    }
}
