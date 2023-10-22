

export const CHAINS_CONFIGS = [
  {
    index: 1,
    chainId: 43113,
    chainName: "Avalanche Fuji Testnet",
    rpcUrl: "https://avalanche-fuji-c-chain.publicnode.com",
    blockExplorerUrls: "https://testnet.snowtrace.io",
    logoURI: "https://s2.coinmarketcap.com/static/img/coins/128x128/5805.png",
    nativeCurrency: {
      name: "Avalanche",
      symbol: "AVAX",
      decimals: 18
    },
    tokens: [
      {
        address: "0x5425890298aed601595a70ab815c96711a31bc65",
        name: "USD Coin",
        symbol: "USDC",
        decimals: 6,
        logoURI: "https://s2.coinmarketcap.com/static/img/coins/128x128/3408.png",
        priceUsd: 1,
        hyperlaneCCTPRoute: {
          bridgeAddress: '0xfFE648692689bD72Ba223F3feC1D16a0d9e7FAdB'
        }
      },
      {
        address: '0x430d8B2Cb511DD47AD76f3bC8f9A035645F258a3',
        name: 'CIDR',
        symbol: 'CIDR',
        decimals: 18,
        logoURI: "https://i.ibb.co/PGC7hK3/CIDR-logo-1.png",
        priceUsd: 1,
        hyperlaneWarpRoute: {
          bridgeAddress: '0xC39f664Aa28293781C3C2907C172C50cA0596a98',
          wrappedTokenAddress: '0xF4897D343B80F555535328FEFAb378Ca598721C1',
          autoswapAddress: '0x232DDeEC9443845D7De95a3380984A0601436A5d'
        }
      }
    ],
    hyperlaneBridgeAddress: '0x89e2139c21254d799595051E0F3F1F5bA34Ac2c2',
  },
  {
    index: 2,
    chainId: 80001,
    chainName: 'Polygon Mumbai Testnet',
    rpcUrl: 'https://polygon-mumbai-bor.publicnode.com',
    logoURI: 'https://s2.coinmarketcap.com/static/img/coins/64x64/3890.png',
    nativeCurrency: {
      name: 'Matic',
      symbol: 'MATIC',
      decimals: 18
    },
    blockExplorerUrls: 'https://mumbai.polygonscan.com',
    tokens: [
      {
        address: "0x9999f7fea5938fd3b1e26a12c3f2fb024e194f97",
        name: "USD Coin",
        symbol: "USDC",
        decimals: 6,
        logoURI: "https://s2.coinmarketcap.com/static/img/coins/128x128/3408.png",
        priceUsd: 1
      },
      {
        address: '0xFf93Eba6599163cAA2F88b87aA31cD766219FB0b',
        name: 'CIDR',
        symbol: 'CIDR',
        decimals: 18,
        logoURI: "https://i.ibb.co/PGC7hK3/CIDR-logo-1.png",
        priceUsd: 1,
        hyperlaneWarpRoute: {
          bridgeAddress: '0xf0b28E28aE68cB563758Fee6062b01250a6916ef',
          wrappedTokenAddress: '0x02a441b2a9Ddeb3f52855c12d1035aa859F479E7',
          autoswapAddress: '0x46e5Fa54bEe2fBd132f386abA4d0817dA9517FA4'
        }
      }
    ],
    hyperlaneBridgeAddress: '0x69E0F399c8A6A767CdAFc109ae7692edDbdfb256',
  },
  {
    index: 3,
    chainId: 5,
    chainName: 'Goerli',
    rpcUrl: 'https://goerli.infura.io/v3',
    logoURI: 'https://s2.coinmarketcap.com/static/img/coins/128x128/1027.png',
    nativeCurrency: {
      name: 'Goerli Ether',
      symbol: 'GTH',
      decimals: 18
    },
    blockExplorerUrls: 'https://goerli.etherscan.io',
    tokens: [
      {
        address: "0x07865c6e87b9f70255377e024ace6630c1eaa37f",
        name: "USD Coin",
        symbol: "USDC",
        decimals: 6,
        logoURI: "https://s2.coinmarketcap.com/static/img/coins/128x128/3408.png",
        priceUsd: 1,
        hyperlaneCCTPRoute: {
          bridgeAddress: '0xa0d2cAa1699bC7193a0eAA485160981ECE90f25F'
        }
      }
    ]
  },
  {
    index: 4,
    chainId: 420,
    chainName: 'Optimism Goerli',
    rpcUrl: 'https://endpoints.omniatech.io/v1/op/goerli/public',
    logoURI: 'https://s2.coinmarketcap.com/static/img/coins/128x128/11840.png',
    nativeCurrency: {
      name: 'Goerli Ether',
      symbol: 'GTH',
      decimals: 18
    },
    blockExplorerUrls: 'https://goerli-optimism.etherscan.io',
    tokens: [
      {
        address: "0xe05606174bac4A6364B31bd0eCA4bf4dD368f8C6",
        name: "USD Coin",
        symbol: "USDC",
        decimals: 6,
        logoURI: "https://s2.coinmarketcap.com/static/img/coins/128x128/3408.png",
        priceUsd: 1,
        hyperlaneCCTPRoute: {
          bridgeAddress: '0x919eaC55E76ea226825e19E5D36ED6B0D65B3DC1'
        }
      }
    ]
  },

  {
    index: 5,
    chainId: 421613,
    chainName: "Arbitrum Testnet Goerli",
    rpcUrl: "https://arb-goerli.g.alchemy.com/v2/demo",
    blockExplorerUrls: "https://goerli.arbiscan.io",
    logoURI: "https://s2.coinmarketcap.com/static/img/coins/128x128/11841.png",
    nativeCurrency: {
      name: "Arbitrum Goerli",
      symbol: "AGOR",
      decimals: 18
    },
    tokens: [
      {
        address: "0xfd064A18f3BF249cf1f87FC203E90D8f650f2d63",
        name: "USD Coin",
        symbol: "USDC",
        decimals: 6,
        logoURI: "https://s2.coinmarketcap.com/static/img/coins/128x128/3408.png",
        priceUsd: 1,
        hyperlaneCCTPRoute: {
          bridgeAddress: "0x919eaC55E76ea226825e19E5D36ED6B0D65B3DC1"
        }
      }
    ]
  }
]