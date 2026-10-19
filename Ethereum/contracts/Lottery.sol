// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity >=0.8.0 <0.9.0;

contract Lottery {
    uint constant public TICKET_PRICE = 1000 wei;
    address public owner;
    uint public ticketingCloses;
    address payable[] public players;
    address payable public winner;

    constructor (uint duration) {
        owner = msg.sender;
        ticketingCloses = block.timestamp + duration; // seconds
    }

    function buy() public payable {
        require(msg.value >= TICKET_PRICE, "wrong ticket price");
        require(block.timestamp < ticketingCloses, "too late");
        players.push(payable(msg.sender));
    }

    receive() external payable {
        buy(); // who sends money, gets a ticket
    }

    function drawWinner() public {
        require(msg.sender == owner, "only the owner can call this");
        require(players.length > 0, "no players");
        require(block.timestamp > ticketingCloses, "too early");
        require(winner == address(0), "already called");
        winner = players[random(players.length, owner)];
    }

    function withdraw() public returns (bool success) {
        require(msg.sender == winner, "you are not the winner");
        (success, ) = payable(msg.sender).call{value: address(this).balance}("");
    }

    bytes32 private randomValue;

    // Yields a "random" number between 0 and max-1;
    // the number is different for different addresses
    function random(uint max, address addr) private returns (uint) {
      randomValue = keccak256(bytes.concat(
        randomValue, // we embed the previous value
        bytes32(block.difficulty),
        blockhash(block.number - 1),
        bytes32(bytes20(addr))
      ));
      return uint(randomValue) % max;
    }
}

