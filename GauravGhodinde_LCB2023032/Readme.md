# BuyMeACoffee DApp

"BuyMeACoffee" is a smart contract designed for DApp which intends to support the opensource creaters by enabling anyone to donate the creaters in the form of Ethereum (ETH) for buying a coffee.

It also allows users to send a message along with their donation.

# Project Details
the messages and transaction details are stored in an array tracking all the Donations along with "Personized Message"

The constructor function sets the owner variable to the address of the deployer of the contract.

Used modifier `onlyOwner` to restrict the access to the change owner function, therby only owner can change the owner.

## Future Todos
- complete the DApp by building frontend
- Make it easy for the creaters to integrate their metamask wallet

## Versions
solidity >=0.7.0 <0.9.0;


## License

[MIT](https://choosealicense.com/licenses/mit/)