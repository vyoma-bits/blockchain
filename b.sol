pragma solidity ^0.8.0;

contract ECommerce {
    address public owner;
    mapping(uint256 => Item) public items;
    uint256 public itemCount;

    struct Item {
        uint256 id;
        string name;
        uint256 price;
        bool available;
    }

    event ItemAdded(uint256 id, string name, uint256 price);
    event ItemPurchased(uint256 id, string name, uint256 price);
    event OwnerWithdraw(uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }

    function addItem(string memory _name, uint256 _price) external onlyOwner {
        itemCount++;
        items[itemCount] = Item(itemCount, _name, _price, true);
        emit ItemAdded(itemCount, _name, _price);
    }

    function purchaseItem(uint256 _id) external payable {
        require(items[_id].available, "Item not available");
        require(msg.value >= items[_id].price, "Insufficient funds");

        items[_id].available = false;
        payable(owner).transfer(msg.value);
        emit ItemPurchased(_id, items[_id].name, items[_id].price);
    }

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        payable(owner).transfer(balance);
        emit OwnerWithdraw(balance);
    }
}
