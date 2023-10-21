require('dotenv').config({ path: __dirname + '/.env' });
const HDWalletProvider = require('@truffle/hdwallet-provider');

const privateKey = process.env.PRIVATE_KEY;
const infuraProjectId = process.env.INFURA_API_KEY

module.exports = {
  networks: {
    goerli: {
      provider: () =>
        new HDWalletProvider(privateKey, `wss://goerli.infura.io/ws/v3/${infuraProjectId}`),
      network_id: 5,
      confirmations: 2,
      timeoutBlocks: 200,
      networkCheckTimeout: 10000,
      skipDryRun: true,
      gas: 20000000,
    },
    mumbai: {
      provider: () =>
        new HDWalletProvider(privateKey, `https://rpc.ankr.com/polygon_mumbai`),
      network_id: 80001,
      confirmations: 2,
      timeoutBlocks: 3000,
      networkCheckTimeout: 20000,
      skipDryRun: true,
      gas: 2000000,
    },
    avax: {
      provider: () =>
        new HDWalletProvider(privateKey, `https://rpc.ankr.com/avalanche_fuji`),
      network_id: 43113,
      confirmations: 2,
      timeoutBlocks: 3000,
      networkCheckTimeout: 20000,
      skipDryRun: true,
      // gas: 15000000,
    }
  },

  mocha: {
    // timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.19",
      settings: {
        optimizer: {
          enabled: true,
          runs: 1000
        }
      }
    }
  },
  plugins: [
    'truffle-plugin-verify'
  ],
  api_keys: {
    etherscan: process.env.ETHERSCAN_API_KEY,
    polygonscan: process.env.POLYGONSCAN_API_KEY,
    testnet_snowtrace: process.env.SNOWTRACE_API_KEY,
    snowtrace: process.env.SNOWTRACE_API_KEY,
  },
};
