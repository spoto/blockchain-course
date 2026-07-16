// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity >=0.8.0 <0.9.0;

contract TrustFund {
    address payable[3] public _children;
    uint[3] public withdrawn;

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

    receive() external payable { }

    function withdraw() public {
        // we reconstruct the total balance, including what has been already withdrawn
        uint balance = address(this).balance + withdrawn[0] + withdrawn[1] + withdrawn[2];
        uint diff;
        uint num;

        if (msg.sender == _children[0])
            // we send the total part for the first child, minus what it already withdrew
            diff = balance / 2 - withdrawn[num = 0];
        else if (msg.sender == _children[1])
            diff = balance / 4 - withdrawn[num = 1];
        else if (msg.sender == _children[2])
            diff = balance / 4 - withdrawn[num = 2];
        else
            revert("Unknown child");

        // makes reentrancy useless
        withdrawn[num] += diff;
        (bool success, ) = msg.sender.call{value: diff}("");
        if (!success)
            // revert to previous withdrawn value
            withdrawn[num] -= diff;
    }
}
