# Swap Station Contract - TRON

#### Deploying the Contracts to TRON

Pre-requisite: [TronBox](https://github.com/tronprotocol/tronbox)
1. Clone the source code from repo
```
> git clone https://github.com/jnlewis/swapstation.git
```

2. Configure environment variables
Create the file .env in packages/contracts. Place the following content in the file:
```
export PRIVATE_KEY_SHASTA=<wallet private key>
export PRIVATE_KEY_NILE=<wallet private key>
export PRIVATE_KEY_LOCAL=<wallet private key>
```

3. Compile and Deploy the NFT Sample and SwapStation smart contracts

```
From the project root folder:
> cd packages/contracts
> tronbox compile --compile-all
> tronbox migrate --reset --network nile
```

Note: If you would like to skip deploying the NFT sample, edit the file `packages/contracts/migrations/2_deploy_contracts.js` to omit it from `artifacts.require`

3. See [Interacting With the Contracts](#interacting-with-the-contracts) for directly using the contracts or [Running Web Application](#running-web-application) for setting up the frontend.

#### Interacting With the Contracts

You can use TRON Block Explorer to directly interact with the contract:
- **SwapStation Contract** - [TWLxY4ugk4xConePYBjeG8RxqWNmsWkZqc](https://nile.tronscan.org/?_ga=2.227027742.2064602395.1658309195-1802108451.1657443118#/contract/TWLxY4ugk4xConePYBjeG8RxqWNmsWkZqc)
- **Sample NFT Contract** - [TUxk4J3dnoQayyqhoUrehokXhrgyUMK8Db](https://nile.tronscan.org/?_ga=2.227027742.2064602395.1658309195-1802108451.1657443118#/contract/TUxk4J3dnoQayyqhoUrehokXhrgyUMK8Db)

