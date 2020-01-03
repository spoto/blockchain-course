pragma solidity ^0.4.26;

import "./D.sol";
import "./E.sol";

contract C {
    function foo(D _d, E _e, uint _n) public {
        _d.delegatecallSetN(_e, _n);
    }
}
