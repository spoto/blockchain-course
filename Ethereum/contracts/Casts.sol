// SPDX-License-Identifier: CC-BY-SA-4.0

pragma solidity >=0.7.0 <0.9.0;

contract D {
    constructor () payable {}

    function callFoo(address e) public {
        E(e).foo{value: 100}();
    }
}

contract E {
    function foo() public payable {
        // do something with the received amount
    }
}

contract C {
    fallback() external payable {}
}

