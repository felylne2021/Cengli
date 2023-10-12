import { prismaClient } from "../utils/prisma.js";

export const transferRoutes = async (server) => {
  server.post('/send', async (request, reply) => {
    try {
      const {
        fromUserId,
        destinationUserId,
        fromAddress,
        destinationAddress,
        tokenAddress,
        chainId,
        amount,
        note,
        signer
      } = request.body;

      if (!request.body) {
        return reply.code(400).send({ message: 'Body is undefined' });
      }

      // Validate the required body parameters
      const fields = ['fromUserId', 'destinationUserId', 'fromAddress', 'destinationAddress', 'tokenAddress', 'chainId', 'amount', 'signer'];
      const missingParams = fields.reduce((acc, field) => !eval(field) ? [...acc, field] : acc, []);

      if (missingParams.length) {
        return reply.code(400).send({ message: 'Missing parameters', missingParams });
      }

      const transaction = await prismaClient.transaction.create({
        data: {
          fromUserId: fromUserId,
          destinationUserId: destinationUserId,
          fromAddress: fromAddress,
          destinationAddress: destinationAddress,
          tokenAddress: tokenAddress,
          chainId: chainId,
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