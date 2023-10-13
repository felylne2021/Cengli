const ethers = require('ethers');
require('dotenv').config();

const PRIVATE_KEY = process.env.PRIVATE_KEY ?? "";

const GOERLI_API_KEY = process.env.GOERLI_API_KEY ?? "";
const OPTIMISM_API_KEY=process.env.OPTIMISM_API_KEY ?? "";
const ARBITRUM_API_KEY=process.env.ARBITRUM_API_KEY ?? "";
const AVAX_API_KEY=process.env.AVAX_API_KEY ?? "";

const {abi} = require("../artifacts/contracts/USDCTransferCengli.sol/USDCTransferCengli.json");

const goerliProvider = new ethers.JsonRpcProvider(GOERLI_API_KEY);
const goerliSigner = new ethers.Wallet(PRIVATE_KEY, goerliProvider);
const goerliContract = new ethers.Contract("0xA1bD683B06b9B7F633cc7A96A9E5f0AE0662C6C4", abi, goerliSigner);

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
    Avax: 43113,
    Optimism: 420,
    Arbitrum: 421613
}
const express = require('express');
const app = express();

app.get('/account/assets/:address/:chainId/:token', async function(req, res) { 
    var address = req.params.address;
    var chainId = req.params.chainId;
    var token = req.params.token;
    let balance;
    try{
        switch(parseInt(chainId)){
            case ChainIds.Goerli:
                console.log("Bal: ", chainId == ChainIds.Goerli);
                balance = (await goerliContract.checkBalance(address, token)).toString();
                break;
            case ChainIds.Avax:
                balance = (await goerliContract.checkBalance(address, token)).toString();
                break;
            case ChainIds.Optimism:
                balance = (await goerliContract.checkBalance(address, token)).toString();
                break;
            case ChainIds.Arbitrum:
                balance = (await goerliContract.checkBalance(address, token)).toString();
                break;
        }
        
        res.json( 
            {
                totalBalanceUsd: balance,
                tokens: [
                  {
                    balance: balance,
                    balanceUSd: balance,
                    token: {
                      address: `${token}`,
                      chainId: 420,
                      name: "USD Coin",
                      symbol: "USDC",
                      decimals: 6,
                      logoURI: 'https://s2.coinmarketcap.com/static/img/coins/64x64/3408.png',
                      priceUsd: 1
                    }
                  }
                ]
            }
        ); 

    }
    catch(error){
        console.log("Exception: ", error);
        res.status(500).send(error.message);
    }
    
}); 

app.listen(3000, function(req, res) { 
    console.log("Server is running at port 3000");
});