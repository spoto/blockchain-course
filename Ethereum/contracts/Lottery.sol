// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity >=0.8.0 <0.9.0;

contract SimpleLottery {
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
        require(block.timestamp > ticketingCloses + 20 seconds, "too early");
        require(winner == address(0), "already called");
        winner = players[random(players.length, 13542345)];
    }

    /*
        Yields a "random" number between 0 and max-1; the seed makes manipulations
        by miners slightly more difficult.
    */
    function random(uint max, uint seed) view public returns (uint) {
        return uint(keccak256(bytes.concat(bytes32(seed), blockhash(block.number - 1)))) % max;
    }

    function withdraw() public returns (bool done) {
        require(msg.sender == winner, "you are not the winner");
        // transfer() would also be fine here since it is the last instruction of the function
        // and it forwards too little gas for reentrancy; in any case, it sends the whole balance,
        // therefore reentrancy would be useless in this specific example
        //winner.transfer(address(this).balance);
        (done, ) = payable(msg.sender).call{value: address(this).balance}("");
    }
}
