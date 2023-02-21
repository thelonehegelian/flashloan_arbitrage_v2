import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-ethers";
import "hardhat-nodemon";

require("dotenv").config();
/**
 * @type import('hardhat/config').HardhatUserConfig
 */

const environment = {
  chainId: 31337, // chain ID for hardhat testing
  NODE_ENV: process.env.ARCHIVE_NODE,
  blockNumber: 14390000,
};

module.exports = {
  solidity: {
    compilers: [
      { version: "0.8.0" },
      { version: "0.6.12" },
      { version: "0.7.6" },
      { version: "0.5.16" },
    ],
  },
  networks: {
    hardhat: {
      chainId: environment.chainId,
      forking: {
        url: environment.NODE_ENV,
        blockNumber: environment.blockNumber,
      },
    },
  },
};
