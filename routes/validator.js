import { prismaClient } from "../utils/prisma.js"

export const validateAvailableChainId = async (targetChainIds, reply) => {
  const availableChainId = await prismaClient.chain.findMany({
    select: {
      chainId: true
    }
  })

  if (!targetChainIds.every(chainId => availableChainId.map(chain => chain.chainId).includes(parseInt(chainId)))) {
    return reply.code(400).send({ message: `Invalid chainId, the available chainIds are: ${availableChainId.map(chain => chain.chainId)}` });
  }

  return true;
}