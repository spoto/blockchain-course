// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity >=0.8.0 <0.9.0;

contract SlotMachine {
  uint constant public PRICE = 0.001 ether;
  address private owner;

  constructor() payable {
    require(msg.value == PRICE * 10, "You must buy 10 tickets at deployment"); // 10 finneys
    owner = msg.sender;
  }

  function play() payable public {
    require(msg.value == PRICE, "You must pay for exactly one ticket"); // 1 finney
    uint winner = random(4, msg.sender);
    if (winner == 0) { // 25% of the times
      // in case of victory, the player earns 3 times the price
      (bool success, ) = msg.sender.call{value: 4 * PRICE}("");
      require(success, "Transfer failed");
    }
  }

  function withdraw() public {
    require(owner == msg.sender, "Only the creator of the contract can do that");
    (bool success, ) = msg.sender.call{value: address(this).balance}("");
    require(success, "Transfer failed");
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
