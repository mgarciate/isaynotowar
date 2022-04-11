# I say no to War

I say no to war is a project inspired and forked from the conceptual art project "The Signatures" by Simon de la Rouviere

It's not only aimed to raise funds for the humanitarian action of Unchain.fund to relieve our Ukrainian brothers and sisters suffering, but to be the first web3 signatures collection, against war, and show the world a massive amount of inmutable signatures as onchain svg's forever in the Ethereum blockchain. 

There is no capped supply as opposition to war should not have a cap, everyone can mint their proofs of opposition to war just paying the gas or attach an amount in ETH to unchain's fund ETH multisig, hardcoded in the NFT contract. 

As in Simon's project , the importance of provenance and date in NFT's is what is really meaningful not the image itselt , and in this case stamping our big no to war forever.

## Recipient address
Unchain.fund address:
`0x10E1439455BD2624878b243819E31CfEE9eb721C`

## Config
```solidity
address public owner = 0x0;
```
Replace the owner address by an address that will be able to edit the NFT and Collection metadata in OpenSea. It could be the same address that deploys the contract.

## How to deploy
Compile:
```shell
npx hardhat compile
```
Test:
```shell
npx hardhat test
```
Deploy:
```shell
npx hardhat run scripts/isaynotowar-deploy-script.js --network <network>
```
Verify:
```shell
npx hardhat verify --network <network> <contract> "I say no to War" "NOWAR"
```

## process.env
```
MAINNET_URL = ""
GOERLI_URL = ""
RINKEBY_URL = ""
PRIVATE_KEY = ""
ETHERSCAN_API_KEY = ""
```

## Hardhat commands
Try running some of the following tasks:

```shell
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/isaynotowar-deploy-script.js
npx hardhat help
```
