// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity >=0.8.0 <0.9.0;

contract HelloWorld {

  /**
   * @dev Prints Hello World string
   */
  function greet() public pure returns (string memory) {
    return "Hello World!";
  }
}
