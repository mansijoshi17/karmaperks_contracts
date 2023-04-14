const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  const KarmaTokenContract = await hre.ethers.getContractFactory("KarmaToken");
  const karmaTokenContract = await KarmaTokenContract.deploy();

  console.log("Karma Token contract address:", karmaTokenContract.address);

  const KarmaPerksContract = await hre.ethers.getContractFactory("KarmaPerks");
  const karmaperksContract = await KarmaPerksContract.deploy();

  console.log("Karma Perks NFT contract address:", karmaperksContract.address);

  const AirdropFactoryContract = await hre.ethers.getContractFactory(
    "AirdropFactory"
  );
  const airdropFactoryContract = await AirdropFactoryContract.deploy();

  console.log(
    "Airdrop Factory contract address:",
    airdropFactoryContract.address
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
