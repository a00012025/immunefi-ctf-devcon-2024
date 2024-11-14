// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import "../src/Setup2.sol";

contract SekaiScript is Script {
    function run() public {
        // Calculate storage slot for keys[0xdead]
        // mapping slot is keccak256(key . mapping_slot)
        bytes32 slot = keccak256(abi.encode(uint(0xdead), uint(1)));
        console.log("Slot:", uint256(slot));

        vm.startBroadcast();

        Setup setup = Setup(0x539F15ecB185FFa2F07C0966E862B524F065c89d);
        Sekai sekai = setup.sekai();

        // Call unlockSekai with the calculated slot
        sekai.unlockSekai(uint256(slot));

        vm.stopBroadcast();
    }
}
