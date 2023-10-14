const ethers = require('ethers');
const { Utils } = require("alchemy-sdk");

const { getMetaTxTypedData } = require("./cengliForwarderSigner");

const TEST_CONTRACT_ADDRESS = "0x6c5748c78D295739d9F26805783f5D1003AdFcD8"
const FORWARDER_ADDRESS = "0xf10BBBbD99f616F134e817B29465Cb671139e345"

const TestContractABI = require("../../build/contracts/TestContract.json").abi;
const ForwarderContractABI = require("../../build/contracts/CengliForwarder.json").abi;

exports.metaTxTest = async function () {
  const provider = new ethers.JsonRpcProvider("https://goerli.infura.io/v3/0be86a45a4c3431398571a7c81165708");

  // declare the wallet from private key
  const privateKey = process.env.TEST_PRIVATE_KEY;
  const wallet = new ethers.Wallet(privateKey, provider);

  const runnerPrivateKey = process.env.PRIVATE_KEY;
  const runnerWallet = new ethers.Wallet(runnerPrivateKey, provider);

  console.log({
    address: wallet.address,
    runnerAddress: runnerWallet.address
  })

  // Call captureFlag on TestContract
  const contract = new ethers.Contract(TEST_CONTRACT_ADDRESS, TestContractABI, wallet);

  const gasEstimate = await contract.getFunction("captureFlag").estimateGas({
    value: ethers.parseEther("0.01")
  })

  const fee = await wallet.provider?.getFeeData()

  console.log("gasEstimate", gasEstimate.toString());
  const captureFlagTransaction = await contract.captureFlag.populateTransaction({
    from: wallet.address,
    value: ethers.parseEther("0.01"),
    nonce: await wallet.provider?.getTransactionCount(wallet.address),
    gasLimit: gasEstimate,
    gasPrice: fee?.gasPrice,
    chainId: 5
  })
  console.log("captureFlagTransaction", captureFlagTransaction);

  const signedTx = await wallet.signTransaction(captureFlagTransaction);
  console.log("signedTx", signedTx);
  
  const tx = await runnerWallet.provider?.broadcastTransaction(signedTx);
  console.log("tx", tx);
};