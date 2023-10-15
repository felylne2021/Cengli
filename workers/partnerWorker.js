import cron from 'node-cron';

import { prismaClient } from "../utils/prisma.js"
import { getContractByChain } from "../utils/web3/assetContracts.js"
import { checkBalance } from '../utils/web3/p2pController.js';

export const partnerWorker = async (server) => {
  // run very 1 minute
  cron.schedule('*/30 * * * * *', () => {
    fetchUSDCTokenBalance()
  });
  fetchUSDCTokenBalance()
}

// fetch partner's USDC balance on AVAX
export const fetchUSDCTokenBalance = async () => {
  const partners = await prismaClient.p2PPartner.findMany({
    select: {
      address: true,
      id: true,
    }
  })

  // TODO: Currently set to goerli, change to AVAX later
  const usdcToken = await prismaClient.token.findFirst({
    where: {
      chainId: 5,
      symbol: 'USDC',
    }
  })

  for (const partner of partners) {
    // const balance = Number(await contractByChain.checkBalance(partner.address, usdcToken.address));
    const balance = await checkBalance(usdcToken?.address, partner.address)

    // upsert partner's USDC balance on AVAX
    await prismaClient.partnerBalance.upsert({
      where: {
        tokenAddress_tokenChainId_partnerId: {
          partnerId: partner.id,
          tokenAddress: usdcToken.address,
          tokenChainId: usdcToken.chainId,
        }
      },
      create: {
        partnerId: partner.id,
        amount: balance,
        tokenAddress: usdcToken.address,
        tokenChainId: usdcToken.chainId,
      },
      update: {
        amount: balance,
      }
    }).catch(error => {
      console.error('failed to upsert partner balance', error)
    })
  }

  console.log('Partner USDC balance on AVAX updated')
}