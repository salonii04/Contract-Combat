// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

contract MyContract {
    //basic details of user
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint256 value);

    // identifiers and events for voting
    event VoteCast(address indexed voter, VoteOption option);

    enum VoteOption { A, B, C }
    mapping(address => bool) public hasVoted;
    mapping(address => VoteOption) public votes;
    uint256 public votes_A;
    uint256 public votes_B;
    uint256 public votes_C;

    // magic coins for bonus on different tasks
    uint256 public magicCoins;
    
    // identifiers and events for lottery ticketing
    address payable public owner;
    uint256 public start_time;
    uint256 public end_time;
    uint256 public ticket_price;
    address public contract_address;
    uint256 public tokenId;
    mapping(address => uint256) public ticketsBought;
    address[] public participants;
    event LotteryTicketBought(address indexed buyer, uint256 ticketsBought);
    event LotteryWinnerSelected(address indexed winner);
    
    // identifiers and events for realEstate transactions
    address payable public seller;
    address payable public buyer;
    uint256 public price;
    bool public paymentReceived;
    bool public legalFormalitiesCompleted;
    event PaymentReceived(address indexed payer, uint256 amount);
    event LegalFormalitiesCompleted();

    // Catalogue items for shopping
    enum ItemType { Toy, Clothes, Makeup, Accessories }
    mapping(ItemType => uint256) public itemPrices;

    event ItemPurchased(address indexed buyer, ItemType itemType);

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _initialSupply,
        uint256 _start_time,
        uint256 _end_time,
        uint256 _ticket_price,
        address _contract_address,
        uint256 _tokenId
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _initialSupply * 10**uint256(_decimals);
        balanceOf[msg.sender] = totalSupply;

        owner = payable(msg.sender);
        start_time = _start_time;
        end_time = _end_time;
        ticket_price = _ticket_price;
        contract_address = _contract_address;
        tokenId = _tokenId;

        // Initialize item prices
        itemPrices[ItemType.Toy] = 400;
        itemPrices[ItemType.Clothes] = 2000;
        itemPrices[ItemType.Makeup] = 1500;
        itemPrices[ItemType.Accessories] = 3000;
    }

    function transferTokens(address _to, uint256 _value) external returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    function vote(VoteOption _option) external {
        require(!hasVoted[msg.sender], "Already voted");
        require(_option == VoteOption.A || _option == VoteOption.B || _option == VoteOption.C, "Invalid vote option");

        votes[msg.sender] = _option;
        hasVoted[msg.sender] = true;

        // Increase the count for the corresponding vote option
        if (_option == VoteOption.A) {
            votes_A++;
        } else if (_option == VoteOption.B) {
            votes_B++;
        } else if (_option == VoteOption.C) {
            votes_C++;
        }

        magicCoins += 10; // Give 10 magicCoins to the voter
        emit VoteCast(msg.sender, _option);
    }

    function buyTickets(uint256 _numTickets) external payable {
        require(block.timestamp >= start_time && block.timestamp <= end_time, "Lottery is not active");
        require(msg.value == ticket_price * _numTickets, "Incorrect amount sent");

        ticketsBought[msg.sender] += _numTickets;

        for (uint256 i = 0; i < _numTickets; i++) {
            participants.push(msg.sender);
        }

        balanceOf[msg.sender] += msg.value; // Add lottery ticket money to balance
        magicCoins += 6; // Give 6 magicCoins to the buyer
        emit LotteryTicketBought(msg.sender, _numTickets);
    }

    function selectWinner() external {
        require(msg.sender == owner, "Only owner can select winner");
        require(block.timestamp > end_time, "Lottery is still active");

        require(participants.length > 0, "No participants");

        uint256 randomNumber = uint256(keccak256(abi.encodePacked(block.timestamp, block.basefee, participants.length)));
        uint256 winnerIndex = randomNumber % participants.length;
        address winner = participants[winnerIndex];

        // Transfer NFT to winner
        MyContract tokenContract = MyContract(contract_address);
        tokenContract.transferTokens(winner, tokenId);

        emit LotteryWinnerSelected(winner);
    }

    function initiateTransaction(address payable _buyer) external {
        require(seller == address(0), "Transaction already initiated");
        seller = payable(msg.sender);
        buyer = _buyer;
    }

    function confirmPayment() external payable {
        require(msg.sender == buyer, "Only buyer can confirm payment");
        require(msg.value == price, "Incorrect payment amount");
        require(seller != address(0), "Transaction not initiated");

        seller.transfer(msg.value); // Send payment to the seller
        paymentReceived = true;
        emit PaymentReceived(msg.sender, msg.value);
    }

    function completeLegalFormalities() external {
        require(msg.sender == seller, "Only seller can complete legal formalities");
        require(paymentReceived, "Payment not received yet");

        balanceOf[buyer] -= price; // Deduct real estate transaction money from buyer's balance
        balanceOf[seller] += price; // Add real estate transaction money to seller's balance

        legalFormalitiesCompleted = true;
        emit LegalFormalitiesCompleted();
    }

    function shopping(ItemType _itemType) external {
        uint256 itemPrice = itemPrices[_itemType];
        require(balanceOf[msg.sender] >= itemPrice, "Insufficient balance");

        balanceOf[msg.sender] -= itemPrice; // Deduct item price from buyer's balance
        magicCoins += itemPrice / 10; // Give 10% of the item price in magicCoins

        emit ItemPurchased(msg.sender, _itemType);
    }
}
