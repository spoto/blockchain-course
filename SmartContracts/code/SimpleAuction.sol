pragma solidity ^0.5.0;

contract SimpleAuction {
    address payable public owner;
    uint public auctionEndTime;
    address public highestBidder;
    uint public highestBid;
    mapping(address => uint) pendingReturns;
    bool ended;

    constructor(uint biddingTime) public {
        owner = msg.sender;
        auctionEndTime = now + biddingTime;
    }

    function bid() public payable {
        require(now <= auctionEndTime, "Auction already ended");
        require(msg.value > highestBid, "There is already a higher bid");

        if (highestBid != 0)
            // highestBidder.transfer(highestBid); DON'T DO THIS!!!
            pendingReturns[highestBidder] += highestBid;

        highestBidder = msg.sender;
        highestBid = msg.value;
    }

    function withdraw() public returns (bool) {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            pendingReturns[msg.sender] = 0;
            
            if (!msg.sender.send(amount)) {
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }

        return true;
    }

    function auctionEnd() public {
        require(now >= auctionEndTime, "Auction not yet ended");
        require(!ended, "auctionEnd has already been called");
        ended = true;
        owner.transfer(highestBid);
    }
}
