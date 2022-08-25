// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

//INTERNAL IMPORT FOR NFT OPENZIPLINE
import "@openzeppelin/contracts/utils/Counters.sol"; // using as a counter whit keep track of id and counter
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol"; // Using ERC721 standard
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "hardhat/console.sol";

contract NFTMarketplace is ERC721URIStorage{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;
    Counters.Counter private _tokenSold;
    
    uint256 listingPrice = 0.0015 ether;
    address payable owner;
    mapping(uint256 => MarketItem) private idMarketItem;

    struct MarketItem {
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    event idMarketItemCreated(
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    modifier onlyOwner{
        require(
            msg.sender == owner,
            "only owner can change the price"
        )
        _;
    }

    constructor() ERC721("NFT Metavarse Token","MYNFT"){
            
        owner == payable(msg.sender);
    }

    function updateListingPrice(uint256 _listingPrice) 
      public 
      payable
      onlyOwner
      {

        listingPrice = _listingPrice
         
    } 

    function getListingPrice() public view returns (uint256){
         return listingPrice;
    }

    // let  create "CREATE NFT TOKEN FUNCTION

    function createToken(string memory tokenURI,uint256 price) public payable returns(uint256){
       _tokenIds.increment(); 

       uint256 newTokenid = _tokenIDs.current();

       _mint(msg.sender,newTokenId);
       _setTokenURI(newtokenId, tokenURI);
       createMarketItem(newTokenId,price);

       return newTokenid;
    }

    //creating market item
   function createMarketItem(uint256 tokenId, uint256 price) private {
       require(price > 0)
   }
}





