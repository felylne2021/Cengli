import { prismaClient } from "../utils/prisma.js";
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

      await validateRequiredFields(request.body, ['fromUserId', 'destinationUserId', 'fromAddress', 'destinationAddress', 'tokenAddress', 'fromChainId', 'destinationChainId', 'amount', 'signer'], reply);
      await validateAvailableChainId([fromChainId, destinationChainId], reply);

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