// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/CurveValidator.sol";

contract ValidateScript is Script {
    function run() external {
        // Deploy the CurveValidator contract
        CurveValidator validator = CurveValidator(
            0xA5b02eAEB670831029Ff6460FDA0BeC7CC5324CD
        );

        // Define the two possible Gx and Gy values
        uint256 Gx2 = 9095054958282089818;
        uint256 Gy2 = 9619156536901535228;
        // uint256 Gx2 = 7094227944684999055;
        // uint256 Gy2 = 2441395873057048146;

        // Start broadcasting transactions
        vm.startBroadcast();

        // Call validate with the first pair of Gx and Gy
        // validator.validate(Gx1, Gy1);

        // Call validate with the second pair of Gx and Gy
        validator.validate(Gx2, Gy2);

        // Stop broadcasting transactions
        vm.stopBroadcast();
    }
}
