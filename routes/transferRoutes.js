import { prismaClient } from "../utils/prisma.js";
import { getContractByChain } from "../utils/web3/assetContracts.js";
import * as cometh from "../utils/web3/comethWallet.js";
import { ComethProvider } from "@cometh/connect-sdk";
import { ethers } from "ethers";
import { validateAvailableChainId } from "./validator.js";

export const transferRoutes = async (server) => {
  server.post('/send', async (request, reply) => {
    try {
      const {
        fromUserId,
        destinationUserId,
        fromAddress,
        destinationAddress,
        tokenAddress,
        fromChainId,
        destinationChainId,
        amount,
        note,
        signer
      } = request.body;

      if (!request.body) {
        return reply.code(400).send({ message: 'Body is undefined' });
      }

      // Validate the required body parameters
      const fields = ['fromUserId', 'destinationUserId', 'fromAddress', 'destinationAddress', 'tokenAddress', 'fromChainId', 'destinationChainId', 'amount', 'signer'];
      const missingParams = fields.reduce((acc, field) => !eval(field) ? [...acc, field] : acc, []);

      if (missingParams.length) {
        return reply.code(400).send({ message: 'Missing parameters', missingParams });
      }

      await validateAvailableChainId([fromChainId, destinationChainId], reply);
      const contractByChain = getContractByChain(parseInt(fromChainId));
      const contractAddressUsed = await contractByChain.getAddress();

      // Cometh Wallet
      /*
      let webAuthnSigner = {
        "_id": "652d02fec9cbc0c6f8ff69ab",
        "projectId": "6528fa24c9cbc0c6f8ff6876",
        "chainId": "43113",
        "walletAddress": "0xF29ceaa619f5f231D96836206D903c26EF0CAe3d",
        "publicKeyId": "0x2dd098a19d263f133afc07690613df10f7b8771f1b325bddb06d33b05f4b208a",
        "publicKeyX": "0x2d989d3f3a0706dff7771b5bb0335f20",
        "publicKeyY": "0xd0a12613fc691310b81f32dd6db04b8a",
        "signerAddress": "0x08D73c73534F351e4065fB326B3978EC0b8B2a49",
        "deviceData": {
          "browser": "-",
          "os": "ios",
          "platform": "Mobile"
        }
      };
      */

    
      const connectedWallet = await cometh.instance.connect(fromAddress.toString());
      const instanceProvider = new ComethProvider(cometh.instance);
      
      const comethConnectedContract = new ethers.Contract(
        contractAddressUsed,
        contractByChain.interface,
        instanceProvider.getSigner()
      );

      console.log("Cometh Wallet: ", comethConnectedContract);

      // process txn
      if (fromChainId == destinationChainId){
        // process same chain
        await comethConnectedContract.transferSameChainUSDC(destinationAddress, amount);
        console.log("Transaction in the same chain.");
      }
      else{
        const byte32Address = "0x000000000000000000000000" + destinationAddress.substring(2);
        // process cross chain
        await comethConnectedContract.transferXchainUSDC(destinationChainId, byte32Address, amount);
        console.log("Transaction cross chain message ID.");
      }

      const transaction = await prismaClient.transaction.create({
        data: {
          fromUserId: fromUserId,
          destinationUserId: destinationUserId,
          fromAddress: fromAddress,
          destinationAddress: destinationAddress,
          tokenAddress: tokenAddress,
          fromChainId: fromChainId,
          destinationChainId: destinationChainId,
          amount: amount,
          note: note,
        }
      })

      return reply.code(200).send(transaction);
    } catch (error) {
      console.log('Error sending transaction: ', error);
      return reply.code(500).send({ message: error });
    }
  })
}