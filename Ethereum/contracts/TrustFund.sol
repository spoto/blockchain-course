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

        if (msg.sender == _children[0])
            // we send the total part for the first child, minus what it already withdrew
            msg.sender.call{value: balance / 2 - withdrawn[0]}("");
        else if (msg.sender == _children[1])
            msg.sender.call{value: balance / 4 - withdrawn[1]}("");
        else if (msg.sender == _children[2])
            msg.sender.call{value: balance / 4 - withdrawn[2]}("");
        else
            revert("Unknown child");
    }
}
