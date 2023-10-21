
import {
  ComethWallet,
  ConnectAdaptor
} from "@cometh/connect-sdk"
import axios from "axios"
import { ethers } from "ethers6"

import { estimateSafeTxGas } from "../utils/web3/comethHelpers.js"

import { prismaClient } from "../utils/prisma.js"
import { readFileSync } from "fs"
import { avaxProvider } from "../utils/web3/assetContracts.js"
import { validateRequiredFields } from "../utils/validator.js"
import { hyperlaneAvaxContract } from '../utils/web3/hyperlaneContracts.js';

const SafeFactoryABI = JSON.parse(readFileSync("utils/web3/abi/SafeFactory.json", "utf8"))
const ERC20ABI = JSON.parse(readFileSync("utils/web3/abi/ERC20.json", "utf8"))

export const COMETH_API_BASE_URL = 'https://api.connect.cometh.io'

const getCometh = (chainId = 43113) => {
  const _chainId = parseInt(chainId)

  if (_chainId !== 43113 && _chainId !== 80001) {
    throw new Error('Invalid chainId')
  }

  let apiKey;
  let rpcUrl;

  if (_chainId === 43113) {
    apiKey = process.env.COMETH_AVAX_API_KEY
    rpcUrl = process.env.COMETH_AVAX_RPC_URL
  } else if (_chainId === 80001) {
    apiKey = process.env.COMETH_MUMBAI_API_KEY
    rpcUrl = process.env.COMETH_MUMBAI_RPC_URL
  }

  const walletAdaptor = new ConnectAdaptor({
    chainId,
    apiKey,
    rpcUrl
  });

  const wallet = new ComethWallet({
    authAdapter: walletAdaptor,
    apiKey,
    rpcUrl
  });

  const provider = wallet.getProvider();

  return { adaptor: walletAdaptor, wallet, provider, apiKey, rpcUrl };
}

const SafeFactoryContract = (address, provider) => {
  return new ethers.Contract(
    address,
    SafeFactoryABI,
    provider
  )
}

const getUserNonce = async (address) => {
  try {
    const nonce = Number(await SafeFactoryContract(address).getFunction('nonce')())
    console.log('nonce', nonce)

    return nonce.toString()
  } catch (error) {
    // can error if address have not created a safe yet
    console.error('getUserNonce error, address have not created a safe yet', error)
    return "0"
  }
}

