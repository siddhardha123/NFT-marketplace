// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract marketplace is ERC721URIStorage {

     address payable owner ;

     using Counters for Counters.Counter;
     Counters.Counter private _tokenIds;
     Counters.Counter private _itemsSold;
     uint256 listPrice = 0.001 ether;


    constructor() ERC721("marketplace","mkp"){
       owner  =  payable(msg.sender);

    }


    struct ListedToken {
      uint256  tokenID;
      address payable owner;
      address payable  seller;
      uint256  price;
      bool currentlyListed;
    }
    
    mapping(uint256 => ListedToken) private idToListedToken;

    function updateListPrice(uint256 _listPrice) public payable {
        require(owner == msg.sender,"only owner can change the price");
        listPrice = _listPrice;  
    }

    function getListPrice()public view returns(uint256){
        return listPrice;
    }

    function getLatestIdToListedToken() public view returns(ListedToken memory){
        uint256 currentTokenId = _tokenIds.current();
        return idToListedToken[currentTokenId];
    }

    function getListedForTokenId(uint256 _tokenId) public view returns(ListedToken memory){
         return idToListedToken[_tokenId];
    }

    function getCurrentToken() public view returns(uint256){
        return _tokenIds.current();
    }
    

    function createToken(string memory _tokenUri , uint256 _price) public payable returns(uint256){
        require(msg.value == listPrice,"list price is not matched");
        require(_price > 0,"price should be greater than 0");
        _tokenIds.increment();
        uint256 currentTokenId = _tokenIds.current();
        _safeMint(msg.sender,currentTokenId);
        _setTokenURI(currentTokenId,_tokenUri);
        createListedToken(currentTokenId,_price);
        return currentTokenId;
    }
    function createListedToken(uint256 _tokenId,uint256 _price) private {
        idToListedToken[_tokenId] = ListedToken(
            _tokenId,
            payable(address(this)),
            payable(msg.sender),
            _price,
            true
        );

        _transfer(msg.sender,address(this),_tokenId);
    }

    function getAllNFTs() public view returns (ListedToken[] memory) {
        uint nftCount = _tokenIds.current();
        ListedToken[] memory tokens = new ListedToken[](nftCount);
        uint currentIndex = 0;

        for(uint i=0;i<nftCount;i++)
        {
            uint currentId = i + 1;
            ListedToken storage currentItem = idToListedToken[currentId];
            tokens[currentIndex] = currentItem;
            currentIndex += 1;
        }
        return tokens;
    }
    
    function getMyNFTs() public view returns (ListedToken[] memory) {
        uint totalItemCount = _tokenIds.current();
        uint itemCount = 0;
        uint currentIndex = 0;
        
        for(uint i=0; i < totalItemCount; i++)
        {
            if(idToListedToken[i+1].owner == msg.sender || idToListedToken[i+1].seller == msg.sender){
                itemCount += 1;
            }
        }
        ListedToken[] memory items = new ListedToken[](itemCount);
        for(uint i=0; i < totalItemCount; i++) {
            if(idToListedToken[i+1].owner == msg.sender || idToListedToken[i+1].seller == msg.sender) {
                uint currentId = i+1;
                ListedToken storage currentItem = idToListedToken[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    function executeSale(uint256 tokenId) public payable {
        uint price = idToListedToken[tokenId].price;
        address seller = idToListedToken[tokenId].seller;
        require(msg.value == price, "Please submit the asking price in order to complete the purchase");
        idToListedToken[tokenId].currentlyListed = true;
        idToListedToken[tokenId].seller = payable(msg.sender);
        _itemsSold.increment();      
        _transfer(address(this), msg.sender, tokenId);
        approve(address(this), tokenId);
        payable(owner).transfer(listPrice);
        payable(seller).transfer(msg.value);
    }




}








