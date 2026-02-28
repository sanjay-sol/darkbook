// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import { UltraPlonkVerifier } from "../src/verifiers/UltraPlonkVerifier.sol";
import { Vault } from "../src/Vault.sol";
import { DarkBookEngine } from "../src/DarkBookEngine.sol";

/// @title Deploy
/// @notice Deployment script for DarkBook contracts on Monad
contract Deploy is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("Deploying DarkBook contracts...");
        console.log("Deployer:", deployer);

        vm.startBroadcast(deployerPrivateKey);

        UltraPlonkVerifier verifier = new UltraPlonkVerifier();
        console.log("UltraPlonkVerifier deployed at:", address(verifier));

        Vault vault = new Vault(address(verifier));
        console.log("Vault deployed at:", address(vault));

        DarkBookEngine engine = new DarkBookEngine(address(verifier), address(vault));
        console.log("DarkBookEngine deployed at:", address(engine));

        vault.setDarkBookEngine(address(engine));
        console.log("Vault configured with DarkBookEngine");

        engine.authorizeMatcher(deployer);
        console.log("Deployer authorized as matcher");

        vm.stopBroadcast();

        console.log("");
        console.log("=== Deployment Summary ===");
        console.log("Verifier:    ", address(verifier));
        console.log("Vault:       ", address(vault));
        console.log("Engine:      ", address(engine));
        console.log("========================");
    }
}
