import { prismaClient } from "../utils/prisma.js"

export const infoRoutes = async (server) => {
  server.get('/chains', async (request, reply) => {
    const chains = await prismaClient.chain.findMany({
      orderBy: {
        chainId: 'desc'
      }
    })

    return reply.code(200).send(chains)
  })
}