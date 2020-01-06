pragma solidity ^0.4.26;

import "./E.sol";

contract D {
    uint public n;
    address public sender;
    
    function ordinarycallSetN(E _e, uint _n) public {
        _e.setN(_n);
    }

    function ordinarycallWithCastSetN(address _e, uint _n) public {
        E(_e).setN(_n);
    }

    function callSetN(address _e, uint _n) public {
        _e.call(abi.encodeWithSignature("setN(uint256)", _n));
    }

    function callcodeSetN(address _e, uint _n) public {
        _e.callcode(abi.encodeWithSignature("setN(uint256)", _n));
    }
    
    function delegatecallSetN(address _e, uint _n) public {
        _e.delegatecall(abi.encodeWithSignature("setN(uint256)", _n));
    }
}
