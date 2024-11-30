// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/BridgeProofVerifier.sol";

contract BridgeProofVerifierTest is Test {
    BridgeProofVerifier public verifier;
    uint256 private constant FIELD_PRIME =
        0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;
    uint256 private constant SOURCE_BRIDGE_KEY =
        0x87F83F0A178809ADC0DB8C44D3C982812D6966693FC34F658726406977C0C2D8;
    uint256 private constant GENERATOR =
        0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798;

    function setUp() public {
        verifier = new BridgeProofVerifier();
    }

    function testSolveChallenge() public {
        for (uint i = 0; i < 3; i++) {
            // Get message hash based on current timestamp and sender
            bytes32 messageHash = keccak256(
                abi.encodePacked(block.timestamp, address(this))
            );

            // Use fixed commitment
            uint256 commitment = 123;

            // Calculate challenge based on fixed commitment
            uint256 challenge = uint256(
                keccak256(abi.encodePacked(commitment, messageHash))
            ) % FIELD_PRIME;

            // Calculate networkId = (commitment * bridgeKey**challenge)**(-1) mod p
            uint256 power = modExp(SOURCE_BRIDGE_KEY, challenge, FIELD_PRIME);
            uint256 mult = mulmod(commitment, power, FIELD_PRIME);
            uint256 generatorPower = modExp(GENERATOR, 3, FIELD_PRIME);
            uint256 networkId = mulmod(
                generatorPower,
                modInverse(mult, FIELD_PRIME),
                FIELD_PRIME
            );

            BridgeProofVerifier.BridgeProof memory proof = BridgeProofVerifier
                .BridgeProof({
                    commitment: commitment,
                    responseValue: 3,
                    messageHash: messageHash
                });

            bool success = verifier.verifyBridgeTransaction(proof, networkId);
            assertTrue(success, "Verification failed");

            // Move to next block
            vm.roll(block.number + 1);
            vm.warp(block.timestamp + 1);
        }

        assertTrue(verifier.isSolved(), "Challenge not solved");
    }

    function modExp(
        uint256 base,
        uint256 exponent,
        uint256 modulus
    ) internal pure returns (uint256) {
        if (modulus == 1) return 0;
        uint256 result = 1;
        base = base % modulus;
        while (exponent > 0) {
            if (exponent % 2 == 1) result = mulmod(result, base, modulus);
            base = mulmod(base, base, modulus);
            exponent = exponent >> 1;
        }
        return result;
    }

    function modInverse(uint256 a, uint256 m) internal pure returns (uint256) {
        require(a != 0 && m != 0, "Invalid input");
        return modExp(a, m - 2, m);
    }
}
