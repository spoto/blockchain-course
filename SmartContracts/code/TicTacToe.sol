pragma solidity ^0.4.19;

contract TicTacToe {
    address public owner;
    address public player1;
    address public player2;
    uint private firstDeposit;
    uint8 public turn = 1;
    uint8[9] public tiles; // 0 = empty, 1 = player1, 2 = player2

    event Draw();
    event Victory(address winner);
    event Move(uint8[9]);

    constructor () public {
        owner = msg.sender;
    }

    function play(uint8 x, uint8 y) payable public {
        require(0 <= x && x <= 3 && 0 <= y && y <= 3, "coordinates must be between 0 and 3");
        require(get(x, y) == 0, "coordinate must be empty");
    
        if (turn == 1) {
            require(msg.value >= 0.01 ether, "you must bid at least 0.01 ether");
            player1 = msg.sender;
            firstDeposit = msg.value;
        }
        else if (turn == 2) {
            require(player1 != msg.sender, "you cannot play against yourself");
            require(msg.value >= firstDeposit, "you must bid at least as the first player");
            player2 = msg.sender;
        }
        else if (turn % 2 == 1)
            require(msg.sender == player1, "first player already taken");
        else
            require(msg.sender == player2, "second player already taken");

        set(x, y, turn % 2 == 1 ? 1 : 2);
        emit Move(tiles);
        turn++;

        if (isVictory())
            wins(msg.sender);
        else if (isDraw())
            draw();
    }

    function get(uint8 x, uint8 y) private view returns(uint8) {
        return tiles[x + y * 3];
    }

    function set(uint8 x, uint8 y, uint8 value) private {
        tiles[x + y * 3] = value;
    }

    function reset() private {
        for (uint8 pos = 0; pos < 9; pos++)
            tiles[pos] = 0;

        player1 = player2 = address(0);
        firstDeposit = 0;
        turn = 1;
        emit Move(tiles);
    }

    function isVictory() private view returns(bool) {
        return horizontally() || vertically() || diagonally();
    }

    function horizontally() private view returns(bool) {
        for (uint8 y = 0; y < 3; y++)
            if (get(0, y) != 0 && get(0, y) == get(1, y) && get(1, y) == get(2, y))
                return true;

        return false;
    }

    function vertically() private view returns(bool) {
        for (uint8 x = 0; x < 3; x++)
            if (get(x, 0) != 0 && get(x, 0) == get(x, 1) && get(x, 1) == get(x, 2))
                return true;

        return false;
    }

    function diagonally() private view returns(bool) {
        uint8 center = get(1, 1);
        return center != 0 &&
            ((get(0, 0) == center && center == get(2, 2)) || (get(2, 0) == center && center == get(0, 2)));
    }

    function isDraw() private view returns(bool) { // assuming !isVictory()
        return turn == 10;
    }

    function draw() private {
        if (turn > 1) {
            reset(); // avoid reentrancy
            owner.send(address(this).balance / 10); // 10% goes to the owner
            emit Draw();
        }
    }

    function wins(address who) private {
        if (turn > 1) {
            reset(); // avoid reentrancy
            owner.send(address(this).balance / 10); // 10% goes to the owner
            who.send(address(this).balance); // the rest goes to the winner
            emit Victory(who);
        }
    }
}
