import { HardhatUserConfig } from "hardhat/config";
import env from "dotenv";
import "@nomicfoundation/hardhat-toolbox";

env.config();

const GOERLI_API_KEY = process.env.GOERLI_API_KEY ?? "";
const OPTIMISM_API_KEY=process.env.OPTIMISM_API_KEY ?? "";
const ARBITRUM_API_KEY=process.env.ARBITRUM_API_KEY ?? "";
const AVAX_API_KEY=process.env.AVAX_API_KEY ?? "";
const MUMBAI_API_KEY = process.env.MUMBAI_API_KEY ?? "";

const PRIVATE_KEY = process.env.PRIVATE_KEY ?? "";
const CMC_API_KEY = process.env.CMC_API_KEY ?? "";
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY ?? "";
const ARBISCAN_API_KEY = process.env.ARBISCAN_API_KEY ?? "";
const OPSCAN_API_KEY = process.env.OPCAN_API_KEY ?? "";
const AVAXSCAN_API_KEY = process.env.AVAXSCAN_API_KEY ?? "";
const POLYGONSCAN_API_KEY = process.env.POLYGONSCAN_API_KEY ?? "";


const config: HardhatUserConfig = {
  solidity: "0.8.20",
  defaultNetwork: "localnet",
  networks: {
    localnet: {
      url: "http://127.0.0.1:8545/",
      // accounts don't need to be specified for hardhat
    },
    goerli: {
      url: GOERLI_API_KEY,
      accounts: [PRIVATE_KEY],
    },
    optimism: {
      url: OPTIMISM_API_KEY,
      accounts: [PRIVATE_KEY],
    },
    avax: {
      url: "https://api.avax-test.network/ext/bc/C/rpc",
      accounts: [PRIVATE_KEY],
    },
    arbitrum: {
      url: ARBITRUM_API_KEY,
      accounts: [PRIVATE_KEY],
    },
    polygon: {
      url: MUMBAI_API_KEY,
      accounts: [PRIVATE_KEY],
    },
  },
  gasReporter: {
    enabled: false,
    outputFile: "gas-report.txt",
    noColors: true,
    currency: "USD", // default eth/usd
    coinmarketcap: CMC_API_KEY,
  },
  etherscan: {
    apiKey: OPSCAN_API_KEY
  },
};

export default config;
