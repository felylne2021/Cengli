import { ethers } from "ethers6";
import { readFileSync } from "fs";

export const GOERLI_API_KEY = process.env.GOERLI_API_KEY ?? "";
export const MUMBAI_API_KEY = process.env.MUMBAI_API_KEY ?? "";
export const OPTIMISM_API_KEY = process.env.OPTIMISM_API_KEY ?? "";
export const ARBITRUM_API_KEY = process.env.ARBITRUM_API_KEY ?? "";
export const AVAX_API_KEY = process.env.AVAX_API_KEY ?? "";
export const PRIVATE_KEY = process.env.PRIVATE_KEY ?? "";

import fs from 'fs';
var jsonFile = './contracts/artifacts/contracts/USDCTransferCengli.sol/USDCTransferCengli.json';
var parsed = JSON.parse(fs.readFileSync(jsonFile));
var abi = parsed.abi;

export const goerliProvider = new ethers.JsonRpcProvider(GOERLI_API_KEY);
export const goerliSigner = new ethers.Wallet(PRIVATE_KEY, goerliProvider);
const goerliContract = new ethers.Contract("0xa0d2cAa1699bC7193a0eAA485160981ECE90f25F", abi, goerliSigner);

const polygonProvider = new ethers.JsonRpcProvider(MUMBAI_API_KEY)
const polygonSigner = new ethers.Wallet(PRIVATE_KEY, polygonProvider);
const polygonContract = new ethers.Contract("0x040115A44A07636B08368a998f43ECabF52dC1dE", abi, polygonSigner);

export const optimismProvider = new ethers.JsonRpcProvider(OPTIMISM_API_KEY);
export const optimismSigner = new ethers.Wallet(PRIVATE_KEY, optimismProvider);
const optimismContract = new ethers.Contract("0x919eaC55E76ea226825e19E5D36ED6B0D65B3DC1", abi, optimismSigner);

export const arbitrumProvider = new ethers.JsonRpcProvider(ARBITRUM_API_KEY);
export const arbitrumSigner = new ethers.Wallet(PRIVATE_KEY, arbitrumProvider);
const arbitrumContract = new ethers.Contract("0x919eaC55E76ea226825e19E5D36ED6B0D65B3DC1", abi, arbitrumSigner);

export const avaxProvider = new ethers.JsonRpcProvider(AVAX_API_KEY);
export const avaxSigner = new ethers.Wallet(PRIVATE_KEY, avaxProvider);
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
    [ChainIds.Polygon]: polygonContract,
    [ChainIds.Avax]: avaxContract,
    [ChainIds.Optimism]: optimismContract,
    [ChainIds.Arbitrum]: arbitrumContract
  };

  return contracts[chainId];
}