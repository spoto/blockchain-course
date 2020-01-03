pragma solidity ^0.4.26;

contract D {
    uint public n;
    address public sender;
    
    // send at least 100 wei
    function callSetN(E _e, uint _n) public payable {
        _e.setN.value(100)(_n);
    }
}

contract E {
    uint public n;
    address public sender;

    function setN(uint _n) public payable {
        n = _n;
        sender = msg.sender;
    }
}

contract C {
    // Accept any incoming amount
    function () external payable {}
}
