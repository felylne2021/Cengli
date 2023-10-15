import { ethers } from "ethers";
import { readFileSync } from "fs";
import { prismaClient } from "../prisma.js";
import { sleep } from '../miscUtils.js';

const ERC20 = JSON.parse(readFileSync("utils/web3/abi/ERC20.json", "utf8"))
const CengliP2PEscrow = JSON.parse(readFileSync("utils/web3/abi/CengliP2PEscrow.json", "utf8"))

const provider = new ethers.JsonRpcProvider(process.env.GOERLI_API_KEY)
const controllerPrivateKey = process.env.P2P_CONTROLLER_PRIVATE_KEY;
export const controllerWallet = new ethers.Wallet(controllerPrivateKey, provider);

export const EscrowContractAddress = process.env.P2P_ESCROW_CONTRACT_ADDRESS

export const EscrowContract = new ethers.Contract(process.env.P2P_ESCROW_CONTRACT_ADDRESS, CengliP2PEscrow.abi, controllerWallet)

export const checkBalance = async (tokenAddress, ownerAddress) => {
  const tokenContract = new ethers.Contract(tokenAddress, ERC20, provider);
  const balance = await tokenContract.balanceOf(ownerAddress)
  const decimals = await tokenContract.decimals()

  const formattedBalance = Number(balance) / Math.pow(10, Number(decimals));

  return formattedBalance;
}

export const checkAllowance = async (tokenAddress, ownerAddress, spender) => {
  console.log('spender', spender)
  const tokenContract = new ethers.Contract(tokenAddress, ERC20, provider);
  const allowance = await tokenContract.allowance(ownerAddress, spender);
  const decimals = await tokenContract.decimals()

  const formattedAllowance = Number(allowance) / Math.pow(10, Number(decimals));
  console.log('formattedAllowance', formattedAllowance)

  return formattedAllowance;
};

export const depositToEscrow = async (buyerAddress, partnerAddress, tokenAddress, amount, orderId) => {
  const nextId = await EscrowContract.orderIdCounter()
  const depositRes = await EscrowContract.acceptOrder(buyerAddress, partnerAddress, tokenAddress, amount)
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

export const releaseFunds = async (contractOrderId) => {
  const releaseRes = await EscrowContract.releaseFunds(contractOrderId)
  // const receipt = await releaseRes.wait(1)

  console.log({
    releaseRes,
    // receipt
  })
}