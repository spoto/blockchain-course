pragma solidity ^0.4.26;

contract D {
    constructor () payable public {
    }

    function callFoo(E e) public {
        e.foo.value(100)();
    }
}

contract E {
    function foo() public payable {
        // do something with the received value
    }
}

contract C {
    // Accept any incoming amount
    function () external payable {}
}
