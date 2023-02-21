import { expect } from "chai";
import { ethers } from "hardhat";

const ADDRESSES_PROVIDER = "0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5";
const UNISWAP_V2_ROUTER = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D";
// const UNISWAP_V2_FACTORY ="0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f";
const WETH9 = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";

describe("Arbitrage", function () {
  it("Deploys the Arbitrage contract and executes arbitrage", async function () {
    // get signers
    const [owner] = await ethers.getSigners();

    // Deploy the Arbitrage contract
    const Arbitrage = await ethers.getContractFactory("Arbitrage");
    const arbitrage = await Arbitrage.deploy(
      ADDRESSES_PROVIDER,
      UNISWAP_V2_ROUTER
    );
    await arbitrage.deployed();
    expect(arbitrage.address).to.not.be.null;
    // get weth
    const weth = await ethers.getContractAt("IWETH", WETH9);
    // get some weth
    const amountIn = "20";
    await weth
      .connect(owner)
      .deposit({ value: ethers.utils.parseEther(amountIn) });
    // deposit weth to flashloan contract
    await weth
      .connect(owner)
      .transfer(arbitrage.address, ethers.utils.parseEther(amountIn));
    expect(await weth.balanceOf(arbitrage.address)).to.equal(
      ethers.utils.parseEther(amountIn)
    );

    // get uniswap pairs from uniswap factory
    // deploy swap contract
    const Swap = await ethers.getContractFactory("Swap");
    const swap = await Swap.deploy();
    expect(swap.address).to.not.be.null;
    // only getting the first pair here
    const pools = await swap.getAllUniswapPairs(0);
    const poolsArray = [pools];
    expect(poolsArray.length).to.equal(1);

    // pass the pairs to the executeArbitrage() function
    await arbitrage
      .connect(owner)
      .executeArbitrage(WETH9, ethers.utils.parseEther("0.5"), poolsArray);

    // TODO: test only owner can call the executeArbitrage function
  });
});
