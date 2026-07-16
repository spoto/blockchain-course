// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity >=0.8.0 <0.9.0;

contract TrustFund2Wrong {
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

    receive() external payable { }

    function disperse() public {
        uint balance = address(this).balance;
        // OK: if a call fails, the computation continues with the next call;
        // this passes enough gas for non-trivial receive();
        // if a child has a very complex receive(), it might drain all gas and
        // make withdrawal impossible for all other children
        _children[0].call{value: balance / 2}("");
        _children[1].call{value: balance / 4}("");
        _children[2].call{value: balance / 4}("");
    }
}
