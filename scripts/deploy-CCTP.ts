import {ethers} from "hardhat";

async function main() {
    var factory = await ethers.getContractFactory("USDCTransferCengli");
    console.log("F");
    var USDCTransferCengli = await factory.deploy(
        "0xe05606174bac4A6364B31bd0eCA4bf4dD368f8C6", 
        "0x8F2Ec21F10dDD8d581f8957aB1F1D484F4875977", 
        "0xF90cB82a76492614D07B82a7658917f3aC811Ac1");

    console.log("Contract Address:", await USDCTransferCengli.getAddress());
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })