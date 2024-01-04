import { ethers, upgrades } from "hardhat";
import moment from "moment";

async function main() {
  const Contract = await ethers.getContractFactory("ERC20Token");
  const contract = await Contract.deploy();

  await contract.deployed();
  console.log(`ERC20 deployed to : ${contract.address}`);

  await (
    await contract.transfer(
      "0x2a69C79eDc547D96921F602DcAc4388149C206Aa",
      ethers.utils.parseEther("10")
    )
  ).wait();
  console.log("done");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
