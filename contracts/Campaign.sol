// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract CampaignFactory {

    address[] public deployedCampaigns;

    event campaignCreated(
        string title,
        uint _requiredAmount,
        address indexed owner,
        address campaignAddress,
        string imgURi,
        uint indexed timestamp,
        string indexed category
    );

    function createCampaign(
        string memory campaignTitle, uint requiredCampaignAmount,
        string memory imgURI,
        string memory category,
        string memory storyURI) public {
            Campaign newCampaign = new Campaign(
                campaignTitle, 
                requiredCampaignAmount, 
                imgURI, 
                storyURI);

            deployedCampaigns.push(address(newCampaign));
            emit campaignCreated(campaignTitle,
            requiredCampaignAmount, 
            msg.sender, 
            address(newCampaign), 
            imgURI, 
            block.timestamp, 
            category);
    }
}

contract Campaign {
    string public title;
    uint public requiredAmount;
    string public image;
    string public story;
    address payable public owner;
    uint public receivedAmount;

    event Donate(address indexed donar, uint indexed amount, uint indexed timestamp);
    constructor(string memory _title,
    uint _requiredAmount,
    string memory imgURI,
    string memory storyURI) {
        title = _title;
        requiredAmount = _requiredAmount;
        image = imgURI;
        story = storyURI;
        owner = payable(msg.sender);
    }

    function donate() public payable {
        require(requiredAmount > receivedAmount, "required amount fulfilled");
        require(msg.value > 0, "Donation should be greater than 0");
        owner.transfer(msg.value);
        receivedAmount+=msg.value;
        emit Donate(msg.sender, msg.value, block.timestamp);

    }

}