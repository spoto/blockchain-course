// SPDX-License-Identifier: CC-BY-SA-4.0

pragma solidity >=0.7.0 <0.9.0;

contract SimpleAuction {
    address payable public owner;
    uint public auctionEndTime;
    address public highestBidder;
    uint public highestBid;
    mapping(address => uint) public pendingReturns;
    bool public ended;

    constructor(uint biddingTime) {
        owner = payable(msg.sender);
        auctionEndTime = block.timestamp + biddingTime; // seconds
    }

    function bid() public payable {
        require(block.timestamp <= auctionEndTime, "Auction already ended");
        require(msg.value > highestBid, "There is already a higher bid");

        if (highestBid != 0)
            // payable(highestBidder).transfer(highestBid); // DON'T DO THIS!!!
            pendingReturns[highestBidder] += highestBid;

        highestBidder = msg.sender;
        highestBid = msg.value;
    }

    function withdraw() public returns (bool) {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            pendingReturns[msg.sender] = 0;

            if (!payable(msg.sender).send(amount)) {
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }

        return true;
    }

    function auctionEnd() public {
        require(block.timestamp >= auctionEndTime, "Auction not yet ended");
        require(!ended, "auctionEnd has already been called");
        ended = true;
        owner.transfer(highestBid);
    }
}



