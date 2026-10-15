// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity >=0.8.0 <0.9.0;

contract Notary {

  string private _message;

  constructor (string memory message) {
    _message = message;
  }

  function info() public view returns (string memory) {
    return _message;
  }
}
