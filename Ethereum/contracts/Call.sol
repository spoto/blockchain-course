// SPDX-License-Identifier: CC-BY-SA-4.0

pragma solidity >=0.7.0 <0.9.0;

contract D {
    uint public n;
    address public sender;

    function callSetN(address _e, uint _n) public {
        (bool success, ) = _e.call(abi.encodeWithSignature("setN(uint256)", _n));
        require(success, "call failed");
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


