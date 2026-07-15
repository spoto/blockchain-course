// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract Locations {
    uint[] public numbers = [13, 17, 42];
    uint public f = 13;

    function addOne() public returns (uint[] memory) {
        uint[] memory newNumbers = numbers;
        uint ff = f;
        for (uint i = 0; i < numbers.length; i++) {
            newNumbers[i]++;
        }
        ff++;
        numbers = newNumbers;

        return newNumbers;
    }
}
