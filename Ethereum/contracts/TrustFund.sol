// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity >=0.8.0 <0.9.0;

contract TrustFund {
    address payable[3] public _recipients;
    uint[3] public withdrawn;

    constructor(address payable[3] memory recipients) {
        _recipients = recipients;
    }

    function updateChild(address payable newRecipient) public {
        if (msg.sender == _recipients[0])
            _recipients[0] = newRecipient;
        else if (msg.sender == _recipients[1])
            _recipients[1] = newRecipient;
        else if (msg.sender == _recipients[2])
            _recipients[2] = newRecipient;
        else
            revert("Unknown recipient");
    }

    receive() external payable { }

    function withdraw() public returns (bool success) {
        // we reconstruct the total balance, including what has been already withdrawn
        uint balance = address(this).balance + withdrawn[0] + withdrawn[1] + withdrawn[2];
        uint diff;
        uint num;

        if (msg.sender == _recipients[0])
            // we send the total part for the first child, minus what it already withdrew
            diff = balance / 2 - withdrawn[num = 0];
        else if (msg.sender == _recipients[1])
            diff = balance / 4 - withdrawn[num = 1];
        else if (msg.sender == _recipients[2])
            diff = balance / 4 - withdrawn[num = 2];
        else
            revert("Unknown recipient");

        if (diff > 0) {
            // makes reentrancy useless
            withdrawn[num] += diff;
            (success, ) = msg.sender.call{value: diff}("");
            if (!success)
                // revert to previous withdrawn value
                withdrawn[num] -= diff;
        }
        else
            success = true;
    }
}
