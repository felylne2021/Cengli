

export const CHAINS_CONFIGS = [
  {
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
        priceUsd: 1
      }
    ]
  },
  {
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
        priceUsd: 1
      }
    ]
  },
  {
    chainId: 80001,
    chainName: 'Polygon Mumbai Testnet',
    rpcUrl: 'https://polygon-mumbai-bor.publicnode.com',
    logoURI: 'https://s2.coinmarketcap.com/static/img/coins/128x128/3408.png',
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
      }
    ]
  },
  {
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
        priceUsd: 1
      },
      {
        address: "0x7ee6eb942378f7082fc58ab09dafd5f7c33a98bd",
        name: "Fuji Testing Token",
        symbol: "FTT",
        decimals: 18,
        logoURI: "https://media.licdn.com/dms/image/D5603AQEmOw2RKECI_g/profile-displayphoto-shrink_200_200/0/1640780311757?e=1703116800&v=beta&t=cth5S__Qnkca8bvuVg2bLPURZmNgKkEh2yPErd3EofY",
        priceUsd: 1
      }
    ]
  },
  {
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
        priceUsd: 1
      }
    ]
  }
]