pragma solidity ^ 0.8.17;

contract MarketPlace {
  string public name;
  uint public productCount = 0;

  mapping(uint => Product) public products;

  struct Product {
    uint id;
    string name;
    uint price;
    address payable owner;
    bool purchased;
  }

  event ProductCreated(
    uint id,
    string name,
    uint price,
    address payable owner,
    bool purchased
  );

  event ProductSeller(
    uint id,
    string name,
    uint price,
    address payable owner,
    bool purchased
  );

  constructor() public {
    name = "Sudhan";
  }

  function createProduct(string memory _name, uint _price) public {
    // Required Valid Name
    require(bytes(_name).length > 0);
    // Required Valid Price
    require(_price > 0);
    // Incrémentation du products
    productCount ++;
    // Création du produit
    products[productCount] = Product(productCount, _name, _price, msg.sender, false);
    //Trigger the enter
    emit ProductCreated(productCount, _name, _price, msg.sender, false);
  }

  function purchaseProduct(uint _id) public payable {
    // Fetch des products
    Product memory _product = products[_id];
    // Fetch des owner
    address payable _seller = _product.owner;
    // Verif que le produit a une identité valide
    require(_product.id > 0 && _product.id <= productCount);
    // Verif ether
    require(msg.value >= _product.price);
    // Verif que le produit ne soit pas acheté avant
    require(!_product.purchased);
    // Verif que le vendeur ne peut pas acheter son propre produit
    require(_seller != msg.sender, "Seller can't buy his own product");
    _product.owner = msg.sender;
    _product.purchased = true;
    products[_id] = _product;
    // Paiement du vendeur
    address(_seller).transfer(msg.value);
    emit ProductSeller(productCount, _product.name, _product.price, msg.sender, true);

  }

}
