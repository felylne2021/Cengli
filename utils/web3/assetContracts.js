import { ethers } from "ethers";

const GOERLI_API_KEY = process.env.GOERLI_API_KEY ?? "";
const MUMBAI_API_KEY = process.env.MUMBAI_API_KEY ?? "";
const OPTIMISM_API_KEY = process.env.OPTIMISM_API_KEY ?? "";
const ARBITRUM_API_KEY = process.env.ARBITRUM_API_KEY ?? "";
const AVAX_API_KEY = process.env.AVAX_API_KEY ?? "";
const PRIVATE_KEY = process.env.PRIVATE_KEY ?? "";

import fs from 'fs';
var jsonFile = './contracts/artifacts/contracts/USDCTransferCengli.sol/USDCTransferCengli.json';
var parsed = JSON.parse(fs.readFileSync(jsonFile));
var abi = parsed.abi;

const goerliProvider = new ethers.JsonRpcProvider(GOERLI_API_KEY);
const goerliSigner = new ethers.Wallet(PRIVATE_KEY, goerliProvider);
const goerliContract = new ethers.Contract("0xa0d2cAa1699bC7193a0eAA485160981ECE90f25F", abi, goerliSigner);

// const polygonProvider = new ethers.JsonRpcApiProvider(MUMBAI_API_KEY);
// const polygonSigner = new ethers.Wallet(PRIVATE_KEY, polygonProvider);
// const polygonContract = new ethers.Contract("0xA1bD683B06b9B7F633cc7A96A9E5f0AE0662C6C4", abi, polygonSigner);

const optimismProvider = new ethers.JsonRpcProvider(OPTIMISM_API_KEY);
const optimismSigner = new ethers.Wallet(PRIVATE_KEY, optimismProvider);
const optimismContract = new ethers.Contract("0x919eaC55E76ea226825e19E5D36ED6B0D65B3DC1", abi, optimismSigner);

const arbitrumProvider = new ethers.JsonRpcProvider(ARBITRUM_API_KEY);
const arbitrumSigner = new ethers.Wallet(PRIVATE_KEY, arbitrumProvider);
const arbitrumContract = new ethers.Contract("0x919eaC55E76ea226825e19E5D36ED6B0D65B3DC1", abi, arbitrumSigner);

const avaxProvider = new ethers.JsonRpcProvider(AVAX_API_KEY);
const avaxSigner = new ethers.Wallet(PRIVATE_KEY, avaxProvider);
const avaxContract = new ethers.Contract("0xfFE648692689bD72Ba223F3feC1D16a0d9e7FAdB", abi, avaxSigner);

const ChainIds = {
  Goerli: 5,
  Polygon: 80001,
  Avax: 43113,
  Optimism: 420,
  Arbitrum: 421613
}

export const getContractByChain = (chainId) => {
  const contracts = {
    [ChainIds.Goerli]: goerliContract,
    // [ChainIds.Polygon]: polygonContract,
    [ChainIds.Avax]: avaxContract,
    [ChainIds.Optimism]: optimismContract,
    [ChainIds.Arbitrum]: arbitrumContract
  };

  return contracts[chainId];
}