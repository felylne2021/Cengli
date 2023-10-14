

export const CHAINS_CONFIGS = [
  {
    chainId: 5,
    chainName: 'Goerli',
    rpcUrl: 'https://goerli.infura.io/v3',
    logoURI: 'https://s2.coinmarketcap.com/static/img/coins/64x64/1027.png',
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
        logoURI: "https://s2.coinmarketcap.com/static/img/coins/64x64/3408.png",
        priceUsd: 1
      }
    ]
  },
  {
    chainId: 420,
    chainName: 'Optimism Goerli',
    rpcUrl: 'https://endpoints.omniatech.io/v1/op/goerli/public',
    logoURI: 'https://s2.coinmarketcap.com/static/img/coins/64x64/11840.png',
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
        logoURI: "https://s2.coinmarketcap.com/static/img/coins/64x64/3408.png",
        priceUsd: 1
      }
    ]
  },
  {
    chainId: 80001,
    chainName: 'Polygon Mumbai Testnet',
    rpcUrl: 'https://polygon-mumbai-bor.publicnode.com',
    logoURI: 'https://s2.coinmarketcap.com/static/img/coins/64x64/3408.png',
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
        logoURI: "https://s2.coinmarketcap.com/static/img/coins/64x64/3408.png",
        priceUsd: 1
      }
    ]
  },
  {
    chainId: 43113,
    chainName: "Avalanche Fuji Testnet",
    rpcUrl: "https://avalanche-fuji-c-chain.publicnode.com",
    blockExplorerUrls: "https://testnet.snowtrace.io",
    logoURI: "https://s2.coinmarketcap.com/static/img/coins/64x64/5805.png",
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
        logoURI: "https://s2.coinmarketcap.com/static/img/coins/64x64/3408.png",
        priceUsd: 1
      }
    ]
  }
]