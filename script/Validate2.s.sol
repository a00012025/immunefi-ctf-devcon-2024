// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/CurveValidatorPlus.sol";

contract ValidateScript is Script {
    function run() external {
        // Deploy the CurveValidator contract
        CurveValidatorPlus validator = CurveValidatorPlus(
            0xA5b02eAEB670831029Ff6460FDA0BeC7CC5324CD
        );

        // Define the two possible Gx and Gy values
        uint256 p = 10815735905440749559;
        uint256 A = 7355136236241731806;
        uint256 B = 5612508011909152239;
        uint256 Gx = 9095054958282089818;
        uint256 Gy = 9619156536901535228;
        // uint256 Gx2 = 7094227944684999055;
        // uint256 Gy2 = 2441395873057048146;

        // Start broadcasting transactions
        vm.startBroadcast();

        // Call validate with the first pair of Gx and Gy
        // validator.validate(Gx1, Gy1);

        // Call validate with the second pair of Gx and Gy
        validator.validate(p, A, B, Gx, Gy);

        // Stop broadcasting transactions
        vm.stopBroadcast();
    }
}
