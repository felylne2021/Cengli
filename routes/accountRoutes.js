import { ACCOUNT_ASSETS_RESPONSE } from "../constants/dummies.js";
import { prismaClient } from "../utils/prisma.js";

import { ethers } from "ethers";
import dotenv from 'dotenv';
dotenv.config();

const PRIVATE_KEY = process.env.PRIVATE_KEY ?? "";

const GOERLI_API_KEY = process.env.GOERLI_API_KEY ?? "";
const MUMBAI_API_KEY = process.env.MUMBAI_API_KEY ?? "";
const OPTIMISM_API_KEY=process.env.OPTIMISM_API_KEY ?? "";
const ARBITRUM_API_KEY=process.env.ARBITRUM_API_KEY ?? "";
const AVAX_API_KEY=process.env.AVAX_API_KEY ?? "";

import fs from 'fs';
var jsonFile = './artifacts/contracts/USDCTransferCengli.sol/USDCTransferCengli.json';
var parsed= JSON.parse(fs.readFileSync(jsonFile));
var abi = parsed.abi;

const goerliProvider = new ethers.JsonRpcProvider(GOERLI_API_KEY);
const goerliSigner = new ethers.Wallet(PRIVATE_KEY, goerliProvider);
const goerliContract = new ethers.Contract("0xA1bD683B06b9B7F633cc7A96A9E5f0AE0662C6C4", abi, goerliSigner);

// const polygonProvider = new ethers.JsonRpcApiProvider(MUMBAI_API_KEY);
// const polygonSigner = new ethers.Wallet(PRIVATE_KEY, polygonProvider);
// const polygonContract = new ethers.Contract("0xA1bD683B06b9B7F633cc7A96A9E5f0AE0662C6C4", abi, polygonSigner);

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

      let contractByChain;
      // set contract to call by chain
        try{
          switch(parseInt(chainId)){
              case ChainIds.Goerli:
                contractByChain = goerliContract;
                break;
              // case ChainIds.Polygon:
              //   contractByChain = polygonContract;
              //   break;
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
          console.log(contractByChain);
          try {
            const result = await retrieveBalances(tokensToBeRetrieved, address, contractByChain)
            // Access the data from the 'result' object
            const totalBalanceUsd = result.totalBalanceUsd;
            const tokens = result.tokens;
        
            console.log('Total Balance (USD):', totalBalanceUsd);
            console.log('Tokens:', tokens);
        
            const jsonStructure = {
              totalBalanceUsd: totalBalanceUsd,
              tokens: tokens,
            };
  
            return reply.code(200).send(jsonStructure);

          } catch (error) {
            console.error('An error occurred:', error);
            return reply.code(500).send({ message: error });
          }
          
        } catch (error) {
          console.log('Error getting assets: ', error);
          return reply.code(500).send({ message: error });
        }
    }
    catch(error){
      console.log('Error getting assets: ', error);
      return reply.code(500).send({ message: error });
    }
  }),
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

async function retrieveBalances(tokensToBeRetrieved, address, contractByChain) {
  let totalBalanceUsd = 0;
  // Initialize an array to store the token objects
  const tokens = [];

  for (const token of tokensToBeRetrieved) {
    let balance = Number(await contractByChain.checkBalance(address, token.address));
    totalBalanceUsd += balance;

    const tokenObject = {
      balance: balance,
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
    };

    tokens.push(tokenObject);
  }

  return { totalBalanceUsd, tokens };
}