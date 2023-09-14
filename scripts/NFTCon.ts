import { ethers } from "hardhat";

async function main() {
    const [to] = await ethers.getSigners()

    const toAd = to.address

  const nftchainlink = await ethers.deployContract("NFTContract", [to]);
  
  await nftchainlink.waitForDeployment();

  const nftrequest = await nftchainlink.requestRandomWords();

  await nftrequest.wait()

  console.log(
    ` deployed to ${nftchainlink.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
