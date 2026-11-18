// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IExerciseSolution} from "./IExerciseSolution.sol";
import {IERC20Claimable} from "./IERC20Claimable.sol";
import {ExerciseSolutionToken} from "./ExerciseSolutionToken.sol";

contract ExerciseSolution is IExerciseSolution {
    IERC20Claimable public claimableToken;
    ExerciseSolutionToken public depositToken;

    mapping(address => uint256) public tokensInCustody;

    constructor(IERC20Claimable _claimableToken, ExerciseSolutionToken _depositToken) {
        claimableToken = _claimableToken;
        depositToken = _depositToken;
    }

    function claimTokensOnBehalf() external {
        uint256 amount = claimableToken.claimTokens();
        tokensInCustody[msg.sender] += amount;
        depositToken.mint(msg.sender, amount);
    }

    function withdrawTokens(uint256 amountToWithdraw) external returns (uint256) {
        require(tokensInCustody[msg.sender] >= amountToWithdraw, "Not enough tokens in custody");
        tokensInCustody[msg.sender] -= amountToWithdraw;

        require(depositToken.transferFrom(msg.sender, address(this), amountToWithdraw), "TransferFrom failed");
        depositToken.burn(amountToWithdraw);

        require(claimableToken.transfer(msg.sender, amountToWithdraw), "Transfer failed");
        return amountToWithdraw;
    }

    function depositTokens(uint256 amountToDeposit) external returns (uint256) {
        require(claimableToken.transferFrom(msg.sender, address(this), amountToDeposit), "TransferFrom failed");
        tokensInCustody[msg.sender] += amountToDeposit;

        depositToken.mint(msg.sender, amountToDeposit);
        return amountToDeposit;
    }

    function getERC20DepositAddress() external view returns (address) {
        return address(depositToken);
    }
}
