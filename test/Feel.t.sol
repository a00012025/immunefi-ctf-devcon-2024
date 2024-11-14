// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Feel} from "../src/Feel.sol";
import {FeelToken} from "../src/FeelToken.sol";

contract FeelTest is Test {
    Feel public feel;
    FeelToken public token;

    function setUp() public {
        token = new FeelToken();
        feel = new Feel(token);
        token.transfer(address(feel), token.MAX_SUPPLY());
    }

    function test_AddMilestone() public {
        feel.addMilestone(2, "123");
    }
}
