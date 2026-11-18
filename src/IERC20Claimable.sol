// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IERC20Claimable is IERC20 {
    function claimTokens() external returns (uint256);
    function distributedAmount() external view returns (uint256);
}
