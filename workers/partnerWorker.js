import cron from 'node-cron';

import { prismaClient } from "../utils/prisma.js"
import { getContractByChain } from "../utils/web3/assetContracts.js"
import { checkBalance, getEthersProvider } from '../utils/web3/p2pController.js';

export const partnerWorker = async (server) => {
  // run very 1 minute
  cron.schedule('*/30 * * * * *', () => {
    // fetchUSDCTokenBalance()
    fetchPartnerTokenBalance()
  });
  // fetchUSDCTokenBalance()
  fetchPartnerTokenBalance()
}

// fetch partner's USDC balance on AVAX
export const fetchPartnerTokenBalance = async (partnerId, chainId) => {
  const partners = await prismaClient.p2PPartner.findMany({
    select: {
      address: true,
      id: true,
      name: true,
      chainId: true,
    },
    where: {
      id: partnerId ? partnerId : undefined,
    }
  })

  // TODO: Currently set to goerli, change to AVAX later
  const targetToken = await prismaClient.token.findMany({
    where: {
      chainId: chainId ? parseInt(chainId) : undefined,
      symbol: 'CIDR',
    }
  })

  for (const token of targetToken) {
    const provider = getEthersProvider(token.chainId)

    for (const partner of partners) {
      // console.log({
      //   token: token,
      //   partner: partner,
      // })
      const balance = await checkBalance(token.address, partner.address, provider)

      // upsert partner's USDC balance on AVAX
      await prismaClient.partnerBalance.upsert({
        where: {
          tokenId_partnerId: {
            tokenId: token.id,
            partnerId: partner.id,
          }
        },
        create: {
          partnerId: partner.id,
          tokenId: token.id,
          amount: balance,
        },
        update: {
          amount: balance,
        }
      }).catch(error => {
        console.error('failed to upsert partner balance', error)
      })
    }
  }

  // console.log('Partner CIDR balance on AVAX updated')
}

export const fetchUSDCTokenBalance = async (partnerId) => {
  const partners = await prismaClient.p2PPartner.findMany({
    select: {
      address: true,
      id: true,
      name: true,
    },
    where: {
      id: partnerId ? partnerId : undefined,
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
    // console.log({
    //   partnerId: partner.id,
    //   tokenAddress: usdcToken.address,
    //   tokenChainId: usdcToken.chainId,
    //   name: partner.name
    // })
    const balance = await checkBalance(usdcToken?.address, partner.address)

    // upsert partner's USDC balance on AVAX
    await prismaClient.partnerBalance.upsert({
      where: {
        tokenId_partnerId: {
          tokenId: usdcToken.id,
          partnerId: partner.id,
        }
      },
      create: {
        partnerId: partner.id,
        tokenId: usdcToken.id,
        amount: balance,
      },
      update: {
        amount: balance,
      }
    }).catch(error => {
      console.error('failed to upsert partner balance', error)
    })
  }

  // console.log('Partner USDC balance on AVAX updated')
}