export const comethRoutes = async (server) => {
  const checkSponsoredAddress = async (address, reply) => {
    const sponsored = await prismaClient.comethSponsoredAddress.findFirst({
      where: {
        targetAddress: address.toLowerCase()
      }
    })
    if (!sponsored) {
      return reply.code(400).send(`Address ${address} is not sponsored, please add it to the list`)
    }
  }

  const generateToBeSignedTransaction = async (safeTxDataTyped, walletAddress) => {
    const toBeSignedTransaction = {
      domain: {
        chainId: 43113,
        verifyingContract: walletAddress
      },
      types: {
        to: safeTxDataTyped.to,
        value: safeTxDataTyped.value,
        data: safeTxDataTyped.data,
        operation: "0",
        safeTxGas: "0",
        baseGas: "0",
        gasPrice: "0",
        gasToken: '0x0000000000000000000000000000000000000000',
        refundReceiver: '0x0000000000000000000000000000000000000000',
        // maybe nonce will be converted to bigint in client
        nonce: safeTxDataTyped.nonce ? safeTxDataTyped.nonce : (await getUserNonce(walletAddress)).toString()
      }
    }

    toBeSignedTransaction.domain.chainId = toBeSignedTransaction.domain.chainId.toString()
    toBeSignedTransaction.types.value = toBeSignedTransaction.types.value.toString()

    console.log('toBeSignedTransaction', toBeSignedTransaction)
    return toBeSignedTransaction
  }

  /* --------------------------------- Routes --------------------------------- */

  server.get('/sponsored-address', async (request, reply) => {
    try {
      const sponsored = await prismaClient.comethSponsoredAddress.findMany({})
      return reply.code(200).send(sponsored)
    } catch (error) {
      console.error('An error occurred:', error)
      return reply.code(500).send({ message: error })
    }
  })

  server.post('/sponsored-address', async (request, reply) => {
    try {
      const { targetAddress } = request.body

      // check if address is already sponsored
      const sponsored = await prismaClient.comethSponsoredAddress.findFirst({
        where: {
          targetAddress: targetAddress.toLowerCase()
        }
      })

      if (sponsored) {
        return reply.code(400).send({
          message: `Address ${targetAddress} is already sponsored`
        })
      }

      const createSponsored = await axios({
        method: 'POST',
        url: `${COMETH_API_BASE_URL}/sponsored-address`,
        headers: {
          apiSecret: process.env.COMETH_API_SECRET
        },
        data: {
          targetAddress: targetAddress
        }
      })
      console.log('createSponsored', createSponsored.data)

      await prismaClient.comethSponsoredAddress.create({
        data: {
          chainId: 43113,
          targetAddress: targetAddress.toLowerCase()
        }
      })

      return reply.code(200).send(createSponsored.data)
    } catch (error) {
      console.error('An error occurred:', error)
      return reply.code(500).send({ message: error })
    }
  })

  server.post('/prepare-tx', async (request, reply) => {
    try {
      const { safeTransactionData, walletAddress, chainId = 43113 } = request.body
      const { provider, wallet } = getCometh(chainId);


      const safeTxGas = await estimateSafeTxGas({
        walletAddress: walletAddress,
        safeTransactionData: safeTransactionData,
        provider: provider
      })
      console.log('safeTxGas', safeTxGas)

      // const safeTxDataTyped = Object.assign({}, (yield this._prepareTransaction(safeTxData.to, safeTxData.value, safeTxData.data)));
      const safeTxDataTyped = Object.assign(
        {},
        await wallet._prepareTransaction(safeTransactionData.to, safeTransactionData.value, safeTransactionData.data)
      )
      console.log('safeTxDataTyped', safeTxDataTyped)

      // check sponsored address
      const sponsored = await prismaClient.comethSponsoredAddress.findFirst({
        where: {
          targetAddress: safeTxDataTyped.to.toLowerCase()
        }
      })
      if (!sponsored) {
        return reply.code(400).send(`Address ${safeTxDataTyped.to} is not sponsored, please add it to the list`)
      }

      const toBeSignedTransaction = {
        domain: {
          chainId: 43113,
          verifyingContract: walletAddress
        },
        types: {
          to: safeTxDataTyped.to,
          value: safeTxDataTyped.value,
          data: safeTxDataTyped.data,
          operation: "0",
          safeTxGas: "0",
          baseGas: "0",
          gasPrice: "0",
          gasToken: '0x0000000000000000000000000000000000000000',
          refundReceiver: '0x0000000000000000000000000000000000000000',
          // maybe nonce will be converted to bigint in client
          nonce: safeTxDataTyped.nonce ? safeTxDataTyped.nonce : (await getUserNonce(walletAddress)).toString()
        }
      }

      console.log('toBeSignedTransaction', toBeSignedTransaction)

      return reply.code(200).send(toBeSignedTransaction)
    } catch (error) {
      console.error('An error occurred:', error)
      return reply.code(500).send({ message: error })
    }
  })

  server.post('/prepare-erc20-tx', async (request, reply) => {
    try {
      const { walletAddress, tokenAddress, functionName, args, chainId } = request.body
      const { wallet } = getCometh(chainId);

      await validateRequiredFields(request.body, ['walletAddress', 'tokenAddress', 'functionName'], reply)

      const provider = avaxProvider
      const contract = new ethers.Contract(tokenAddress, ERC20ABI, provider);

      console.log({
        walletAddress,
        tokenAddress,
        functionName,
        args
      })

      const approveTx = await contract[functionName].populateTransaction(...args, {
        from: walletAddress,
        value: "0",
        chainId: "43313"
      })

      const safeTxDataTyped = Object.assign({}, await wallet._prepareTransaction(approveTx.to, approveTx.value, approveTx.data))

      // check sponsored address
      await checkSponsoredAddress(safeTxDataTyped.to, reply)

      const toBeSignedTransaction = await generateToBeSignedTransaction(safeTxDataTyped, walletAddress)

      return reply.code(200).send(toBeSignedTransaction)
    } catch (error) {
      console.error('prepare-erc20-tx:', error)
      return reply.code(500).send({ message: error })
    }
  })

  // add padding to regular address to become bytes32
  const toBytes32 = (address) => {
    return '0x' + address.slice(2).padStart(64, '0');
  };

  server.post('/prepare-usdc-bridge-transfer-tx', async (request, reply) => {
    try {
      const { walletAddress, recipientAddress, fromChainId, destinationChainId, amount, tokenAddress } = request.body;
      await validateRequiredFields(request.body, ['walletAddress', 'recipientAddress', 'fromChainId', 'destinationChainId', 'amount'], reply);

      const { wallet } = getCometh(fromChainId);

      if (parseInt(fromChainId) !== 43113) {
        return reply.code(400).send({ message: 'Only support Avalanche Fuji Testnet (43113)' });
      }

      const fromChain = await prismaClient.chain.findFirst({
        where: {
          chainId: parseInt(fromChainId)
        }
      })

      const destinationChain = await prismaClient.chain.findFirst({
        where: {
          chainId: parseInt(destinationChainId)
        }
      })

      if (!fromChain || !destinationChain) {
        return reply.code(404).send({ message: 'Chain not found, only support Polygon Mumbai Testnet and Avalanche Fuji Testnet' });
      }

      const transferTx = await hyperlaneAvaxContract['transferXchainHypERC20'].populateTransaction(destinationChainId, toBytes32(recipientAddress), amount * 10 ** 6, {
        from: walletAddress,
        value: "0",
        chainId: fromChainId
      })

      const safeTxDataTyped = Object.assign({}, await wallet._prepareTransaction(transferTx.to, transferTx.value, transferTx.data))

      await checkSponsoredAddress(safeTxDataTyped.to, reply)

      const toBeSignedTransaction = await generateToBeSignedTransaction(safeTxDataTyped, walletAddress)
      console.log('toBeSignedTransaction', toBeSignedTransaction)

      return reply.code(200).send(toBeSignedTransaction)
    } catch (error) {
      console.error('prepare-usdc-bridge-transfer-tx:', error)
      return reply.code(500).send({ message: error })
    }
  })
}