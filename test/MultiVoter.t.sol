// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {Setup} from "../src/Setup3.sol";
import {MultiVoterWallet} from "../src/MultiVoterWallet.sol";
import {console} from "forge-std/console.sol";

contract MultiVoterTest is Test {
    Setup public chal;
    MultiVoterWallet public wallet;
    address public player = makeAddr("player");
    address public randomDelegatee = makeAddr("delegatee");

    function setUp() public {
        console.log("player address: %s", player);
        chal = new Setup(player);
        console.log("setup address: %s", address(chal));
        wallet = chal.wallet();
        vm.startPrank(player);
    }

    function testProposalAndDelegate() public {
        // Create a proposal with random target and empty data

        // Delegate votes to random address
        for (uint i = 0; i < 100; i++) {
            wallet.delegate(randomDelegatee);
            wallet.delegate(address(chal));
            wallet.delegate(player);
        }
        address randomTarget = makeAddr("target");
        wallet.propose(randomTarget, "");
        // vm.stopPrank();
        // vm.startPrank(randomDelegatee);
        wallet.vote();
        // vm.stopPrank();

        // vm.startPrank(player);
        wallet.execute();
        // vm.stopPrank();

        (bool finished, , , , , ) = wallet.proposals(0);
        assertTrue(finished);

        // wallet.delegate(player);
    }
}
