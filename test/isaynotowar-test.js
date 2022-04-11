const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("IsaynotoWar", function () {
  it("Should mint NFTs", async function () {
    const [owner] = await ethers.getSigners();
    const IsaynotoWar = await ethers.getContractFactory("IsaynotoWar");
    const isaynotoWar = await IsaynotoWar.deploy("I say no to War", "NOWAR");
    await isaynotoWar.deployed();

    let mintSignatureTx = await isaynotoWar.mintSignature();
    await mintSignatureTx.wait();
    expect(await isaynotoWar.balanceOf(owner.address)).to.equal(1);
    mintSignatureTx = await isaynotoWar.mintSignature();
    await mintSignatureTx.wait();
    expect(await isaynotoWar.balanceOf(owner.address)).to.equal(2);
  });
});
