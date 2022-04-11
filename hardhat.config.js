require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require('dotenv').config({path: './process.env'})

const { GOERLI_URL, RINKEBY_URL, PRIVATE_KEY, ETHERSCAN_API_KEY } = process.env;

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  networks: {
    hardhat: {
    },
    mainnet: {
      url: `${MAINNET_URL}`,
      accounts: [`${PRIVATE_KEY}`],
    },
    goerli: {
      url: `${GOERLI_URL}`,
      accounts: [`${PRIVATE_KEY}`],
    },
    rinkeby: {
      url: `${RINKEBY_URL}`,
      accounts: [`${PRIVATE_KEY}`],
    }
  },
  etherscan: {
    apiKey: `${ETHERSCAN_API_KEY}`,
  },
  solidity: "0.8.4",
};
