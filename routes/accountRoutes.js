import { ACCOUNT_ASSETS_RESPONSE } from "../constants/dummies.js";
import { prismaClient } from "../utils/prisma.js";

const ethers = require('ethers');
require('dotenv').config();

const PRIVATE_KEY = process.env.PRIVATE_KEY ?? "";

const GOERLI_API_KEY = process.env.GOERLI_API_KEY ?? "";
const MUMBAI_API_KEY = process.env.MUMBAI_API_KEY ?? "";
const OPTIMISM_API_KEY=process.env.OPTIMISM_API_KEY ?? "";
const ARBITRUM_API_KEY=process.env.ARBITRUM_API_KEY ?? "";
const AVAX_API_KEY=process.env.AVAX_API_KEY ?? "";

const {abi} = require("../artifacts/contracts/USDCTransferCengli.sol/USDCTransferCengli.json");

const goerliProvider = new ethers.JsonRpcProvider(GOERLI_API_KEY);
const goerliSigner = new ethers.Wallet(PRIVATE_KEY, goerliProvider);
const goerliContract = new ethers.Contract("0xA1bD683B06b9B7F633cc7A96A9E5f0AE0662C6C4", abi, goerliSigner);

const polygonProvider = new ethers.JsonRpcApiProvider(MUMBAI_API_KEY);
const polygonSigner = new ethers.Wallet(PRIVATE_KEY, polygonProvider);
const polygonContract = new ethers.Contract("0xA1bD683B06b9B7F633cc7A96A9E5f0AE0662C6C4", abi, polygonSigner);

const optimismProvider = new ethers.JsonRpcProvider(OPTIMISM_API_KEY);
const optimismSigner = new ethers.Wallet(PRIVATE_KEY, optimismProvider);
const optimismContract = new ethers.Contract("0xA1bD683B06b9B7F633cc7A96A9E5f0AE0662C6C4", abi, optimismSigner);

const arbitrumProvider = new ethers.JsonRpcProvider(ARBITRUM_API_KEY);
const arbitrumSigner = new ethers.Wallet(PRIVATE_KEY, arbitrumProvider);
const arbitrumContract = new ethers.Contract("0xA1bD683B06b9B7F633cc7A96A9E5f0AE0662C6C4", abi, arbitrumSigner);

const avaxProvider = new ethers.JsonRpcProvider(AVAX_API_KEY);
const avaxSigner = new ethers.Wallet(PRIVATE_KEY, avaxProvider);
const avaxContract = new ethers.Contract("0xA1bD683B06b9B7F633cc7A96A9E5f0AE0662C6C4", abi, avaxSigner);

const ChainIds = {
  Goerli: 5,
  Polygon: 80001,
  Avax: 43113,
  Optimism: 420,
  Arbitrum: 421613
}

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

      // set contract to call by chain

  let contractByChain;
    try{
        switch(parseInt(chainId)){
            case ChainIds.Goerli:
              contractByChain = goerliContract;
              break;
            case ChainIds.Polygon:
              contractByChain = polygonContract;
              break;
            case ChainIds.Avax:
              contractByChain = avaxContract;
              break;
            case ChainIds.Optimism:
              contractByChain = optimismContract;
              break;
            case ChainIds.Arbitrum:
              contractByChain = arbitrumContract;
              break;
        }

      // get balance for each token
      let total = 0;
      tokensToBeRetrieved.forEach(token => {
        let balance = contractByChain.CheckBalance(address, token);
        total += balance;
        
      });
      

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