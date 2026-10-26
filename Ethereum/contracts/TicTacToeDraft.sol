// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity >= 0.8.0 <0.9.0;

// A tic-tac-toe game between two players
contract TicTacToe {
    // the minimum payment for the initial move
    uint constant public MINIMUM_BET = 0.01 ether;

    // the board is a 3x3 array of tiles
    enum Tile { EMPTY, CROSS, CIRCLE }
    Tile[3][3] public board;

    // the deployer or creator of the contract
    address payable public owner;

    // the cross player: it is the first who calls play()
    address payable public crossPlayer;

    // the circle player: it is the second who calls play()
    address payable public circlePlayer;

    // the total amount of payments to the contract since the start of the last game
    uint public bet;

    // the current turn: the corresponding player has the right to the next move
    Tile public turn;

    constructor () {
        // TODO: takes note of the owner, deployer or creator of the contract

        // resets all state variables to their initial value for a new game
        initGame();
    }

    function initGame() private {
        crossPlayer = payable(address(0));
        circlePlayer = payable(address(0));
        turn = Tile.CROSS; // CROSS starts playing
        bet = 0; // no payments have been received for the game up to now

        // TODO: resets all board elements to the empty tiles
    }

    // Yields the tile at the position (x,y);
    // please observe that x and y are assumed between 1 and 3, while
    // array positions in Solidity start at 0
    function at(uint x, uint y) public view returns (Tile) {
        // TODO
    }

    // Writes the given tile into the position (x,y);
    // please observe that x and y are assumed between 1 and 3, while
    // array positions in Solidity start at 0
    function set(uint x, uint y, Tile tile) private {
        // TODO
    }

    // Makes the next move at positions (x,y), between 1 and 3
    function play(uint x, uint y) payable public {
        // TODO: require that x and y are between 1 and 3 included
        // TODO: require that the board positoin (x,y) is empty

        if (turn == Tile.CROSS)
            playCross(x, y);
        else
            playCircle(x, y);
    }

    // Cross makes the next move at positions (x,y), between 1 and 3
    function playCross(uint x, uint y) private {
        if (crossPlayer == address(0)) {
            // TODO: require that the caller sent at least MINIMUM_BET money
            // TODO: assign the caller of the transaction to crossPlayer
        }
        else {
            // TODO: require that crossPlayer is the caller of the transaction,
            // since otherwise somebody else is playing instead of him
        }

        // we take note that the position (x,y) has been played
        set(x, y, turn);
        // TODO: add to bet the money sent with the transaction

        if (isVictoryMove(x, y)) {
            // send 80% of the bet to the winner
            crossPlayer.call{value: bet * 80 / 100}("");
            // TODO: send 5% of the bet to the loser
            // TODO: send 15% of the bet to the deployer

            // resets the state of the contract to start a new game
            initGame();
        }
        else if (isFull()) { // a draw
            // TODO: send all the bet to the deployer

            // resets the state of the contract to start a new game
            initGame();
        }
        else
            // next player will be the circle
            turn = Tile.CIRCLE;
    }

    // Circle makes the next move at positions (x,y), between 1 and 3
    function playCircle(uint x, uint y) private {
        if (circlePlayer == address(0)) {
            // TODO: require that the caller of the transaction is different from crossPlayer
            // since we do not allow crossPlayer to play against himself

            // TODO: require that the caller sent at least bet money
            // TODO: assign the caller of the transaction to circlePlayer
        }
        else {
            // TODO: require that circlePlayer is the caller of the transaction,
            // since otherwise somebody else is playing instead of him
        }

        // we take note that the position (x,y) has been played
        set(x, y, turn);
        // TODO: add to bet the money sent with the transaction

        if (isVictoryMove(x, y)) {
            // send 80% of the bet to the winner
            circlePlayer.call{value: bet * 80 / 100}("");
            // TODO: send 5% of the bet to the loser
            // TODO: send 15% of the bet to the deployer

            // resets the state of the contract to start a new game
            initGame();
        }
        else if (isFull()) { // a draw
            // TODO: send all the bet to the deployer

            // resets the state of the contract to start a new game
            initGame();
        }
        else
            // next player will be the cross
            turn = Tile.CROSS;
    }

    // Checks if the move at (x,y) leads to victory: either column x
    // contains the same tile, or row y contains the same tile, or
    // (x,y) is on one of the two diagonals and that diagonal contains the same tile
    function isVictoryMove(uint x, uint y) private view returns (bool) {
        // TODO
    }

    // Checks if the game is full, that is, all board positions are occupied,
    // none of them is empty
    function isFull() private view returns (bool) {
        // TODO
    }
}
