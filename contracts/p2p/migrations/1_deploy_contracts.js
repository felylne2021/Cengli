// disable linter
/* eslint-disable */

const CengliP2PEscrow = artifacts.require("CengliP2PEscrow");

// TestContract Deploy
module.exports = async function (deployer){
  // Deploy CengliForwarder
  await deployer.deploy(CengliP2PEscrow, "0x278A2d5B5C8696882d1D2002cE107efc74704ECf");
  const escrowContract = await CengliP2PEscrow.deployed();
  console.log("TestContract deployed to:", escrowContract.address);
};
