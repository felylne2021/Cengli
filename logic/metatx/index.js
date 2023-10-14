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

  console.log("wallet address", wallet.address)

  // Call captureFlag on TestContract
  const iface = new ethers.Interface(TestContractABI);
  const contract = new ethers.Contract(TEST_CONTRACT_ADDRESS, TestContractABI, wallet);

  // encode the call to captureFlag
  const data = iface.encodeFunctionData("captureFlag");

  const gasEstimate = await contract.getFunction("captureFlag").estimateGas({
    value: ethers.parseEther("0.01")
  })
  console.log("gasEstimate", gasEstimate.toString());

  // get block timestamp + 1 day
  const deadline = (await provider.getBlock()).timestamp + 86400;

  // create metaTx payload
  const metaTxRequest = {
    from: wallet.address,
    to: TEST_CONTRACT_ADDRESS,
    value: ethers.parseEther("0.01").toString(),
    gas: gasEstimate.toString(),
    data: data,
    nonce: await wallet.provider?.getTransactionCount(wallet.address),
    deadline: deadline
  }

  // Get Forwarder Contract
  const forwarderContract = new ethers.Contract(FORWARDER_ADDRESS, ForwarderContractABI, runnerWallet);
  
  // get nonce form forwarder contract
  const nonce = await forwarderContract.nonces(wallet.address);
  metaTxRequest.nonce = parseInt(nonce);

  // get eip712domain
  const typedData = getMetaTxTypedData(metaTxRequest);
  console.log("typedData", typedData)

  const signature = await wallet.signTypedData(typedData.domain, typedData.types, typedData.message)

  metaTxRequest.signature = signature;
  console.log("metaTxRequest", JSON.stringify(metaTxRequest))

  // verify metaTxRequest
  const verifyRes = await forwarderContract.verify(metaTxRequest);
  console.log("verifyRes", verifyRes);

  // send metaTx
  const res = await forwarderContract.execute(
    metaTxRequest.from,
    metaTxRequest.to,
    metaTxRequest.value,
    metaTxRequest.gas,
    metaTxRequest.deadline,
    metaTxRequest.data,
    metaTxRequest.signature,
    {
      value: metaTxRequest.value,
    }
  )
  console.log("res", res);
};