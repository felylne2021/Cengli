import {ethers} from "hardhat";

async function main() {
    var factory = await ethers.getContractFactory("HypERC20TransferCengli");
    console.log("F");
    var contract = await factory.deploy(
        "0xE7e5abbe668Fc7f9238eEE2a64cc16d4c6353154", 
        "0xE7e5abbe668Fc7f9238eEE2a64cc16d4c6353154");

    console.log("Contract Address:", await contract.getAddress());
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })