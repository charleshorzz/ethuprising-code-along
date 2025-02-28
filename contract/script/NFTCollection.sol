// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {NFTCollection} from "../src/NFTCollection.sol";

contract CounterScript is Script {
    NFTCollection public collection;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        
        collection = new NFTCollection('Notion', 'N', 'ipfs://bafybeigdiro5gj4nqujsyqxpvkp33e64ymla7di2ccdknibm3uqv6z6eae/', msg.sender);

        vm.stopBroadcast();
    }
}
