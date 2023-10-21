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

      const transaction = await prismaClient.transaction.create({
        data: {
          fromUserId: fromUserId,
          destinationUserId: destinationUserId,
          fromAddress: fromAddress,
          destinationAddress: destinationAddress,
          tokenAddress: tokenAddress,
          fromChainId: fromChainId,
          destinationChainId: destinationChainId,
          amount: amount,
          note: note,
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
      const { fromChainId, destinationChainId } = request.query;

      const fromBridgeAddress = await prismaClient.chain.findFirst({
        where: {
          chainId: parseInt(fromChainId)
        },
        select: {
          chainId: true,
          hyperlaneBridgeAddress: true
        }
      })

      const destinationBridgeAddress = await prismaClient.chain.findFirst({
        where: {
          chainId: parseInt(destinationChainId)
        },
        select: {
          chainId: true,
          hyperlaneBridgeAddress: true
        }
      })

      if (!fromBridgeAddress || !destinationBridgeAddress) {
        return reply.code(404).send({ message: 'Bridge address not found' });
      }

      return reply.code(200).send({
        fromBridgeAddress: fromBridgeAddress.hyperlaneBridgeAddress,
        destinationBridgeAddress: destinationBridgeAddress.hyperlaneBridgeAddress
      });
    } catch (error) {
      console.log('Error getting bridge address: ', error);
      return reply.code(500).send({ message: error });
    }
  })
}