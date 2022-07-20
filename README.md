# Running the application

1. run `yarn install` to install the dependencies
2. Add some mainnet archive link (from alchemy or infura) to the .env file. Name the url `ARCHIVE_NODE`
3. run `npx hardhat node`
4. run `npx hardhat test`

# Tasks

[x] Implement executeArbitrage() function

	[x] Make a flashloan
	[x] execute swap on uniswap
	[x] reimburse the flashloan

[x] Test the contract
	[x] Wrap some ETH to WETH
		I just deposit WETH using WETH contract and interface. I assume that's what was meant. Though I am aware it could also have been done by creating a separate an ERC20 wethToken contract or through some other UI.
	[x]	Send WETH to the contract
	[x]	Get some pool from the UniswapV2 factory (ex: WETH/WBTC ; WBTC/USDT ; USDT/WETH)
		
		_comment:_ It does not say anything about doing something with the pool itself so I am leaving it at that
		Though pool addresses can be used to retreive token0 and token1 addresses, which can then be swapped.
		I have actually done that in a separate repo because I thought I was supposed to do something with the pool. UniSwapV2Pair has functions to retreive the tokens from the pool/pair address.


	[x] Execute the smart contract (it's not easy to make a profitable arbitrage, that's why it's usefull to send WETH to the contract before  calling it, in order to have more funds to reimburse the flashloan)

		_comment_: I assumed that I do not have to make a profitable trade. So I just made a single swap with the loaned amount. 
		Also the readme mentions "arbitrary number of swap through uniswap v2 pool". I was unclear about  whether it meant dividing the loaned amount and making a number of swaps and reimburse the loan  or just any number of swaps (including a single swap)

	[x]	Ensure the transaction success

[x] Use mainnet fork 
	[x] setup the env variable `ARCHIVE_NODE` in order to be able to fork the mainnet
[x] Your main smart contract have to be named `PulsarArbitrage` and implements `IPulsarArbitrage`

	I took it to mean that there should only be one function that can be used to interact with the PulsarArbitrage contract and that is defined in IPulsarArbitrage.
	So anyone (though I have set an owner in this particular instance) can use the executeArbitrage function by doing this IPulsarArbitrage(addressPulsarArbitrage). 
	Other functions in the contract should not be visible and executeArbitrage() can call the flashloan function on AAVE protocol

	Though I understand it could also have meant separating the flashloan logic in a separate Flashloan.sol contract. I had been working on that as well actually. But there were some errors trying to call the Lendig_Pool from the PulsarArbitrage contract. I wasn't able to resolve them in time.



# Notes

- The flashloan logic is standard and is available over the internet. I did not do much to it  
- Swap.sol has customized functions from UniSwap protocol. Initially I was calling the singleSwap function through Swap.sol interface. But I scratched that as I thought it wasn't really necessary for this particular contract. 
- I am aware that a pricing oracle like ChainLink would have been best before making a swap on Uniswap and Uniswap recommends that too, that the amountOut should be calculated using an Oracle. 
	- This is one of the reasons I separated the Swap contract
- I would have liked to use typechain for a bit more robust test but it wasn't working for me at the time



# Blockchain developer

This subject aim to prove your divine power in the blockchain by developing a smart contract that
interacts with different protocols.

## Subject

### Make the smart contract

You have to develop a smart contract that implements the already existing interface `IPulsarArbitrage`.
The function `executeArbitrage` have to :
 - Make a flashloan on AAVE
 - Execute an arbitrary number of swap through uniswap v2 pool with the borrowed amount
 - Reimburse the flashloan
 
**Tips:** Lot of DEX are forked from Uniswap v2 and should be compatible with your code. Moreover it should be usefull to
have two or more pool of the same pair. Also note the fee can differ across forks, we just want you to manage DEX that 
take 0.3% fee like the original uniswap v2 protocol does (SushiSwap use the same value).

### Make the tests

You have to write a typescript test file using hardhat and ethers that:
 - Deploy the contract
 - Wrap some ETH to WETH
 - Send WETH to the contract (this will be usefull for next step)
 - Get some pool from the UniswapV2 factory (ex: WETH/WBTC ; WBTC/USDT ; USDT/WETH)
 - Execute the smart contract (it's not easy to make a profitable arbitrage, that's why it's usefull to send WETH to the contract before calling it, in order to have more funds to reimburse the flashloan)
 - Ensure the transaction success

## Requirements & Goal

 - A minimal hardhat config is already setup
 - You should get an archive node (for exemple in alchemy.io) and setup the env variable `ARCHIVE_NODE` in order to be able to fork the mainnet
 - Your contract should not use hardcoded address to interact with another protocol (pass it to constructor if need)
 - You have to use `yarn` instead of npm  
 - You have to use the npm package `ethers` to make your tests (already installed)
 - You can use any other lib you think relevant
 - You have to create test & deploy scripts in typescript
 - Your main smart contract have to be named `PulsarArbitrage` and implements `IPulsarArbitrage`
 - Feel free to improvise if you need to and comment your code to explain your choices

Good luck.

In order to not influence others candidates, do not fork the project in a public repo. Send us a zip of your solution or add us to a private repo.
