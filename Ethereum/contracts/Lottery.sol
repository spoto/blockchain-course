// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity >=0.8.0 <0.9.0;

// ex1: add uint howMany to buy more tickets with buy()
// ex2: allow the extraction of a second winning ticket after the
// first, that cannot be the same first winning ticket; the first winning
// ticket gets 2/3 of the balance, the second gets 1/3 of the balance
// ex3: implement the withdrawal pattern for this contract:
// function withdraw() public returns (bool success)

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
        payable(winner).call{value: address(this).balance}("");
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
