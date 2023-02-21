// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;
import "hardhat/console.sol";

import "../interfaces/IUniswapV2Factory.sol";
import "../interfaces/IUniswapV2Router02.sol";
import "../interfaces/IERC20.sol";
import {IUniswapV2Pair} from "../interfaces/uniswapInterfaces.sol";

contract Swap {
    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    // TODO: Pass ROUTER and FACTORY address to the constructor
    address private constant UNISWAP_V2_ROUTER =
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant UNISWAP_V2_FACTORY =
        0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;

    IUniswapV2Factory uniSwapFactory = IUniswapV2Factory(UNISWAP_V2_FACTORY);

    // TODO: Add Sushiswap functions too

    // gets pair/pool of assets on uniswap
    function getUniswapPairs(address _tokenA, address _tokenB)
        public
        view
        returns (address)
    {
        address pairAddress = uniSwapFactory.getPair(_tokenA, _tokenB);
        // console.log("this is the pair address:", pairAddress);
        return pairAddress;
    }

    function getAllUniswapPairs(uint256 _numPairs)
        public
        view
        returns (address)
    {
        address pairAddress = uniSwapFactory.allPairs(_numPairs);
        // console.log("this is the pair address:", pairAddress);
        return pairAddress;
    }

    // TODO: remove pool fee
    // pool fee to 0.3%.
    uint24 public constant poolFee = 3000;

    function singleSwap(
        address _token0,
        address _token1,
        uint256 _amountIn,
        uint256 _amountOutMin,
        address _to
    ) external returns (uint256) {
        // TODO: Use safeTransfer from TransferHelper library instead
        // safeTranfer was not working for some reason so a temp solution here

        // IERC20(_token0).transferFrom(msg.sender, address(this), _amountIn);
        IERC20(_token0).approve(UNISWAP_V2_ROUTER, _amountIn);

        address[] memory path = new address[](2);
        path[0] = address(_token0);
        path[1] = address(_token1);

        uint256 amountOut = IUniswapV2Router02(UNISWAP_V2_ROUTER)
            .swapExactTokensForTokens(
                _amountIn,
                _amountOutMin,
                path,
                _to,
                block.timestamp
            )[1];
        return amountOut;
    }

    // TODO
    // function swapPair(address asset, uint256 amountIn, address[] calldata pools, ) external {

    // }
}
