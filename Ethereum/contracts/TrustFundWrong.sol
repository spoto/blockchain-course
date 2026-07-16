// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity >=0.8.0 <0.9.0;

contract TrustFundWrong {
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
        // do not do this! If a transfer fails, the whole disperse() method
        // reverts with an exception and nobody can access its funds
        _children[0].transfer(balance / 2);
        _children[1].transfer(balance / 4);
        _children[2].transfer(balance / 4);
    }
}
