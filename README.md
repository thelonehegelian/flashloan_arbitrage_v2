# Running the application

1. run `yarn install` to install the dependencies
2. Add some mainnet archive link (from alchemy or infura) to the .env file. Name the url `ARCHIVE_NODE`
3. run `npx hardhat node`
4. run `npx hardhat test`

# What does it do?
1. Gets a flashloan from AAVE
2. Executes a single swap on uniswapV2
3. Reimburses the flashloan
