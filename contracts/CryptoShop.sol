// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "hardhat/console.sol";

contract CryptoShop {
    event NewProduct(uint256 index, CatalogItem item);
    event Transfer(address indexed from, address indexed to, uint256 value);

    mapping(address => uint256) balances;
    mapping(uint256 => CatalogItem) public itemMapped;

    struct CatalogItem {
        string description;
        uint256 price; //ether values are in wei, one ether = 1e18wei
        uint stock;
    }

    // An address type variable is used to store ethereum accounts.
    address public owner;
    uint256 public totalSupply = 5;

    CatalogItem[] catalog;

    constructor() {
        owner = msg.sender;
        balances[msg.sender] = totalSupply;
    }

    function balanceOf(address account) external view returns (uint256) {
        console.log(balances[owner]);
        return balances[account];
    }

    function getCatalogLength() external view returns (uint256) {
        return catalog.length;
    }

    function getCatalogItemAt(uint16 index)
        external
        view
        returns (
            string memory description,
            uint256 price,
            uint stock
        )
    {
        require(index < catalog.length, "Item not found");
        CatalogItem storage item = catalog[index]; //A: storage porque no lo vamos a modificar ni devolver
        return (item.description, item.price, item.stock);
    }

    //Publish an offer or service
    function addProduct(
        string memory description,
        uint256 price,
        uint stock
    ) external returns (uint256) {
        require(price > 0, "Price must be greater than 0");
        require(stock > 0, "Stock must be greater than 0");
        //TODO: revisar descripción - string convertido en bytes?

        CatalogItem memory item = CatalogItem(description, price, stock); //A: memory porque lo estamos creando- se usa para cambiar y devolver
        catalog.push(item);

        uint256 index = catalog.length - 1;
        emit NewProduct(index, item); //A: return index
        return index;
    }

    // buy a product receiving the product id
    function buyProduct(uint256 productId,uint256 price,uint32 units,address to) external {
        require(productId >= 0, "Invalid product id");
        require(units > 0, "Not enough stock to complete transaction"); //TODO: compare units with existing stock
        require(balances[msg.sender] >= price, "Not enough tokens");

        //TODO: reduce stock amount

        // Transfer the amount.
        balances[msg.sender] -= price;
        balances[to] += price;

        // Notify off-chain applications of the transfer.
        emit Transfer(msg.sender, to, price);
    }

    // check if payment is correct
    function checkPayment(address account, uint256 purchaseId)
        external
        pure
        returns (bool)
    {
        require(account != address(0), "Account is the zero address");
        require(purchaseId <= 0, "Invalid product id");

        return true;
    }

    //Resolve if we have to pay to seller or return balance to buyer
    function resolveTransaction(uint complainId, bool payToSeller)
        external
        pure
    {
        require(complainId > 0, "Invalid complain id");

        if (payToSeller != true) {
            // revert purchase
        } else {
            // pay to seller
        }
    }
}
