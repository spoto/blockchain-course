// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity >=0.8.0 <0.9.0;

contract RecurringLottery {

    // a round of the lottery: ticket sales can be added until the end block
    // has been minted, after which a winner of the round can be drawn
    struct Round {
        uint endBlock;
        TicketSale[] sales;
        uint totalTickets;
        address winner;
    }

    struct TicketSale {
        address buyer;
        uint tickets;
    }

    uint constant public TICKET_PRICE = 1000;

    // number of blocks to wait after the end of a round
    // for the round's winner to be drawn; this makes impossible
    // for the players to foresee the winning ticker
    uint constant public DELAY_BEFORE_WINNER_DRAWING = 5;

    // all rounds created so far
    mapping(uint => Round) public rounds;

    // the current round, starting from 0
    uint public round;

    // duration of each round (in number of blocks)
    uint public duration;

    // balances that players can withdraw
    mapping (address => uint) public balances;

    // duration is in blocks
    constructor (uint _duration) {
        duration = _duration;
        rounds[0].endBlock = block.number + duration;
    }

    function buy() payable public {
        require(msg.value > 0 && msg.value % TICKET_PRICE == 0, "you can only buy a positive integral number of tickets");

        if (block.number > rounds[round].endBlock)
            rounds[++round].endBlock = block.number + duration;
 
        uint quantity = msg.value / TICKET_PRICE;
        TicketSale memory sale = TicketSale(msg.sender, quantity);
        rounds[round].sales.push(sale);
        rounds[round].totalTickets += quantity;
    }

    function drawWinner(uint roundNumber) public {
        // by using memory below, the assignment would create a copy of the round in memory
        // and its update, inside the for loop, would be lost at the end of the function
        Round storage drawing = rounds[roundNumber];
        require(drawing.winner == address(0), "the winner has already been drawn");
        require(block.number > drawing.endBlock + DELAY_BEFORE_WINNER_DRAWING, "too early");
        require(drawing.sales.length > 0, "no tickets have been sold for this round");

        uint counter = random(drawing.totalTickets, 0xbeaf);

        for (uint i = 0; drawing.winner == address(0); i++) {
            uint tickets = drawing.sales[i].tickets;
            if (tickets > counter)
                drawing.winner = drawing.sales[i].buyer;
            else
                counter -= tickets;
        }

        balances[drawing.winner] += TICKET_PRICE * drawing.totalTickets;
    }

    function withdraw() public returns (bool success) {
        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;
        (success, ) = msg.sender.call{value : amount}("");
        if (!success)
            balances[msg.sender] = amount;
    }

    // Yields a "random" number between 0 and max-1; the seed makes manipulations
    // by miners slightly more difficult
    function random(uint max, uint seed) view private returns (uint) {
        return uint(keccak256(bytes.concat(bytes32(seed), blockhash(block.number - 1)))) % max;
    }
}