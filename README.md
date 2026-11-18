# ERC20-102

Workshop [ERC20 102](https://github.com/Elli610/Blockchain-101/tree/main/workshops/solidity/erc20-102) fait avec Foundry sur Sepolia.

## Contrats

- `src/ExerciseSolution.sol` : claim les tokens du ClaimableToken pour l'appelant (`claimTokensOnBehalf`), garde les tokens en custody par adresse, `depositTokens` avec `transferFrom` et `withdrawTokens`.
- `src/ExerciseSolutionToken.sol` : ERC20 mintable (EST), seul `ExerciseSolution` est minter. Il représente les tokens en custody : mint au claim et au dépôt, `transferFrom` puis burn au retrait.
- `src/IEvaluator.sol` et `src/IERC20Claimable.sol` : interfaces des contrats du prof.

Sur Sepolia l'evaluator déployé utilise `submitExercice`, `exerciceProgression`, `ex4_approvedExerciceSolution` et `ex5_revokedExerciceSolution` (avec un c), pas les noms du README du workshop.

Pour l'ex9, l'evaluator ne fait pas d'approve sur ExerciseSolutionToken avant d'appeler `withdrawTokens`, donc le token laisse le minter faire `transferFrom` sans allowance.

## Lancer

Mettre `SEPOLIA_RPC_URL` dans `.env` (voir `.env.example`).

```
forge build
forge test
```

`forge test` fait tous les exercices sur un fork de Sepolia avec une adresse de test.

Contrats du prof (Sepolia) :
- TDToken : `0xeaD7680f5Bdb0aAa450399E8F49d4Efb9040Da08`
- ClaimableToken : `0xD829b447AbABDb689C1F6DC81CCe3d29b37c5992`
- Evaluator : `0x822aF04084720Ade89E34e316c169435bBA9C886`
