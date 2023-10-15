// disable linter
/* eslint-disable */

const CengliP2PEscrow = artifacts.require("CengliP2PEscrow");
const MockERC20 = artifacts.require("MockERC20");

// module.exports = async function (deployer){
//   // Deploy CengliForwarder
//   await deployer.deploy(CengliP2PEscrow, "0xF709205c39199a4D26636a02ea15E344352377AE");
//   const escrowContract = await CengliP2PEscrow.deployed();
//   console.log("TestContract deployed to:", escrowContract.address);
// };


module.exports = async function (deployer){
  await deployer.deploy(MockERC20);
}