import { prismaClient } from "../utils/prisma.js";
import { getContractByChain } from "../utils/web3/assetContracts.js";
import { validateAvailableChainId, validateRequiredFields } from "../utils/validator.js";
import { readFileSync } from "fs";

export const SafeFactoryABI = JSON.parse(readFileSync("utils/web3/abi/SafeFactory.json", "utf8"))

export const transferRoutes = async (server) => {
  server.post('/send', async (request, reply) => {
    try {
      const {
        fromUserId,
        destinationUserId,
        fromAddress,
        destinationAddress,
        tokenAddress,
        fromChainId,
        destinationChainId,
        amount,
        note
      } = request.body;

      if (!request.body) {
        return reply.code(400).send({ message: 'Body is undefined' });
      }

      // Validate the required body parameters
      const fields = ['fromUserId', 'destinationUserId', 'fromAddress', 'destinationAddress', 'tokenAddress', 'fromChainId', 'destinationChainId', 'amount'];
      await validateRequiredFields(request.body, fields, reply)
      await validateAvailableChainId([fromChainId, destinationChainId], reply);

      // const contractByChain = getContractByChain(parseInt(fromChainId));
      // console.log(contractByChain);
      // let msgID;
      // // process txn
      // if (fromChainId == destinationChainId){
      //   // process same chain
      //   await contractByChain.transferSameChainUSDC(destinationAddress, amount);
      //   console.log("Transaction in the same chain.");
      // }
      // else{
      //   const byte32Address = "0x000000000000000000000000" + destinationAddress.substring(2);
      //   // process cross chain
      //   msgID = await contractByChain.transferXchainUSDC(destinationChainId, byte32Address, amount);
      //   console.log("Transaction cross chain message ID.");
      // }

      const token = await prismaClient.token.findFirst({
        where: {
          address: tokenAddress.toLowerCase(),
          chainId: parseInt(fromChainId)
        }
      })

      if (!token) {
        return reply.code(404).send({ message: 'Token not found' });
      }

      const transaction = await prismaClient.transaction.create({
        data: {
          fromUserId: fromUserId,
          destinationUserId: destinationUserId,
          fromAddress: fromAddress,
          destinationAddress: destinationAddress,
          tokenAddress: tokenAddress,
          fromChainId: fromChainId,
          destinationChainId: destinationChainId,
          amount: parseFloat(amount),
          note: note,
          tokenId: token.id
        }
      })

      return reply.code(200).send(transaction);
    } catch (error) {
      console.log('Error sending transaction: ', error);
      return reply.code(500).send({ message: error });
    }
  })

  // TODO: Get Hyperlane bridge address by its fromChainId and destinationChainId. params: fromChainId, destinationChainId
  server.get('/bridge', async (request, reply) => {
    try {
      const { fromChainId, destinationChainId, tokenAddress } = request.query;

      await validateRequiredFields(request.query, ['fromChainId', 'tokenAddress', 'destinationChainId'], reply)

      const fromToken = await prismaClient.token.findFirst({
        where: {
          address: tokenAddress.toLowerCase(),
          chainId: parseInt(fromChainId)
        },
        include: {
          hyperlaneRoute: true,
          hyperlaneCCTPRoute: true,
        }
      })

      if (!fromToken) {
        return reply.code(404).send({ message: 'Token not found' });
      }

      let info = {
        route: '',
        description: '',
        fromBridgeAddress: '',
        destinationBridgeAddress: ''
      }

      // If fromToken is USDC, and fromChainId and destinationChainId is not the same, then use CCTP
      if (fromToken?.hyperlaneCCTPRoute) {
        const destinationBridgeAddress = await prismaClient.hyperlaneCCTPRoute.findFirst({
          where: {
            token: {
              symbol: fromToken.symbol
            },
            chainId: parseInt(destinationChainId)
          }
        })

        if (!destinationBridgeAddress) {
          return reply.code(404).send({ message: `CCTP Bridge address not found, from ${fromChainId} to ${destinationChainId}` });
        }

        info = {
          route: 'Hyperlane CCTP',
          route_type: 'HYPERLANE_CCTP',
          description: 'Hyperlane CCTP Description here',
          fromBridgeAddress: fromToken.hyperlaneCCTPRoute.bridgeAddress,
          destinationBridgeAddress: destinationBridgeAddress.bridgeAddress
        }
      } else {
        const destinationBridgeAddress = await prismaClient.hyperlaneWarpRoute.findFirst({
          where: {
            token: {
              symbol: fromToken.symbol
            },
            chainId: parseInt(destinationChainId)
          }
        })

        if (!destinationBridgeAddress) {
          return reply.code(404).send({ message: `Warp Bridge address not found, from ${fromChainId} to ${destinationChainId}` });
        }

        info = {
          route: 'Hyperlane Warp',
          route_type: 'HYPERLANE_WARP',
          description: 'Hyperlane Warp Description here',
          fromBridgeAddress: fromToken.hyperlaneRoute.bridgeAddress,
          destinationBridgeAddress: destinationBridgeAddress.bridgeAddress
        }
      }

      return reply.code(200).send(info);
    } catch (error) {
      console.log('Error getting bridge address: ', error);
      return reply.code(500).send({ message: error });
    }
  })

  server.get('/hyperlane-warp-route', async (request, reply) => {
    try {
      const { fromChainId, toChainId, tokenAddress } = request.query;

      await validateRequiredFields(request.query, ['fromChainId', 'tokenAddress', 'toChainId'], reply)

      const fromBridge = await prismaClient.hyperlaneWarpRoute.findFirst({
        where: {
          tokenAddress: tokenAddress.toLowerCase(),
          chainId: parseInt(fromChainId)
        },
        include: {
          token: true
        }
      })

      if (!fromBridge) {
        return reply.code(404).send({ message: 'Bridge not found, only FUJI and MUMBAI are supported, make sure you input the correct token address' });
      }

      const destination = await prismaClient.hyperlaneWarpRoute.findFirst({
        where: {
          token: {
            symbol: fromBridge.token.symbol
          },
          chainId: parseInt(toChainId)
        }
      })

      delete fromBridge.token;

      return reply.code(200).send({
        ...fromBridge,
        destinationWrappedTokenAddress: destination?.wrappedTokenAddress
      });
    } catch (error) {
      console.log('Error getting bridge address: ', error);
      return reply.code(500).send({ message: error });
    }
  })
}