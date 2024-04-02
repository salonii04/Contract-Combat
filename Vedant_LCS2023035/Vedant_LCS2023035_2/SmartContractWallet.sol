//Set Owner of the Wallet
//Allow certain expenses for certain accounts
//Set Guardians for the total Wallet
//Reset Owner for majority of the guardians' vote 

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract Consumer{
    function getBalance() public view returns (uint){
        return address(this).balance;
    }

    function deposit() public payable{}
}

contract WalletImplementation {
    address payable public Owner;
    address payable nextOwner;

    mapping(address => bool) public isAllowed;
    mapping(address => uint256) public Allowances;

    uint256 public constant ConfirmationOfGuardiansForOwnerReset = 3;
    uint256 public GuardianCount;

    mapping(address => bool) public isGuardian;

    constructor() {
        Owner = payable(msg.sender);
    }

    function DenySending(address payable _from) public {
        require(msg.sender==Owner);
        isAllowed[_from]=false;
    }

    function SetAllowance(address _add,uint _allowance) public {
        require(msg.sender==Owner);
        isAllowed[_add]=true;
        Allowances[_add]=_allowance;
    }

    function SetGuardian(address payable _add, bool _isGuardian) public {
        require(msg.sender == Owner, "You are not the owner");
        isGuardian[_add] = _isGuardian;
    }

    function ProposeChangeinOwner(address payable newOwner) public {
        require(isGuardian[msg.sender], "You are not a guardian");
        if (newOwner != nextOwner) {
            newOwner = nextOwner;
            GuardianCount = 0;
        }

        GuardianCount++;

        if (GuardianCount >= ConfirmationOfGuardiansForOwnerReset) {
            Owner = nextOwner;
            nextOwner=payable (address(0));
        }
    }

    function TransferFunds(address payable _to, uint256 _amount, bytes memory _payload) public returns (bytes memory) {
        //require(msg.sender==Owner);
        if (msg.sender != Owner) {
            require(isAllowed[msg.sender], "You are not allowed to send money");
            require(
                Allowances[msg.sender] >= _amount,
                "You are trying to send more money than you are allowed,Aborting!"
            );
            Allowances[msg.sender] -= _amount;
        }
        (bool success, bytes memory returnValue) = _to.call{value: _amount}(
            _payload
        );
        require(success, "Transaction was unsuccessful");
        return returnValue;
    }

    receive() external payable {}
}
