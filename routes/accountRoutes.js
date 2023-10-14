import { prismaClient } from "../utils/prisma.js";
import { getContractByChain } from "../utils/web3/assetContracts.js";

export const accountRoutes = async (server) => {
  server.get('/assets', async (request, reply) => {
    try {
      const { address, chainId } = request.query;

      if (!address || !chainId) {
        return reply.code(400).send({ message: 'Missing address or chainId' });
      }

      const availableChainId = await prismaClient.chain.findMany({
        select: {
          chainId: true
        }
      })

      if (!availableChainId.map(chain => chain.chainId).includes(parseInt(chainId))) {
        return reply.code(400).send({ message: `Invalid chainId, the available chainIds are: ${availableChainId.map(chain => chain.chainId)}` });
      }

      const tokensToBeRetrieved = await prismaClient.token.findMany({
        orderBy: { address: 'asc' },
        where: { chainId: parseInt(chainId) }
      });

      const contractByChain = getContractByChain(parseInt(chainId));

      const result = await retrieveBalances(tokensToBeRetrieved, address, contractByChain);
      const { totalBalanceUsd, tokens } = result;

      console.log('Total Balance (USD):', totalBalanceUsd);
      console.log('Tokens:', tokens);

      return reply.code(200).send({
        totalBalanceUsd,
        tokens,
      });

    } catch (error) {
      console.error('An error occurred:', error);
      return reply.code(500).send({ message: error });
    }
  });

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

const retrieveBalances = async (tokensToBeRetrieved, address, contractByChain) => {
  let totalBalanceUsd = 0;
  const tokens = [];

  for (const token of tokensToBeRetrieved) {
    let balance = Number(await contractByChain.checkBalance(address, token.address));
    totalBalanceUsd += balance;

    tokens.push({
      balance,
      balanceUSd: balance * token.priceUsd,
      token: {
        address: token.address,
        chainId: token.chainId,
        name: token.name,
        symbol: token.symbol,
        decimals: token.decimals,
        logoURI: token.logoURI,
        priceUsd: token.priceUsd,
      },
    });
  }

  return { totalBalanceUsd, tokens };
};