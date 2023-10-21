// disable linter
/* eslint-disable */

const CengliP2PEscrow = artifacts.require("CengliP2PEscrow");

module.exports = async function (deployer){
  // Deploy CengliForwarder
  // console.log(CengliP2PEscrow)

  await deployer.deploy(CengliP2PEscrow, "0xF709205c39199a4D26636a02ea15E344352377AE");
  const escrowContract = await CengliP2PEscrow.deployed();
  console.log("TestContract deployed to:", escrowContract.address);
};


// module.exports = async function (deployer){
//   await deployer.deploy(MockERC20);
// }