import { ACCOUNT_ASSETS_RESPONSE } from "../constants/dummies.js";
import { prismaClient } from "../utils/prisma.js";

export const accountRoutes = async (server) => {
  server.get('/assets', async (request, reply) => {
    try {
      const { address, chainId } = request.query;
      // Address of the user, chainId of the network

      if (!address || !chainId) {
        return reply.code(400).send({ message: 'Missing address or chainId' });
      }

      const tokensToBeRetrieved = await prismaClient.token.findMany({
        orderBy: {
          address: 'asc'
        },
        where: {
          chainId: parseInt(chainId),
        }
      })
      console.log(tokensToBeRetrieved)

      // TODO: Call the assets from here

      return reply.code(200).send(ACCOUNT_ASSETS_RESPONSE);
    } catch (error) {
      console.log('Error getting assets: ', error);
      return reply.code(500).send({ message: error });
    }
  })

  server.get('/transactions', async (request, reply) => {
    try {
      const { userId } = request.query;

      if (!userId) {
        return reply.code(400).send({ message: 'Missing userId' });
      }

      const transactions = await prismaClient.transaction.findMany({
        where: {
          OR: [
            {
              fromUserId: userId,
            },
            {
              destinationUserId: userId,
            }
          ]
        },
        orderBy: {
          createdAt: 'desc'
        }
      })

      return reply.code(200).send(transactions);
    } catch (error) {
      console.log('Error getting transactions: ', error);
      return reply.code(500).send({ message: error });
    }
  })
}