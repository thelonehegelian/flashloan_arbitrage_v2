// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "hardhat/console.sol";
import {FlashLoanReceiverBase} from "./aave/FlashloanReceiverBase.sol";
import {ILendingPool, ILendingPoolAddressesProvider} from "./interfaces/interfaces.sol";
import {IUniswapV2Pair, IUniswapV2Router02} from "./interfaces/uniswapInterfaces.sol";
import "./interfaces/IERC20.sol";

import "./interfaces/IArbitrageExecutor.sol";

contract Arbitrage is FlashLoanReceiverBase, IArbitrageExecutor {

    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public UNISWAP_V2_ROUTER; 
    address private owner;

    constructor(address _addressProvider, address uniSwap)
        FlashLoanReceiverBase(_addressProvider)
    {
        // set owner to the deployer of the function
        owner = msg.sender;
        UNISWAP_V2_ROUTER = uniSwap;
    }

    function executeArbitrage(
        address fromToken,
        uint256 amountIn,
        address[] calldata pool
    ) public override returns (uint256) {
        // TODO use Ownable, onlyOwner
        require(
            msg.sender == owner,
            "Only owner is allowed to call this function"
        );
        flashloan(fromToken, amountIn);

        return IERC20(WETH).balanceOf(address(this));
    }

    function singleSwap(
        uint256 _amountIn,
        address _tokenIn,
        address _tokenOut
    ) internal returns (uint256) {
        // TODO: Use safeTransfer from TransferHelper library instead
        // safeTranfer was not working for some reason so a temp solution here
        require(IERC20(_tokenIn).approve(UNISWAP_V2_ROUTER, _amountIn));

        address[] memory path = new address[](2);
        path[0] = address(_tokenIn);
        path[1] = address(_tokenOut);

        uint256 amountOut = IUniswapV2Router02(UNISWAP_V2_ROUTER)
            .swapExactTokensForTokens(
                _amountIn,
                0,
                path,
                address(this),
                block.timestamp
            )[1];
        return amountOut;
    }

    /**
     * @dev This function must be called only by the LENDING_POOL and takes care of repaying
     * active debt positions, migrating collateral and incurring new V2 debt token debt.
     *
     * @param assets The array of flash loaned assets used to repay debts.
     * @param amounts The array of flash loaned asset amounts used to repay debts.
     * @param premiums The array of premiums incurred as additional debts.
     * @param initiator The address that initiated the flash loan, unused.
     * @param params The byte array containing, in this case, the arrays of aTokens and aTokenAmounts.
     */
    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums, // premiums map to assets
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        // Funds have been received
        // make a swap on uniswap, weth for DAI
        singleSwap(250, assets[0], DAI);


        // Approve the LendingPool contract allowance to *pull* the owed amount
        for (uint256 i = 0; i < assets.length; i++) {
            uint256 amountOwing = amounts[i] + premiums[i];
        // console.log("Amount owed",amountOwing);
        // console.log("You have this much left", IERC20(assets[0]).balanceOf(address(this)));

            IERC20(assets[i]).approve(address(LENDING_POOL), amountOwing);
        }

        return true;
    }

    function _flashloan(address[] memory assets, uint256[] memory amounts)
        internal
    {
        address receiverAddress = address(this);

        address onBehalfOf = address(this);
        bytes memory params = "";
        uint16 referralCode = 0;

        uint256[] memory modes = new uint256[](assets.length);

        for (uint256 i = 0; i < assets.length; i++) {
            modes[i] = 0;
        }

        LENDING_POOL.flashLoan(
            receiverAddress,
            assets,
            amounts,
            modes,
            onBehalfOf,
            params,
            referralCode
        );
    }

    function flashloan(address _asset, uint256 amountIn) internal {
        
        bytes memory data = "";
        uint256 amount = amountIn;

        address[] memory assets = new address[](1);
        assets[0] = _asset;

        uint256[] memory amounts = new uint256[](1);
        amounts[0] = amount;

        _flashloan(assets, amounts);
    }
}
