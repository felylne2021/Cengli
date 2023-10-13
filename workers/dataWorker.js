import { CHAINS_CONFIGS } from "../constants/configs.js";
import { prismaClient } from '../utils/prisma.js';

export const dataWorker = async (server) => {
  const initializeTokensAndChains = async () => {
    try {
      for (const chainConfig of CHAINS_CONFIGS) {
        console.log('Initializing chain: ', chainConfig.logoURI)
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
}