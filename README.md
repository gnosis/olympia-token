# OLY Token Contract

This is the Olympia token contract implementation:
  - Rinkeby:
    - Address: [`0xcD38db007C75052269A847892C245a4431B8570A`](https://rinkeby.etherscan.io/address/0xcd38db007c75052269a847892c245a4431b8570a)
    - Creator: `0x76C5AF09C7724EdFD68dfCe98A9C6E15e48EaED7`

The mainnet address registry can be found:
  - Rinkeby:
    - Address: [`0x87ab379dbec3376B8E5DDC5080C0e4778b105069`](https://rinkeby.etherscan.io/address/0x87ab379dbec3376b8e5ddc5080c0e4778b105069)
    - Creator: `0x76C5AF09C7724EdFD68dfCe98A9C6E15e48EaED7`

# Deployment of custom contracts on Rinkeby

```sh
git clone https://github.com/gnosis/olympia-token
cd olympia-token
```

Create a `truffle-local` file and **configure your account** for rinkeby (recommended network) with
12 words mnemonic:

```js
var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "void crawl erase remove sail disease step company machine crime indoor square"; // 12 word mnemonic
var provider = new HDWalletProvider(mnemonic, "https://rinkeby.infura.io:443");
const config = {
  networks: {
      rinkeby: {
          port: 443,
          network_id: "4",
          provider: provider,
          gasPrice: 50000000000
      },
  },
}
module.exports = config;
```

Then run:

```sh
npm install
npm run compile
npm run migrate -- --network rinkeby
```

You have now the addresses for AddressRegistry and Olympia Token, should be something like:

```
OlympiaToken: 0x2924e2338356c912634a513150e6ff5be890f7a0
AddressRegistry: 0x12f73864dc1f603b2e62a36b210c294fd286f9fc
```
