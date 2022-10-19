// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "hardhat/console.sol";

contract Token {
    // The fixed amount of tokens, stored in an unsigned integer type variable.
    uint256 public totalSupply = 1000000;

    // An address type variable is used to store ethereum accounts.
    address public owner;

    uint public productPrice = 0;


    // A mapping is a key/value map. Here we store each account's balance.
    mapping(address => uint256) _balances;

    mapping(address => uint256) _productPrice; // cómo funciona el mapping? si devuelvo un objeto por ej.

    // The Transfer event helps off-chain applications understand
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Product(address indexed _from, string _message, uint256 _price, uint256 _value);

    constructor() {
        // The totalSupply is assigned to the transaction sender, which is the
        // account that is deploying the contract.
        _balances[msg.sender] = totalSupply;
        owner = msg.sender;

    }

    function getSupply() public view virtual returns (uint256) {
        return totalSupply;
    }

    /**Read only function to retrieve the token balance of a given account.*/
    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    /** A function to transfer tokens.*/
    function transfer(address to, uint256 amount) external {
        require(_balances[msg.sender] >= amount, "Not enough tokens");

        _balances[msg.sender] -= amount;
        _balances[to] += amount;

        // Notify off-chain applications of the transfer.
        emit Transfer(msg.sender, to, amount);
    }

    // Publish an offer or service 
    function addProduct(address account, string memory _message, uint256 _quantity, uint256 _value) external {
      require(account != address(0), "Account is the zero address");
      require(_quantity > 0 , 'Quantity must be greater than 0');
      require(_value > 0 , 'Value must be greater than 0');
      // Preguntar: tipo string cuando se recibe como parámetro


      emit Product(account,_message, _quantity, _value); //  diferencia entre emit y map? 
    }

    // buy a product receiving the product id
    function buyProduct(address account, uint256 productId) external pure {
      require(account != address(0), "Account is the zero address");
      require(productId <= 0, "Invalid product id");

    }

    // check if payment is correct
    function checkPayment(address account, uint256 purchaseId) external pure returns (bool) {
      require(account != address(0), "Account is the zero address");
      require(purchaseId <= 0, "Invalid product id");

      return true;
    }

    //Resolve if we have to pay to seller or return balance to buyer
    function resolveTransaction(uint complainId, bool payToSeller) external pure {
      require(complainId > 0, "Invalid complain id");
      
      if (payToSeller != true){
        // revert purchase
      } else {
        // pay to seller
      }
    }


}