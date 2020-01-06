pragma solidity ^0.4.21;

contract SimpleLottery {
    uint public constant TICKET_PRICE = 1e16; // 0.01 ETH
    address public owner;
    address[] public players;
    address public winner;
    uint public ticketingCloses;
    
    constructor (uint duration) public {
        owner = msg.sender;
        ticketingCloses = now + duration; // seconds
    }

    function buy() public payable {
        require(msg.value == TICKET_PRICE);
        require(now < ticketingCloses);
        players.push(msg.sender);
    }

    function drawWinner() public {
        require(msg.sender == owner);
        require(players.length > 0);
        require(now > ticketingCloses + 5 minutes);
        require(winner == address(0)); // not set yet
        bytes32 rand = keccak256(blockhash(block.number - 1));
        winner = players[uint(rand) % players.length];
    }
    
    function withdraw() public {
        require(msg.sender == winner);
        msg.sender.transfer(this.balance);
    }

    function () payable public {
        buy(); // who sends money, gets a ticket
    }
}
