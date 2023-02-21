// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
// import "./ISwap.sol";

interface IArbitrageExecutor{
    function executeArbitrage(
        address fromToken,
        uint256 amountIn,
        address[] calldata pools
    ) external returns (uint256);
}

