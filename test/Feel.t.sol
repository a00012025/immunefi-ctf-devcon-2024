// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {Test, console2} from "forge-std/Test.sol";
import {Feel} from "../src/Feel.sol";
import {FeelToken} from "../src/FeelToken.sol";

contract FeelTest is Test {
    Feel public feel;
    FeelToken public token;
    address public owner;

    function setUp() public {
        owner = address(this);
        token = new FeelToken();
        feel = new Feel(token);

        // Transfer all tokens to Feel contract
        token.transfer(address(feel), token.MAX_SUPPLY());
    }

    function test_ClaimMilestones() public {
        // Add 10 milestones
        string memory note = "aaaaaaaaaaaaaaaaaaaaaaa"; // length 23
        for (uint256 i = 1; i <= 10; i++) {
            feel.addMilestone(i, note);
        }

        // Move time forward 10 minutes
        vm.warp(block.timestamp + 10 minutes);

        // Unlock and claim each milestone twice (second claim should fail)
        for (uint256 i = 1; i <= 10; i++) {
            feel.unlockMilestone(i);
            feel.claimMilestone(i);
            feel.addMilestone(i + 50, note);
            feel.claimMilestone(i);
        }

        // Assert Feel contract has 0 tokens left
        assertEq(token.balanceOf(address(feel)), 0);
    }
}
