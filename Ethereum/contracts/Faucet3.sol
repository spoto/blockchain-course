// SPDX-License-Identifier: CC-BY-SA-4.0

pragma solidity >=0.7.0 <0.9.0;

contract Owned {
    address payable private owner;

    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
}

contract Stoppable is Owned {
    bool internal stopped = false;

    function stop() public onlyOwner {
        stopped = true;
    }
}

contract Faucet3 is Stoppable {
    receive() external payable {}

    function withdraw(uint withdraw_amount) public {
        require(withdraw_amount <= 0.1 ether);
        require(!stopped);
        payable(msg.sender).transfer(withdraw_amount);
    }
}

