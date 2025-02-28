// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {NFTFactory} from "../src/NFTFactory.sol";

contract NFTFactoryTest is Test {
    NFTFactory public factory;

    // Random address
    address user1 = 0xc48Cdea7CeE68648De69eAf7d1605aD98b15b13E;
    string name = 'Notion Faces';
    string symbol = 'NF';
    string baseURI = 'ipfs://xxxxxx/';

    function setUp() public {
        factory = new NFTFactory();
    }

    function test_Create_NFT_Collection() public {
        // Act as user 1
        vm.prank(user1);
        factory.createNFTCollection(name, symbol, baseURI);
        // Get all collections
        NFTFactory.CollectionInfo[] memory collections = factory.getAllCollections();

        // Ensure one collection was created
        assertEq(collections.length, 1);

        // Verify details of the created collection
        assertEq(collections[0].name, name);
        assertEq(collections[0].symbol, symbol);
        assertEq(collections[0].baseURI, baseURI);
        assertEq(collections[0].creator, user1);

        // Ensure the contract address is not zero (indicating it was deployed)
        assertTrue(collections[0].collectionAddress != address(0));
    }
}