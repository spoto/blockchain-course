// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity >=0.8.0 <0.9.0;

contract TrustFundGeneral {
    mapping(address => bool) public recipients;
    uint public totalRecipients;
    mapping(address => uint) public withdrawn;
    uint public totalWithdrawn;

    function register() public {
        if (!recipients[msg.sender]) {
            recipients[msg.sender] = true;
            totalRecipients++;
        }
    }

    receive() external payable {}

    function withdraw() public returns (bool success) {
        if (recipients[msg.sender]) {
            // the previous condition guarantess that totalRecipients > 0 below
            uint allocation = (address(this).balance + totalWithdrawn) / totalRecipients;
            uint amount = allocation - withdrawn[msg.sender];

            if (amount > 0) {
                // this assignment makes any reentrancy attempt useless
                withdrawn[msg.sender] += amount;
                // forwards all gas, so that any receive() function is ok
                (success, ) = payable(msg.sender).call{value: amount}("");
                if (success)
                    totalWithdrawn += amount;
                else
                    // revert the effect if the failed transfer
                    withdrawn[msg.sender] -= amount;
            }
            else
                success = true;
        }
        else
            revert("Unknown recipient");
    }
}
