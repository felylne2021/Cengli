
import {
  ComethWallet,
  ComethProvider,
  ConnectAdaptor,
  SupportedNetworks,
} from "@cometh/connect-sdk"
import axios from "axios"
import { ethers } from "ethers"

import { estimateSafeTxGas } from "../utils/web3/comethHelpers.js"

import { prismaClient } from "../utils/prisma.js"
import { readFileSync } from "fs"

const SafeFactoryABI = JSON.parse(readFileSync("utils/web3/abi/SafeFactory.json", "utf8"))

export const COMETH_API_BASE_URL = 'https://api.connect.cometh.io'

export const comethRoutes = async (server) => {
  // Initiate Cometh on Fuji
  const walletAdaptor = new ConnectAdaptor({
    chainId: SupportedNetworks.FUJI,
    apiKey: process.env.COMETH_API_KEY,
    rpcUrl: process.env.COMETH_RPC_URL
  })

  const wallet = new ComethWallet({
    authAdapter: walletAdaptor,
    apiKey: process.env.COMETH_API_KEY,
    rpcUrl: process.env.COMETH_RPC_URL
  })

  const provider = wallet.getProvider()

  const SafeFactoryContract = (address) => {
    return new ethers.Contract(
      address,
      SafeFactoryABI,
      provider
    )
  }

  const getUserNonce = async (address) => {
    const nonce = Number(await SafeFactoryContract(address).getFunction('nonce')())
    console.log('nonce', nonce)
    return nonce
  }

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
      const { safeTransactionData, walletAddress } = request.body

      const safeTxGas = await estimateSafeTxGas({
        walletAddress: walletAddress,
        safeTransactionData: safeTransactionData,
        provider: provider
      })
      console.log('safeTxGas', safeTxGas)

      // const safeTxDataTyped = Object.assign({}, (yield this._prepareTransaction(safeTxData.to, safeTxData.value, safeTxData.data)));
      const safeTxDataTyped = Object.assign({}, await wallet._prepareTransaction(safeTransactionData.to, safeTransactionData.value, safeTransactionData.data))
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
          operation: 0,
          safeTxGas: 0,
          baseGas: 0,
          gasPrice: 0,
          gasToken: '0x0000000000000000000000000000000000000000',
          refundReceiver: '0x0000000000000000000000000000000000000000',
          // maybe nonce will be converted to bigint in client
          nonce: safeTxDataTyped.nonce ? safeTxDataTyped.nonce : await getUserNonce(walletAddress)
        }
      }

      console.log('toBeSignedTransaction', toBeSignedTransaction)

      return reply.code(200).send(toBeSignedTransaction)
    } catch (error) {
      console.error('An error occurred:', error)
      return reply.code(500).send({ message: error })
    }
  })

  server.post('/estimate-safe-tx-gas', async (request, reply) => {
    try {
      const {
        walletAddress,
        safeTransactionData
      } = request.body

      const safeTxGas = await estimateSafeTxGas({
        walletAddress: walletAddress,
        safeTransactionData: safeTransactionData,
        provider: provider
      })

      // wallet._prepareTransaction('0x7ee6eb942378f7082fc58ab09dafd5f7c33a98bd', safeTransactionData.value, safeTransactionData.data)
      return reply.code(200).send(safeTxGas)
    } catch (error) {
      console.error('An error occurred:', error)
      return reply.code(500).send({ message: error })
    }
  })


}