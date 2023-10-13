import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect, assert } from "chai";
const { ethers, JsonRpcProvider } = require('ethers');
import { USDCTransferCengli } from "../typechain-types/contracts/USDCTransferCengli.sol/USDCTransferCengli";

import env from "dotenv";
env.config();

const GOERLI_API_KEY = process.env.GOERLI_API_KEY ?? "";
const PRIVATE_KEY = process.env.PRIVATE_KEY ?? "";

const provider = new ethers.JsonRpcProvider(GOERLI_API_KEY);
const signer = new ethers.Wallet(PRIVATE_KEY, provider);

const {abi} = require("../artifacts/contracts/USDCTransferCengli.sol/USDCTransferCengli.json");
const CengliContract = new ethers.Contract("0xA1bD683B06b9B7F633cc7A96A9E5f0AE0662C6C4", abi, signer)

describe("Cengli", function () {
  it("transfer USDC", async function(){
    console.log("Contract address: ", await CengliContract.getAddress());
    console.log("Gas Amt: ", await CengliContract.getGasAmount());

    try{
      const trf = await CengliContract.withdraw();
      console.log("Transaction: ", await trf.getTransaction());
    }
    catch(error){
      console.log("Error: ", error);
    }

    // try{
    //   const trf = await CengliContract.transferXchainUSDC(420, "0x00000000000000000000000024C4B9DeF461F9B7DfC1f72D09662C8F0E2825d3", 25);
    //   console.log("Transaction: ", await trf.getTransaction());
    // }
    // catch(error){
    //   console.log("Error: ", error);
    // }
  })

  
});
