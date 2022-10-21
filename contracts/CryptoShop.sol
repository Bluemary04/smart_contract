// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "hardhat/console.sol";

contract CryptoShop {
    event NewProduct(uint256 index);

    struct CatalogItem{
      string description;
      uint256 price; //ether values are in wei, one ether = 1e18wei
      uint stock;
    }

    // An address type variable is used to store ethereum accounts.
    address public owner;

    CatalogItem[] catalog;

    constructor() {
        owner = msg.sender;
    }

    function getCatalogLength() external view returns (uint256) {
        return catalog.length;
    }

    function getCatalogItemAt(uint16 index) external view returns (string memory description, uint256 price, uint stock) {
        require(index < catalog.length , 'Item not found');
        CatalogItem storage item = catalog[index]; //A: storage porque no lo vamos a modificar ni devolver
        return (item.description, item.price, item.stock);
    }

    // // Publish an offer or service 
    function addProduct(string calldata description, uint256 price, uint stock) external returns (uint256) {
      require(price > 0 , 'Price must be greater than 0');
      require(stock > 0 , 'Stock must be greater than 0');
      //TODO: revisar descripción - string convertido en bytes?

      CatalogItem memory item = CatalogItem(description, price, stock); //A: memory porque lo estamos creando- se usa para cambiar y devolver
      catalog.push(item);

      uint256 index = catalog.length -1;
      emit NewProduct(index);  //A: return index
      return index;
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