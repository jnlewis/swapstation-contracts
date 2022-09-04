// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";

contract TRC721NFT {

  function transferFrom(address from, address to, uint256 tokenId) public {}

  function ownerOf(uint256 tokenId) public view returns (address) {}

  function isApprovedForAll(address owner, address operator) public view returns (bool) {}
}

contract SwapStation {

    event CreateOfferRecord(string indexed key, uint256 indexed offerAcceptanceNumber);
    event AcceptOfferRecord(string indexed key, uint256 indexed offerAcceptanceNumber);
    event Release(string indexed key, uint256 indexed offerAcceptanceNumber);
    event Refund(string indexed key, uint256 indexed offerAcceptanceNumber);
   
    enum OrderStatus { MakerAccepted, PendingRelease, Released, Refunded }

    using Counters for Counters.Counter;
    Counters.Counter private offerCounter;

    address public owner;

    mapping (string => OfferAcceptance) public offerAcceptance;

    struct OfferAcceptance
    {
        uint256 offerAcceptanceNumber;
        address makerTokenContract;
        uint256 makerTokenId;
        address takerTokenContract;
        uint256 takerTokenId;
        address makerAddress;
        address takerAddress;
        OrderStatus status;
    }

    modifier ownerOnly {
        require(msg.sender == owner, "Only contract owner can access this resource.");
        _;
    }

  constructor() {
    owner = msg.sender;
  }

  /**
    * @dev Called by maker after approving the token to this contract. Creates the offer acceptance record.
    */
  function acceptAsMaker(string memory key, address makerTokenContract, uint256 makerTokenId, address takerTokenContract, uint256 takerTokenId) public {

    TRC721NFT tokenContract = TRC721NFT(makerTokenContract);

    // Check that offer record does not exists
    require(offerAcceptance[key].makerTokenContract == address(0), "Offer acceptance record already exist.");
    
    // Verify ownership
    address tokenOwner = tokenContract.ownerOf(makerTokenId);
    require(msg.sender == tokenOwner, "Sender is not owner of the token.");

    // Verify approval status
    require(tokenContract.isApprovedForAll(tokenOwner, address(this)), "Contract is not approved to handle this token.");

    // Transfer the token to contract
    tokenContract.transferFrom(tokenOwner, address(this), makerTokenId);

    // Generate new offer acceptance number
    uint256 offerAcceptanceNumber = offerCounter.current();
    offerCounter.increment();
    
    // Create offer acceptance record
    offerAcceptance[key].offerAcceptanceNumber = offerAcceptanceNumber;
    offerAcceptance[key].makerTokenContract = makerTokenContract;
    offerAcceptance[key].makerTokenId = makerTokenId;
    offerAcceptance[key].takerTokenContract = takerTokenContract;
    offerAcceptance[key].takerTokenId = takerTokenId;
    offerAcceptance[key].makerAddress = msg.sender;
    offerAcceptance[key].takerAddress = address(0);
    offerAcceptance[key].status = OrderStatus.MakerAccepted;

    emit CreateOfferRecord(key, offerAcceptanceNumber);
  }

  /**
    * @dev Called by taker after approving the token to this contract. Updates the status of offer record to pending release.
    */
  function acceptAsTaker(string memory key, address makerTokenContract, uint256 makerTokenId, address takerTokenContract, uint256 takerTokenId) public {

    TRC721NFT tokenContract = TRC721NFT(takerTokenContract);

    // Check if offer record exists
    require(offerAcceptance[key].makerTokenContract != address(0), "Offer acceptance record does not exist.");

    // Verify that offer record matches the maker and taker token
    require(offerAcceptance[key].makerTokenContract != makerTokenContract, "Maker token contract in offer record does not match.");
    require(offerAcceptance[key].makerTokenId != makerTokenId, "Maker token ID in offer record does not match.");
    require(offerAcceptance[key].takerTokenContract != takerTokenContract, "Taker token contract in offer record does not match.");
    require(offerAcceptance[key].takerTokenId != takerTokenId, "Taker token ID in offer record does not match.");

    // Verify ownership
    address tokenOwner = tokenContract.ownerOf(takerTokenId);
    require(msg.sender == tokenOwner, "Sender is not owner of the token.");

    // Verify approval status
    require(tokenContract.isApprovedForAll(tokenOwner, address(this)), "Contract is not approved to handle this token.");

    // Transfer the token to contract
    tokenContract.transferFrom(tokenOwner, address(this), takerTokenId);

    // Update offer record
    offerAcceptance[key].takerAddress = msg.sender;
    offerAcceptance[key].status = OrderStatus.PendingRelease;

    emit AcceptOfferRecord(key, offerAcceptance[key].offerAcceptanceNumber);
  }

  /**
    * @dev Release the escrow and perform the swap transaction
    */
  function release(string memory key) public ownerOnly {
    
    // Check if offer record exists
    require(offerAcceptance[key].makerTokenContract != address(0), "Offer acceptance does not exist.");

    // Check status of offer record
    require(offerAcceptance[key].status == OrderStatus.PendingRelease, "Offer status is not pending release.");
    require(offerAcceptance[key].makerAddress != address(0), "Maker address is not available.");
    require(offerAcceptance[key].takerAddress != address(0), "Taker address is not available.");

    // Transfer maker token
    TRC721NFT makerTokenContract = TRC721NFT(offerAcceptance[key].makerTokenContract);
    makerTokenContract.transferFrom(owner, offerAcceptance[key].takerAddress, offerAcceptance[key].makerTokenId);

    // Transfer taker token
    TRC721NFT takerTokenContract = TRC721NFT(offerAcceptance[key].takerTokenContract);
    takerTokenContract.transferFrom(owner, offerAcceptance[key].makerAddress, offerAcceptance[key].takerTokenId);

    // Update offer record
    offerAcceptance[key].status = OrderStatus.Released;

    emit Release(key, offerAcceptance[key].offerAcceptanceNumber);
  }

  /**
    * @dev Refund the escrow and return the token to their respective owners
    */
  function refund(string memory key) public ownerOnly {

    // Check if offer record exists
    require(offerAcceptance[key].makerTokenContract != address(0), "Offer acceptance does not exist.");

    // Check status of offer record
    require(offerAcceptance[key].status != OrderStatus.Released, "Offer has already been released.");
    require(offerAcceptance[key].status != OrderStatus.Refunded, "Offer has already been refunded.");

    // Transfer maker token
    if (offerAcceptance[key].makerAddress != address(0)) {
      TRC721NFT makerTokenContract = TRC721NFT(offerAcceptance[key].makerTokenContract);
      makerTokenContract.transferFrom(owner, offerAcceptance[key].makerAddress, offerAcceptance[key].makerTokenId);
    }

    // Transfer taker token
    if (offerAcceptance[key].takerAddress != address(0)) {
      TRC721NFT takerTokenContract = TRC721NFT(offerAcceptance[key].takerTokenContract);
      takerTokenContract.transferFrom(owner, offerAcceptance[key].takerAddress, offerAcceptance[key].takerTokenId);
    }

    // Update offer record
    offerAcceptance[key].status = OrderStatus.Refunded;

    emit Refund(key, offerAcceptance[key].offerAcceptanceNumber);
  }
}
