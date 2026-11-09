// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity >=0.8.0 <0.9.0;

// ex: introduce the withdrawal pattern in this contract

contract TrustFund {
    address payable[3] public _children;

    constructor(address payable[3] memory children) {
        _children = children;
    }

    function updateChild(address payable newChild) public {
        if (msg.sender == _children[0])
            _children[0] = newChild;
        else if (msg.sender == _children[1])
            _children[1] = newChild;
        else if (msg.sender == _children[2])
            _children[2] = newChild;
        else
            revert("Unknown child");
    }

    receive() external payable {
        _children[0].send(msg.value / 2);
        _children[1].send(msg.value / 4);
        _children[2].send(msg.value / 4);
    }
}
