

export const CHAINS_CONFIGS = [
  {
    chainId: 5,
    chainName: 'Goerli',
    rpcUrl: 'https://goerli.infura.io/v3',
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
]