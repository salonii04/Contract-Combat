// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;


contract BuyMeACoffee {
    // Address of the contract owner who receives the donations
    address payable public owner;

    // Structure to store information about each coffee purchase
    struct Memo {
        address from; // Address of the sender
        uint256 timestamp; // Timestamp of the purchase
        string name; // Name of the sender (optional)
        string message; // Message from the sender (optional)
    }

    // Array to store all the coffee purchases (memos)
    Memo[] public memos;

    // Constructor function that sets the owner as the deployer
    constructor() {
        owner = payable(msg.sender);
    }

    // Function to allow buying a coffee with a message and name (optional)
    function buyCoffee(string memory _name, string memory _message) public payable {
        // Require a minimum amount to be sent (avoid 0 ETH purchases)
        require(msg.value > 0, "Can't buy a coffee with 0 eth");

        // Create a new Memo object with the sender's information and message
        memos.push(Memo(msg.sender, block.timestamp, _name, _message));
    }

    // Function to retrieve all the stored coffee purchases (memos)
    function getMemos() public view returns(Memo[] memory) {
        return memos;
    }
}
