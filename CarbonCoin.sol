pragma solidity ^0.4.18;

import "./ERC721.sol";



contract MyNonFungibleToken is ERC721 {
  /*** CONSTANTS ***/


  string public constant name = "CarbonCoin";
  string public constant symbol = "CC";

  bytes4 constant InterfaceID_ERC165 =
    bytes4(keccak256('supportsInterface(bytes4)'));

  bytes4 constant InterfaceID_ERC721 =
    bytes4(keccak256('name()')) ^
    bytes4(keccak256('symbol()')) ^
    bytes4(keccak256('myBalance()')) ^
    bytes4(keccak256('totalSupply()')) ^
    bytes4(keccak256('balanceOf(address)')) ^
    bytes4(keccak256('ownerOf(uint256)')) ^
    bytes4(keccak256('approve(address,uint256)')) ^
    bytes4(keccak256('transfer(address,uint256)')) ^
    bytes4(keccak256('transferFrom(address,address,uint256)')) ^
    bytes4(keccak256('tokensOfOwner(address)'));


  /*** DATA TYPES ***/

  struct Token {
    address mintedBy;
    uint64 vintage;
    string country;
    string description;
    uint256 tonnesCO2;
  }


  /*** STORAGE ***/

  Token[] tokens;

  mapping (uint256 => address) public tokenIndexToOwner;
  mapping (address => uint256) ownershipTokenCount;
  mapping (uint256 => address) public tokenIndexToApproved;

  uint256 public totalSup = 0;
  uint256 public totalSupp = 0;

  /*** EVENTS ***/
  event Created(uint64 typeEvent, address _to, uint256 _tokenId, uint64 vintage, string country, string description, uint256 tonnesCO2);
  event Absorbed(uint64 typeEvent, address _from, uint256 _tokenId, uint64 vintage, string country, string description, uint256 tonnesCO2);
  event Transfered(uint64 typeEvent, address _to, address _from, uint256 _tokenId, uint64 vintage, string country, string description, uint256 tonnesCO2);

  /*** INTERNAL FUNCTIONS ***/

  function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
    return tokenIndexToOwner[_tokenId] == _claimant;
  }

  function _transfer(address _from, address _to, uint256 _tokenId) internal {
    if (_to != address(0)) {
        ownershipTokenCount[_to]++;
        tokenIndexToOwner[_tokenId] = _to;
    }
    

    if (_from != address(0)) {
      ownershipTokenCount[_from]--;
      ///delete tokenIndexToApproved[_tokenId];
    }
    
    uint64 vintage;
    string memory country;
    string memory description;
    uint256 tonnesCO2;
    address mintedBy;
    
    Token memory token = tokens[_tokenId];

    mintedBy = token.mintedBy;
    vintage = token.vintage;
    country = string(token.country);
    description = token.description;
    tonnesCO2 = token.tonnesCO2;
    

    if (_from != address(0) && _to != address(0)) {
        emit Transfered(1, _from, _to, _tokenId, vintage, country, description, tonnesCO2);
    } else if (_from == address(0)) {
        emit Created(0, _to, _tokenId, vintage, country, description, tonnesCO2);
    } else if (_to == address(0)) {
        emit Absorbed(2, _from, _tokenId, vintage, country, description, tonnesCO2);
    }
    
    ///Transfer(_from, _to, _tokenId);
  }
  
 
 

  function _create(address _owner, string _country, string _description, uint256 _tonnesCO2) internal returns (uint256 tokenId) {
    
    Token memory token = Token({
      mintedBy: _owner,
      vintage: uint64(now),
      country: _country,
      description: _description,
      tonnesCO2: _tonnesCO2
      
    });
    
    tokenId = tokens.push(token) - 1;
    
    totalSup += 1;
    totalSupp += 1;

    ///Mint(_owner, tokenId);

    _transfer(0, _owner, tokenId);
  }


  /*** ERC721 IMPLEMENTATION ***/
  ///done!
  function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
    return ((_interfaceID == InterfaceID_ERC165) || (_interfaceID == InterfaceID_ERC721));
  }

  ///done!
  function totalSupply() public view returns (uint256) {
    return totalSup;
  }
  
  ///done!
  function balanceOf(address _owner) public view returns (uint256) {
    return ownershipTokenCount[_owner];
  }
  
  function myBalance() external view returns (uint256) {
    return ownershipTokenCount[msg.sender];
  }

  function ownerOf(uint256 _tokenId) external view returns (address owner) {
    owner = tokenIndexToOwner[_tokenId];

    require(owner != address(0));
  }
  
  function cancel(uint256 _tokenId) external {
    require(_owns(msg.sender, _tokenId));
    _transfer(msg.sender, 0, _tokenId);
    
    totalSup -= 1;
    
    
  }
  
  function approve(address _to, uint256 _tokenId) external {
      
  }


  function transfer(address _to, uint256 _tokenId) external {
    require(_to != address(0));
    require(_to != address(this));
    require(_owns(msg.sender, _tokenId));

    _transfer(msg.sender, _to, _tokenId);
  }

function transferFrom(address _from, address _to, uint256 _tokenId) external {
   
  }

  function tokensOfOwner(address _owner) external view returns (uint256[]) {
    uint256 balance = balanceOf(_owner);

    if (balance == 0) {
      return new uint256[](0);
    } else {
      uint256[] memory result = new uint256[](balance);
      uint256 maxTokenId = totalSupp;
      uint256 idx = 0;

      uint256 tokenId;
      for (tokenId = 1; tokenId <= maxTokenId; tokenId++) {
        if (tokenIndexToOwner[tokenId] == _owner) {
          result[idx] = tokenId;
          idx++;
        }
      }
    }

    return result;
  }
  
  function myTokens() external view returns (uint256[]) {
    address _owner = msg.sender;
    
    uint256 balance = balanceOf(_owner);

    if (balance == 0) {
      return new uint256[](0);
    } else {
      uint256[] memory result = new uint256[](balance);
      uint256 maxTokenId = totalSupp;
      uint256 idx = 0;

      uint256 tokenId;
      for (tokenId = 1; tokenId <= maxTokenId; tokenId++) {
        if (tokenIndexToOwner[tokenId] == _owner) {
          result[idx] = tokenId;
          idx++;
        }
      }
    }

    return result;
  }


  /*** OTHER EXTERNAL FUNCTIONS ***/

  function create(string country, string description, uint256 tonnesCO2) external returns (uint256) {
    return _create(msg.sender, country, description, tonnesCO2);
  }
  
  
  function getToken(uint256 _tokenId) external view returns (address mintedBy, uint64 vintage, string country, string description, uint256 tonnesCO2) {
    Token memory token = tokens[_tokenId];

    mintedBy = token.mintedBy;
    vintage = token.vintage;
    country = token.country;
    description = token.description;
    tonnesCO2 = token.tonnesCO2;
  }
  
}