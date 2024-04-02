// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract dao {
    struct Proposal {
        uint256 id;
        string description;
        uint256 amount;
        address payable recipent;
        uint256 votes;
        uint256 endTime; // time for proposal will be open to be voted upon
        bool isExecuted;
    }
    mapping(address => bool) private isInvestor;
    mapping(address => uint256) private numofShares;
    mapping(address => mapping(uint256 => bool)) private isVoted;
    mapping(address => mapping(address => bool)) public withdrawlStatus;// withdrawed the funds or not 
    address[] public investorList;
    mapping(uint256 => Proposal) public proposals;

    uint256 public totalShares;
    uint256 public availableFunds;
    uint256 private contributionTimeEnd;
    uint256 private nextProposalId;
    uint256 public voteTime;
    uint256 public quorum;// how much percent votes needed to pass proposal
    address public manager;

    constructor(
        uint256 _contributionTimeEnd,
        uint256 _voteTime,
        uint256 _quorum
    ) {
        require(_quorum > 0 && _quorum < 100, "not valid values");
        contributionTimeEnd = block.timestamp + _contributionTimeEnd;// proposal ending time
        voteTime = _voteTime;
        quorum = _quorum;
        manager = msg.sender;
    }

    modifier onlyInvestor() {
        require(isInvestor[msg.sender] == true, "You are not sender");
        _;
    }
    modifier onlyManager() {
        require(manager == msg.sender, "You are not sender");
        _;
    }

    function contribute() public payable {//contribut to become investor
        require(
            contributionTimeEnd >= block.timestamp,
            "contribution time ended"
        );
        require(msg.value > 0, "send more than 0 ether");
        isInvestor[msg.sender] = true;
        numofShares[msg.sender] = numofShares[msg.sender] + msg.value;
        totalShares += msg.value;
        availableFunds += msg.value;
        investorList.push(msg.sender);
    }

// investor can take back their share
    function redeemShares(uint256 amount) public onlyInvestor {
        
        require(
            numofShares[msg.sender] >= amount,
            "You don't have enough shares"
        );
        require(availableFunds >= amount, "not enough funds");
        numofShares[msg.sender] -= amount; 
        if (numofShares[msg.sender] == 0) {
            isInvestor[msg.sender] = false;
        }
        availableFunds -= amount;
        payable(msg.sender).transfer(amount); //transferring the ether
    }

    // investors want to transfer share
    function transferShare(uint256 amount, address to) public onlyInvestor {
        require(
            numofShares[msg.sender] >= amount,
            "You don't have enough shares"
        );
        require(availableFunds >= amount, "not enough funds");

        numofShares[msg.sender] -= amount; //subtracting  from array
        if (numofShares[msg.sender] == 0) {
            isInvestor[msg.sender] = false;
        }
        numofShares[to] += amount;
        isInvestor[to] = true; // after aquiring share he becomes investor
        investorList.push(to);
    }

    //making new proposal which only manager can me 
    function createProposal(
        string calldata description,
        uint256 amount,
        address payable receiptent
    ) public onlyManager {
        require(availableFunds >= amount, "not enough ether");
        proposals[nextProposalId] = Proposal(
            nextProposalId,
            description,
            amount,
            receiptent,
            0,
            block.timestamp + voteTime,
            false
        );
        nextProposalId++;
    }

    // only investors can vote for any proposal
    function voteProposal(uint256 proposalId) public onlyInvestor {
        Proposal storage proposal = proposals[proposalId]; // created to reduce complexity
        require(
            isVoted[msg.sender][proposalId] == false,
            "You have already voted"
        );
        require(proposal.endTime >= block.timestamp, "voting toime ended");
        require(proposal.isExecuted == false, "it is already executed");
        isVoted[msg.sender][proposalId] = true;
        proposal.votes += numofShares[msg.sender];
    }

    // proposal getting majority wins
    function executeProposal(uint256 proposalId) public onlyManager {
        Proposal storage proposal = proposals[proposalId];
        require(
            ((proposal.votes * 100) / totalShares) >= quorum,
            "Majority does not support"
        );
        proposal.isExecuted = true;
        availableFunds -= proposal.amount;
        _transfer(proposal.amount, proposal.recipent);
    }

    function _transfer(uint256 amount, address payable receipient) private {
        receipient.transfer(amount);
    }

    // all proposals address stored
    function ProposalList() public view returns (Proposal[] memory) {
        Proposal[] memory arr = new Proposal[](nextProposalId); //empty array of length=nextProposalId-1
        for (uint256 i = 0; i < nextProposalId; i++) {
            arr[i] = proposals[i];
        }
        return arr;
    }
    
    // all investors address stored
    function InvestorList() public view returns (address[] memory) {
        return investorList;
    }
}
