import { prismaClient } from "./prisma.js"

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

export const validateRequiredFields = async (body, fields, reply) => {
  if (!Array.isArray(fields) || fields.length === 0) {
    return reply.code(400).send({ message: 'Fields array is empty or undefined' });
  }

  if (!body || Object.keys(body).length === 0) {
    return reply.code(400).send({ message: 'Request body is empty or undefined' });
  }

  const missingParams = fields.reduce((acc, field) => !body[field] ? [...acc, field] : acc, []);

  if (missingParams.length > 0) {
    return reply.code(400).send({ message: `Missing parameters: ${missingParams.join(', ')}` });
  }

  return true;
};
