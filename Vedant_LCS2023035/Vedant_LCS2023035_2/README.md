## Multi-Signature Wallet with Guardian Approval

This README.md file describes the `WalletImplementation` contract, a secure multi-signature wallet with guardian approval for owner changes.

**Features:**

* **Multi-Signature Transactions:** Requires permission from authorized addresses before sending funds.
* **Spending Limits:** Sets spending limits for authorized addresses to prevent unauthorized spending.
* **Guardian Approval:** Leverages guardians to vote on and approve owner changes.
* **Security:**
    * Prevents the owner from revoking permissions of guardians.
    * Requires a majority vote from guardians to change the owner.

**Components:**

* **Owner:** The current owner of the wallet, who can manage permissions and propose owner changes.
* **Guardians:** Designated addresses with voting rights for owner changes.
* **Authorized Addresses:** Addresses allowed to send funds from the wallet, subject to spending limits.

**Functionalities:**

* **`DenySending(address payable _from)`:** (Only Owner) Revokes spending permission for an address.
* **`SetAllowance(address _add, uint _allowance)`:** (Only Owner) Sets a spending limit for an authorized address.
* **`SetGuardian(address payable _add, bool _isGuardian)`:** (Only Owner) Grants or revokes guardian status for an address.
* **`ProposeChangeinOwner(address payable newOwner)`:** (Only Guardians) Proposes a new owner for the wallet. Requires a majority vote from guardians to approve.
* **`TransferFunds(address payable _to, uint256 _amount, bytes memory _payload)`:** Sends funds from the wallet. Requires permission and sufficient allowance for non-owner senders.

**Deployment and Usage:**

1. Deploy the contract on your desired blockchain network.
2. The initial deployer becomes the owner.
3. The owner can set guardians and authorized addresses.
4. Guardians can propose and vote on owner changes.
5. Authorized addresses can send funds within their limits.
