//SPDX-License-Identifier: Unlicense
pragma solidity 0.6.12;

interface IPulsarArbitrage {
    function executeArbitrage(
        address fromToken,
        uint256 amountIn,
        address[] calldata pools
    ) external returns (uint256);
}
