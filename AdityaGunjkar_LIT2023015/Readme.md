# Decentralized Autonomous Organization (DAO) Smart Contract
This Solidity smart contract represents a Decentralized Autonomous Organization (DAO), where participants can contribute funds, create proposals, vote on proposals, and execute them based on the consensus of the DAO members.

#### Features:

Contribution: Participants can contribute Ether to the DAO to become investors and acquire shares proportional to their contributions.

Redeem Shares: Investors can redeem their shares and withdraw their proportionate amount of Ether from the DAO.

Transfer Shares: Investors can transfer their shares to other addresses.

Create Proposal: The manager can create proposals to allocate funds from the DAO for various purposes such as investments, expenses, etc.

Vote on Proposal: Investors can vote on proposals to approve or reject them.

Execute Proposal: If a proposal receives sufficient votes (based on a predefined quorum), the manager can execute the proposal, transferring the allocated funds to the designated recipient.

#### Contract Structure:
Structs
Proposal: Represents a proposal created by the manager, containing details such as description, amount, recipient, voting status, and execution status.
Variables
isInvestor: Mapping to track whether an address is an investor or not.

numofShares: Mapping to track the number of shares held by each investor.

isVoted: Mapping to track whether an investor has voted on a particular proposal or not.

withdrawlStatus: Mapping to track the withdrawal status of funds by investors.

investorList: Array to store the list of investors.

proposals: Mapping to store the proposals created by the manager.

Modifiers
onlyInvestor: Modifier to restrict access to functions to only investors.

onlyManager: Modifier to restrict access to functions to only the manager.

Functions
contribute(): Allows participants to contribute Ether to become investors.

redeemShares(): Allows investors to redeem their shares and withdraw Ether.

transferShare(): Allows investors to transfer shares to other addresses.

createProposal(): Allows the manager to create proposals to allocate funds.

voteProposal(): Allows investors to vote on proposals.

executeProposal(): Allows the manager to execute proposals if they receive sufficient votes.

ProposalList(): Returns an array containing all proposals.

InvestorList(): Returns an array containing all investors.

#### Functionality

Participants contribute Ether to become investors. Investors can vote for a particular proposal based on the shares they possess.
Proposals can only be created by the manager. After the manager creates proposals, an investor can vote for the proposal they desire to be executed.

If a proposal receives a vote percentage greater than the set quorum, the proposal is set to be implemented.

To vote for a proposal, there is a particular time within which an investor has to vote, after which they cannot vote.

If an investor wants to transfer their shares, they can do so by using "transferShares."If an invester transfers all his shares to another then 
he no longer remains an invester and cannot vote for proposals furthermore. 

If an investor wants their money back and gives up shares, they can do so by using "redeemShares."


#### Contract Deployment Instructions:

Before deploying the contract, ensure that you have configured the following parameters:

1.Contribution Time: Specify the duration for which participants can contribute Ether to become investors.(input in seconds).

2.Vote Time: Set the time window during which investors can vote for proposals.(input in seconds).

3.Quorum: Define the minimum percentage of votes required for a proposal to be executed.(Between 0 to 100).

4.The address with which we contribute will become an investor. The deploying address will be of manager.

5.Create proposal takes name of proposal,amount needed and address of recipient as input.



