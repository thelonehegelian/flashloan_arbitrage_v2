// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import {IFlashLoanReceiver, ILendingPoolAddressesProvider, ILendingPool} from "../interfaces/interfaces.sol";
// import {SafeERC20, SafeMath} from "../libraries/Libraries.sol";

import '../interfaces/IERC20.sol';
abstract contract FlashLoanReceiverBase is IFlashLoanReceiver {
    // using SafeERC20 for IERC20;
    // using SafeMath for uint256;

    ILendingPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
    ILendingPool public immutable LENDING_POOL;

    constructor(address provider)  {
        ADDRESSES_PROVIDER = ILendingPoolAddressesProvider(provider);
        LENDING_POOL = ILendingPool(
            ILendingPoolAddressesProvider(provider).getLendingPool()
        );
    }

    receive() external payable {}
}
