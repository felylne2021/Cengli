import { ethers } from "ethers6";
import { readFileSync } from "fs";
import { prismaClient } from "../prisma.js";
import { sleep } from '../miscUtils.js';

const ERC20 = JSON.parse(readFileSync("utils/web3/abi/ERC20.json", "utf8"))
const CengliP2PEscrow = JSON.parse(readFileSync("utils/web3/abi/CengliP2PEscrow.json", "utf8"))

// const provider = new ethers.JsonRpcProvider(process.env.GOERLI_API_KEY)
// const controllerPrivateKey = process.env.P2P_CONTROLLER_PRIVATE_KEY;
// export const controllerWallet = new ethers.Wallet(controllerPrivateKey, provider);

const chainIdToApiKey = {
  43113: process.env.AVAX_API_KEY,
  80001: process.env.MUMBAI_API_KEY,
  5: process.env.GOERLI_API_KEY,
  420: process.env.OPTIMISM_API_KEY,
  421613: process.env.ARBITRUM_API_KEY
};

export const getEthersProvider = (chainId = 43113) => {
  const _chainId = parseInt(chainId);
  const rpcURL = chainIdToApiKey[_chainId];
  const _provider = new ethers.JsonRpcProvider(rpcURL);

  return _provider;
}

const getWallet = (privateKey, chainId = 43113) => {
  const _provider = getEthersProvider(chainId);
  const _wallet = new ethers.Wallet(privateKey, _provider);

  return _wallet;
}

// export const EscrowContractAddress = process.env.P2P_ESCROW_CONTRACT_ADDRESS

export const EscrowContractAddress = (chainId = 43113) => {
  let address;
  if (chainId == 43113) {
    address = process.env.P2P_ESCROW_CONTRACT_ADDRESS_AVAX
  } else if (chainId === 80001) {
    address = process.env.P2P_ESCROW_CONTRACT_ADDRESS_MUMBAI
  } else {
    throw new Error('Invalid chainId')
  }

  return address;
}

export const EscrowContract = (chainId = 43113) => {
  const wallet = getWallet(process.env.P2P_CONTROLLER_PRIVATE_KEY, chainId);
  const contract = new ethers.Contract(EscrowContractAddress(chainId), CengliP2PEscrow.abi, wallet)


  return contract;
}

export const checkBalance = async (tokenAddress, ownerAddress, provider) => {
  const tokenContract = new ethers.Contract(tokenAddress, ERC20, provider);
  const balance = await tokenContract.balanceOf(ownerAddress)
  const decimals = await tokenContract.decimals()

  // console.log({
  //   balance,
  //   decimals
  // })

  const formattedBalance = Number(balance) / Math.pow(10, Number(decimals));

  return formattedBalance;
}

export const checkAllowance = async (tokenAddress, ownerAddress, spender, provider) => {
  console.log('spender', spender)
  const tokenContract = new ethers.Contract(tokenAddress, ERC20, provider);
  const allowance = await tokenContract.allowance(ownerAddress, spender);
  const decimals = await tokenContract.decimals()

  const formattedAllowance = Number(allowance) / Math.pow(10, Number(decimals));
  console.log('formattedAllowance', formattedAllowance)

  return formattedAllowance;
};

export const depositToEscrow = async (buyerAddress, partnerAddress, tokenAddress, amount, orderId, chainId) => {
  const nextId = await EscrowContract(chainId).orderIdCounter()

  console.log({
    buyerAddress,
    partnerAddress,
    tokenAddress,
    amount,
    contract: await EscrowContract(chainId).getAddress()
  })
  const depositRes = await EscrowContract(chainId).acceptOrder(buyerAddress, partnerAddress, tokenAddress, BigInt(amount))
  // const receipt = await depositRes.wait(1)

  await sleep(3000)

  await prismaClient.p2POrderDeposit.create({
    data: {
      orderId: orderId,
      contractOrderId: nextId.toString(),
      txHash: depositRes.hash,
      from: depositRes.from,
      to: depositRes.to,
    }
  })

  console.log({
    depositRes,
    // receipt
  })
}

export const cancelOrder = async (contractOrderId) => {
  const cancelRes = await EscrowContract.cancelOrder(contractOrderId)
  // const receipt = await cancelRes.wait(1)

  await sleep(3000)

  console.log({
    cancelRes,
    // receipt
  })
}

export const releaseFunds = async (contractOrderId, chainId) => {
  const releaseRes = await EscrowContract(chainId).releaseFunds(contractOrderId)
  // const receipt = await releaseRes.wait(1)

  console.log({
    releaseRes,
    // receipt
  })
}