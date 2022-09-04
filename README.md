# Swap Station

<p align="center">
    <img src="https://raw.githubusercontent.com/jnlewis/swapstation-contracts/main/docs/screenshots/screenshot-intro-small.png" alt="">
</p>

#### Swap NFTs Across Blockchains

[SwapStation.io](https://www.swapstation.io/) is a platform that facilitates NFT swaps in and across chains. Featuring a one of a kind marketplace for NFT collectors to showcase, discover, and swap NFTs across different blockchains.

You can import any NFTs to SwapStation, put your token up for trade and start receiving swap offers. Likewise, if you see anything you like you can place an offer using a token you wish to exchange. The swap takes place when both parties accept the trade.

Absolutely no gas fees required when importing, creating listings and making offers. The only time a payment is required if when an actual swap transaction takes place.

**Contents**

- [Features](#features)
- [Process Flow](#process-flow)
- [Technologies](#technologies)
- [Live Product Preview](#live-product-preview)
- [Developer Quick Start Guide](#developer-quick-start-guide)
- [Interacting With the Contracts](#interacting-with-the-contracts)
- [Screenshots](#screenshots)

## Features

- Import any NFT into your personal collection.
- Put your tokens up for trade by creating discoverable listings.
- Browse other listings to find interesting NFTs where you can offer up your own NFT to exchange for it.
- Manage your collections, listings and offers through a personal dashboard.
- Accept offers for your NFT to make an exchange.
- Swap transactions takes place in the blockchain and is immutable.
- No gas fees required for importing, listing and making offers. The only time a payment is required if when an actual swap transaction takes place. (See architecture section to understand)

## Process Flow

<p align="center">
    <img src="https://raw.githubusercontent.com/jnlewis/swapstation-contracts/main/docs/images/swapstation-flow.png" alt="Process">
</p>

1. **Seller/Maker** imports NFT from supported blockchains into SwapStation, then puts their NFT up for trade by creating a listing.

2. **Buyer/Taker** browses available listings and make an offer on a listing by importing their own NFT into SwapStation.

3. If **seller** accepts an offer, the listed NFT is transfered to the buyer and the offered NFT is transfered to the seller.

4. **Seller** can cancels a listing and remove it from discoverability and all pending offers.

5. **Buyer** can retract an offer for a listing if it has not been accepted by the seller yet.

#### Same-Chain Swap Process

<p align="center">
    <img src="https://raw.githubusercontent.com/jnlewis/swapstation-contracts/main/docs/images/swapstation-samechain-process.png" alt="Same-Chain Process">
</p>

#### Cross-Chain Swap Process

<p align="center">
    <img src="https://raw.githubusercontent.com/jnlewis/swapstation-contracts/main/docs/images/swapstation-crosschain-process.png" alt="Cross-Chain Process">
</p>

## Technologies

<p align="center">
    <img width="600px" src="https://raw.githubusercontent.com/jnlewis/swapstation-contracts/main/docs/images/swapstation-architecture.png" alt="Architecture">
</p>

**Web Application (UX)**

- The frontend web application is developed in React using the **NextJS** framework. Integration with **NEAR** is via NEAR Wallet, and **TRON** via TronLink and TronWeb. Upcoming integrations with Ethereum and NEO blockchains is on the roadmap.

**API**

- There is a REST API that interface between the frontend web application with the underlying offchain database. The API is developed in NodeJS Express. We have plans to expand this API in the future to allow for third party integrations with SwapStation.

**Offchain Database**

- Most of the data powering the frontend application is held in an offchain database, which includes imported NFT collections, listings, offers and carbon copies of swap tranasction records. The only time where a transaction takes place in the blockchain is when an offer is accepted and a swap needs to take place.
- The primary purpose of this offchain database is to allow for zero fees so anyone can create as many listings and offers as they wish without worrying about cost, and they only need to pay once they decide to make a swap.

**Blockchain Smart Contracts**

- **SwapStation**: Smart Contracts repesenting the swap contract. This contract is responsible for the swap transaction that takes place when an offer is accepted. See [SwapStation Contract functions](#swap-station-contract-functions) for functions.

- **NFT**: A sample ERC-721/NEP-171 NFT contract using [OpenZeppelin](https://www.openzeppelin.com/) standard. We are using this contract as a sample for developing and testing the integration with the application.

## Developer Quick Start Guides

[NEAR](/contracts/near/README.md)

[TRON](/contracts/tron/README.md)

[Ethereum](/contracts/ethereum/README.md)

## Screenshots

<p align="center">
    <img src="https://raw.githubusercontent.com/jnlewis/swapstation-contracts/main/docs/screenshots/screenshot-intro-large.png" alt="">
</p>
<p align="center">
    <img src="https://raw.githubusercontent.com/jnlewis/swapstation-contracts/main/docs/screenshots/screenshot-import.png" alt="">
</p>
<p align="center">
    <img src="https://raw.githubusercontent.com/jnlewis/swapstation-contracts/main/docs/screenshots/screenshot-mycollection.png" alt="">
</p>
<p align="center">
    <img src="https://raw.githubusercontent.com/jnlewis/swapstation-contracts/main/docs/screenshots/screenshot-makeoffer.png" alt="">
</p>
<p align="center">
    <img src="https://raw.githubusercontent.com/jnlewis/swapstation-contracts/main/docs/screenshots/screenshot-viewlisting.png" alt="">
</p>
<p align="center">
    <img src="https://raw.githubusercontent.com/jnlewis/swapstation-contracts/main/docs/screenshots/screenshot-myoffer.png" alt="">
</p>
