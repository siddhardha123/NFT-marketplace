
import {ethers} from "hardhat"
import hre from "hardhat"
import fs from "fs"

async function main() {
  const [deployer] = await ethers.getSigners();
  const balance = await deployer.getBalance();
  const Marketplace = await hre.ethers.getContractFactory("marketplace");
  const marketplace = await Marketplace.deploy();

  await marketplace.deployed();

  const abiParse = JSON.parse((marketplace.interface as any).format('json'));
  const data = {
    address: marketplace.address,
    abi: abiParse
  }

  //This writes the ABI and address to the mktplace.json
  fs.writeFileSync('./Marketplace.json', JSON.stringify(data))
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });