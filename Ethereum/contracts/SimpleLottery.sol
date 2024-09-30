// SPDX-License-Identifier: CC-BY-SA-4.0

pragma solidity >=0.7.0 <0.9.0;

contract SimpleLottery {
    uint public constant TICKET_PRICE = 1000;
    address public owner;
    address[] public players;
    address public winner;
    uint public ticketingCloses;

    constructor (uint duration) {
        owner = msg.sender;
        ticketingCloses = block.timestamp + duration; // seconds
    }

    function buy() public payable {
        require(msg.value == TICKET_PRICE);
        require(block.timestamp < ticketingCloses);
        players.push(msg.sender);
    }

    receive() external payable {
        buy(); // who sends money, gets a ticket
    }

    function drawWinner() public {
        require(msg.sender == owner);
        require(players.length > 0);
        require(block.timestamp > ticketingCloses + 20 seconds);
        require(winner == address(0)); // not set yet
        bytes32 previousBlockHash = blockhash(block.number - 1);
        bytes32 rand = keccak256(bytes.concat(previousBlockHash));
        winner = players[uint(rand) % players.length];
    }

    function withdraw() public {
        require(msg.sender == winner);
        payable(msg.sender).transfer(address(this).balance);
    }
}


