// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Script.sol";
import "../src/Setup.sol";

contract SetupScript is Script {
    function run() external {
        // Replace with actual contract address
        Setup setup = Setup(0x3439D7d3FF110025ed7db1a5F8BAB9Ca5F5fbfa5);

        vm.startBroadcast();

        // Level 1
        // string memory level1Result = setup.level1();
        // console.log("Level 1 result:", level1Result);

        // // Get password for level 2
        // // uint256 password2 = setup.passwords(2);
        string memory level2Result = setup.level2(0x1337);
        console.log("Level 2 result:", level2Result);

        // // // Level 3 (requires msg.value)
        // string memory level3Result = setup.level3{value: 0.02 ether}();
        // console.log("Level 3 result:", level3Result);

        // // Level 4 (requires secret)
        // string memory secret = setup.s3cr3t_s3cr3t();
        // string memory level4Result = setup.level4(secret);
        // console.log("Level 4 result:", level4Result);

        // // Level 5
        // uint256 password5 = setup.passwords(5);
        // string memory level5Result = setup.level5(password5);
        // console.log("Level 5 result:", level5Result);

        // // Check if solved
        // bool solved = setup.isSolved();
        // console.log("Challenge solved:", solved);

        vm.stopBroadcast();
    }
}
