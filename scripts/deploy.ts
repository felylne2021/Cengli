import {ethers} from "hardhat";

async function main() {
    var factory = await ethers.getContractFactory("USDCTransferCengli");
    var USDCTransferCengli = await factory.deploy(
      "0x07865c6e87b9f70255377e024ace6630c1eaa37f", 
      "0x001C83d5364C3360a27D0a72833C70203a864893", 
      "0xF90cB82a76492614D07B82a7658917f3aC811Ac1");

    console.log("Contract Address:", await USDCTransferCengli.getAddress());
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })