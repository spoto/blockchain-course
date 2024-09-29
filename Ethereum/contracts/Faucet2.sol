// SPDX-License-Identifier: CC-BY-SA-4.0

pragma solidity >=0.7.0 <0.9.0;

contract Faucet2 {
    address payable private owner;
    bool private stopped;

    constructor() {
        owner = payable(msg.sender);
        stopped = false;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    receive() external payable {}

    function withdraw(uint withdraw_amount) public {
        require(withdraw_amount <= 0.1 ether);
        require(!stopped);
        payable(msg.sender).transfer(withdraw_amount);
    }

    function stop() public onlyOwner {
        stopped = true;
    }
}


