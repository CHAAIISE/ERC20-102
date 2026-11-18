// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract ExerciseSolutionToken is ERC20, Ownable {
    mapping(address => bool) public isMinter;

    constructor() ERC20("ExerciseSolutionToken", "EST") Ownable(msg.sender) {}

    modifier onlyMinter() {
        require(isMinter[msg.sender], "Not minter");
        _;
    }

    function setMinter(address minterAddress, bool minter) external onlyOwner {
        isMinter[minterAddress] = minter;
    }

    function mint(address toAddress, uint256 amount) external onlyMinter {
        _mint(toAddress, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    // ExerciseSolution (minter) can take the tokens back without approve when someone withdraws
    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        if (isMinter[msg.sender]) {
            _transfer(from, to, amount);
            return true;
        }
        return super.transferFrom(from, to, amount);
    }
}
