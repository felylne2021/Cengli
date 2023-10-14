const CengliForwarder = artifacts.require("CengliForwarder");
const TestContract = artifacts.require("TestContract");

async function delay(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

// module.exports = async function (deployer){
//   // Deploy CengliForwarder
//   await deployer.deploy(CengliForwarder);
//   const cengliForwarder = await CengliForwarder.deployed();
//   console.log("CengliForwarder deployed to:", cengliForwarder.address);
// };

// TestContract Deploy
module.exports = async function (deployer){
  // Deploy CengliForwarder
  await deployer.deploy(TestContract, "0xf10BBBbD99f616F134e817B29465Cb671139e345");
  const testContract = await TestContract.deployed();
  console.log("TestContract deployed to:", testContract.address);
};
