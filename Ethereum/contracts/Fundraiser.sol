// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Fundraiser is Ownable {
    string public name;
    string public description;
    address payable public beneficiary;

    struct Donation {
        uint256 value;
        uint256 date;
    }

    mapping(address => Donation[]) public donations;
    uint256 public totalDonations;
    uint256 public donationsCount;

    event DonationReceived(address indexed donor, uint256 value);
    event Withdraw(uint256 amount);

    constructor(string memory _name, string memory _description, address payable _beneficiary) Ownable(msg.sender) { // constructor chaining
        name = _name;
        description = _description;
        beneficiary = _beneficiary;
    }

    function setBeneficiary(address payable _beneficiary) public onlyOwner {
        beneficiary = _beneficiary;
    }

    function donate() public payable {
        Donation memory donation = Donation({ value: msg.value, date: block.timestamp });
        donations[msg.sender].push(donation);
        totalDonations += msg.value;
        donationsCount++;
        emit DonationReceived(msg.sender, msg.value);
    }

    function myDonations() public view returns(uint256[] memory values, uint256[] memory dates) {
        uint256 count = donations[msg.sender].length;
        values = new uint256[](count);
        dates = new uint256[](count);

        for (uint256 i = 0; i < count; i++) {
            Donation storage donation = donations[msg.sender][i];
            values[i] = donation.value;
            dates[i] = donation.date;
        }

        return (values, dates);
    }

    function myDonations2() public view returns(Donation[] memory _donations) {
        return donations[msg.sender];
    }

    function withdraw() public onlyOwner returns (bool success) {
        uint256 balance = address(this).balance;
        (success, ) = beneficiary.call{value: balance}("");
        if (success)
            emit Withdraw(balance);
    }

    // it could be used for anonymous donations, hence we do not generate an event
    receive() external payable {
        totalDonations += msg.value;
        donationsCount++;
    }
}
