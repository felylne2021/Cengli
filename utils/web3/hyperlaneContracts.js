import { ethers } from "ethers6";
import { readFileSync } from "fs";
import { avaxSigner } from "./assetContracts.js";
import { getEthersProvider } from "./p2pController.js";

const HypERC20TransferCengliABI = JSON.parse(readFileSync('utils/web3/abi/HypERC20TransferCengli.json'))

export const hyperlaneAvaxContract = new ethers.Contract('0x89e2139c21254d799595051E0F3F1F5bA34Ac2c2',HypERC20TransferCengliABI, avaxSigner)

export const HyperlaneWarpRouteContract = (chainId = 43113, bridgeAddress) => {
  const provider = getEthersProvider(chainId);
  const contract = new ethers.Contract(bridgeAddress, HypERC20TransferCengliABI, provider);

  return contract;
}

const USDCTransferCengliABI = JSON.parse(readFileSync('utils/web3/abi/USDCTransferCengli.json'))

export const HyperlaneCCTPRouteContract = (chainId = 43113, bridgeAddress) => {
  const provider = getEthersProvider(chainId);
  const contract = new ethers.Contract(bridgeAddress, USDCTransferCengliABI, provider);

  return contract;
}
