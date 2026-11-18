// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ExerciseSolution} from "../src/ExerciseSolution.sol";
import {ExerciseSolutionToken} from "../src/ExerciseSolutionToken.sol";
import {IEvaluator} from "../src/IEvaluator.sol";
import {IERC20Claimable} from "../src/IERC20Claimable.sol";

// fork de Sepolia avec les vrais contrats du prof
contract ExerciseSolutionTest is Test {
    IEvaluator evaluator = IEvaluator(0x822aF04084720Ade89E34e316c169435bBA9C886);
    IERC20Claimable claimable = IERC20Claimable(0xD829b447AbABDb689C1F6DC81CCe3d29b37c5992);
    IERC20 points = IERC20(0xeaD7680f5Bdb0aAa450399E8F49d4Efb9040Da08);

    address student = makeAddr("student");

    function setUp() public {
        vm.createSelectFork(vm.envOr("SEPOLIA_RPC_URL", string("https://ethereum-sepolia-rpc.publicnode.com")));
    }

    function test_allExercises() public {
        vm.startPrank(student);

        claimable.claimTokens();
        evaluator.ex1_claimedPoints();

        ExerciseSolutionToken token = new ExerciseSolutionToken();
        ExerciseSolution solution = new ExerciseSolution(claimable, token);
        token.setMinter(address(solution), true);
        evaluator.submitExercice(address(solution));

        evaluator.ex2_claimedFromContract();
        evaluator.ex3_withdrawFromContract();

        claimable.approve(address(solution), 1 ether);
        evaluator.ex4_approvedExerciceSolution();
        claimable.approve(address(solution), 0);
        evaluator.ex5_revokedExerciceSolution();

        evaluator.ex6_depositTokens();
        evaluator.ex7_createERC20();
        evaluator.ex8_depositAndMint();
        evaluator.ex9_withdrawAndBurn();

        vm.stopPrank();

        for (uint256 i = 0; i <= 9; i++) {
            assertTrue(evaluator.exerciceProgression(student, i));
        }
        assertEq(points.balanceOf(student), 20 ether);
        assertEq(token.totalSupply(), 0);
        assertEq(solution.tokensInCustody(address(evaluator)), 0);
    }
}
