pragma solidity ^0.4.21;

contract BlindAuction {
    struct Bid {
        bytes32 blindedBid;
        uint deposit;
    }

    address owner;
    uint public biddingEnd;
    uint public revealEnd;
    bool public ended;
    mapping(address => Bid[]) public bids;
    address public highestBidder;
    uint public highestBid;
    mapping(address => uint) pendingReturns;

    constructor(uint biddingTime, uint revealTime) public {
        owner = msg.sender;
        biddingEnd = now + biddingTime;
        revealEnd = biddingEnd + revealTime;
    }

    modifier onlyBefore(uint _time) { require(now < _time); _; }
    modifier onlyAfter(uint _time) { require(now > _time); _; }

    /// Place a blinded bid with `_blindedBid` =
    /// keccak256(abi.encodePacked(value, fake, secret)).
    /// The sent ether is only refunded if the bid is correctly
    /// revealed in the revealing phase. The bid is valid if the
    /// ether sent together with the bid is at least "value" and
    /// "fake" is not true. Setting "fake" to true and sending
    /// not the exact amount are ways to hide the real bid but
    /// still make the required deposit. The same address can
    /// place multiple bids.
    function bid(bytes32 _blindedBid) public payable onlyBefore(biddingEnd) {
        bids[msg.sender].push(Bid({ blindedBid: _blindedBid, deposit: msg.value }));
    }

    /// Reveal your blinded bids. You will get a refund for all correctly blinded 
    /// invalid bids and for all bids except for the totally highest.
    function reveal(uint[] _values, bool[] _fake, bytes32[] _secret)
            public onlyAfter(biddingEnd) onlyBefore(revealEnd) {
        uint length = bids[msg.sender].length;
        require(_values.length == length && _fake.length == length && _secret.length == length);

        uint refund = 0;
        for (uint i = 0; i < length; i++) {
            Bid storage bidToCheck = bids[msg.sender][i];
            (uint value, bool fake, bytes32 secret) = (_values[i], _fake[i], _secret[i]);
            if (bidToCheck.blindedBid != keccak256(abi.encodePacked(value, fake, secret)))
                continue; // bid was not actually revealed: do not refund the deposit

            refund += bidToCheck.deposit;
            if (!fake && bidToCheck.deposit >= value && value > highestBid) {
                updateHighestBid(msg.sender, value);
                refund -= value;
            }
            bidToCheck.blindedBid = bytes32(0); // cannot claim it back again
        }
        msg.sender.transfer(refund);
    }

    function updateHighestBid(address bidder, uint value) internal {
        if (highestBidder != address(0))
            pendingReturns[highestBidder] += highestBid;
        highestBid = value;
        highestBidder = bidder;
    }

    function withdraw() public {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            pendingReturns[msg.sender] = 0;
            msg.sender.transfer(amount);
        }
    }

    function auctionEnd() public onlyAfter(revealEnd) {
        require(!ended);
        ended = true;
        owner.transfer(highestBid);
    }
}
