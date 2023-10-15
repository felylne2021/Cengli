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
const CengliContract = new ethers.Contract("0x896828EE13f871764F29a46A8857627Db3DF0e13", abi, signer)

describe("Cengli", function () {
  it("withdraw", async function(){

    // try{
    //   const trf = await CengliContract.connect(signer).withdraw();
    //   console.log("Transaction: ", await trf.getTransaction());
    // }
    // catch(error){
    //   console.log("Error: ", error);
    // }

    try{
      const trf = await CengliContract.transferXchainUSDC(43113, "0x00000000000000000000000024C4B9DeF461F9B7DfC1f72D09662C8F0E2825d3", 25);
      console.log("Transaction: ", await trf.getTransaction());
    }
    catch(error){
      console.log("Error: ", error);
    }
  })

  
});
