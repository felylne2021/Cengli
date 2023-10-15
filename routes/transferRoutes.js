import { prismaClient } from "../utils/prisma.js";
import { getContractByChain } from "../utils/web3/assetContracts.js";
import { validateAvailableChainId, validateRequiredFields } from "../utils/validator.js";

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
        note,
        signer
      } = request.body;

      if (!request.body) {
        return reply.code(400).send({ message: 'Body is undefined' });
      }

      // Validate the required body parameters
      const fields = ['fromUserId', 'destinationUserId', 'fromAddress', 'destinationAddress', 'tokenAddress', 'fromChainId', 'destinationChainId', 'amount', 'signer'];
      await validateRequiredFields(request.body, fields, reply)
      await validateAvailableChainId([fromChainId, destinationChainId], reply);

      const contractByChain = getContractByChain(parseInt(fromChainId));
      console.log(contractByChain);
      let msgID;
      // process txn
      if (fromChainId == destinationChainId){
        // process same chain
        await contractByChain.transferSameChainUSDC(destinationAddress, amount);
        console.log("Transaction in the same chain.");
      }
      else{
        const byte32Address = "0x000000000000000000000000" + destinationAddress.substring(2);
        // process cross chain
        msgID = await contractByChain.transferXchainUSDC(destinationChainId, byte32Address, amount);
        console.log("Transaction cross chain message ID.");
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
}