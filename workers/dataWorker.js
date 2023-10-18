import axios from "axios";
import cron from 'node-cron';

import { CHAINS_CONFIGS } from "../constants/configs.js";
import { COMETH_API_BASE_URL } from "../routes/comethRoutes.js";
import { prismaClient } from '../utils/prisma.js';

export const dataWorker = async (server) => {
  const initializeTokensAndChains = async () => {
    try {
      for (const chainConfig of CHAINS_CONFIGS) {
        await prismaClient.chain.upsert({
          where: { chainId: chainConfig.chainId },
          update: {
            chainName: chainConfig.chainName,
            rpcUrl: chainConfig.rpcUrl,
            nativeCurrency: chainConfig.nativeCurrency,
            blockExplorer: chainConfig.blockExplorerUrls,
            logoURI: chainConfig.logoURI
          },
          create: {
            chainId: chainConfig.chainId,
            chainName: chainConfig.chainName,
            rpcUrl: chainConfig.rpcUrl,
            nativeCurrency: chainConfig.nativeCurrency,
            blockExplorer: chainConfig.blockExplorerUrls,
            logoURI: chainConfig.logoURI
          },
        });

        for (const token of chainConfig.tokens) {
          await prismaClient.token.upsert({
            where: {
              address_chainId: {
                address: token.address,
                chainId: chainConfig.chainId,
              },
            },
            update: {
              name: token.name,
              symbol: token.symbol,
              decimals: token.decimals,
              logoURI: token.logoURI,
              priceUsd: token.priceUsd,
            },
            create: {
              address: token.address,
              chainId: chainConfig.chainId,
              name: token.name,
              symbol: token.symbol,
              decimals: token.decimals,
              logoURI: token.logoURI,
              priceUsd: token.priceUsd,
            },
          });
        }
      }
    } catch (error) {
      console.log('Error initializing tokens: ', error);
    }

    console.log('Tokens & Chains initialized');
  };

  // Comment this line if you don't want to initialize tokens and chains
  initializeTokensAndChains();


  const comethSponsoredAddress = async () => {
    const res = await axios({
      method: 'GET',
      url: `${COMETH_API_BASE_URL}/sponsored-address`,
      headers: {
        apiKey: process.env.COMETH_API_KEY
      }
    })

    for (const target of res.data.sponsoredAddresses) {
      await prismaClient.comethSponsoredAddress.upsert({
        where: {
          chainId_targetAddress: {
            chainId: target.chainId,
            targetAddress: target.targetAddress
          }
        },
        create: {
          chainId: target.chainId,
          targetAddress: target.targetAddress,
        },
        update: {
          chainId: target.chainId,
          targetAddress: target.targetAddress,
        }
      })
    }

    console.log('Cometh Sponsored Address initialized');
  }

  // run every 30 seconds
  cron.schedule('*/30 * * * * *', () => {
    comethSponsoredAddress()
  });
  // comethSponsoredAddress()
}