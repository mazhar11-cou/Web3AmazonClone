// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Dappazon {
    address public owner;

    struct Item {
        uint256 id;
        string name;
        string category;
        string image;
        uint256 cost;
        uint256 ratting;
        uint256 stock;
    }

    struct Order {
        uint256 time;
        Item item;
    }

    mapping(uint256 => Item) public items;
    mapping(address => uint256) public orderCount;
    mapping(address => mapping(uint256 => Order)) public orders;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    event List(string name, uint256 cost, uint256 quantity);
    event Buy(address buyer, uint256 orderId, uint256 itemId);


    constructor() {
        owner = msg.sender;
    }

    // List products
    function list(
        uint256 _id,
        string memory _name,
        string memory _category,
        string memory _image,
        uint256 _cost,
        uint256 _ratting,
        uint256 _stock
    ) public onlyOwner {
        // Create Iteam struc Iteam
        Item memory item = Item(
            _id,
            _name,
            _category,
            _image,
            _cost,
            _ratting,
            _stock
        );

        // Save Iteam to the blockchain
        items[_id] = item;

        // Emit an event
        emit List(_name, _cost, _stock);
    }

    // Buy Products
    function buy(uint256 _id) public payable {
        // Receive Crypto

        // Fetch item
        Item memory item = items[_id];

        //require enough ethers to buy item
        require(msg.value>=item.cost);

        //require enough stock to buy
        require(item.stock > 0);


        // Create an order
        Order memory order = Order(block.timestamp, item);

        // Add order for user
        orderCount[msg.sender]++;
        orders[msg.sender][orderCount[msg.sender]] = order;

        //substruck stocks
        items[_id].stock = item.stock - 1;

        // emit evernt
        emit Buy(msg.sender, orderCount[msg.sender],item.id);
    }

    // Withdraw funds

        function withdraw() public onlyOwner {
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success);
    }

}
