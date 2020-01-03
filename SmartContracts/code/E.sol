pragma solidity ^0.4.26;

contract E {
    uint public n;
    address public sender;

    function setN(uint _n) public {
        n = _n;
        sender = msg.sender;
    }
}
