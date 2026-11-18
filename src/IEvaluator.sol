// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// noms des fonctions du contrat déployé sur Sepolia (Exercice et pas Exercise)
interface IEvaluator {
    function ex1_claimedPoints() external;
    function ex2_claimedFromContract() external;
    function ex3_withdrawFromContract() external;
    function ex4_approvedExerciceSolution() external;
    function ex5_revokedExerciceSolution() external;
    function ex6_depositTokens() external;
    function ex7_createERC20() external;
    function ex8_depositAndMint() external;
    function ex9_withdrawAndBurn() external;

    function submitExercice(address studentExercice) external;
    function exerciceProgression(address student, uint256 exercice) external view returns (bool);
}
