
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
interface ISwap {
   function getUniswapPairs(address _tokenA, address _tokenB)
        external
        view
        returns (address);
    function getAllUniswapPairs(uint256 _numPairs)
        external
        view
        returns (address);
     function singleSwap(
        address _token0,
        address _token1,
        uint256 _amountIn,
        uint256 _amountOutMin,
        address _to
    ) external returns (uint256);
}