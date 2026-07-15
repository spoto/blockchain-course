// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity >=0.8.0 <0.9.0;

error NotOwner();

contract HelloWorld {
  address public owner;
  string public greeting = "Bom dia, pessoal!";

  constructor() {
    owner = msg.sender;
  }

  /**
   * @dev Prints Hello World string
   */
  function greet() public view returns (string memory) {
    require(owner == msg.sender, NotOwner());
    return greeting;
  }
}
