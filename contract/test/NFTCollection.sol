// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {NFTCollection} from "../src/NFTCollection.sol";

contract NFTCollectionTest is Test {
    NFTCollection public collection;

    // Random address
    address user1 = 0xc48Cdea7CeE68648De69eAf7d1605aD98b15b13E;
    address recipient = 0x53D5f6e9255320451B273Cbd5EBe1021acEC7E3b;
    string nftFolderURI = 'ipfs://xxxxx/';

    function setUp() public {
        collection = new NFTCollection('Notion Faces', 'NF', nftFolderURI, user1);
    }

    function test_Mint() public {
        vm.prank(user1);
        collection.mintNFT(recipient, "1");
        // Token ID should be 0 since it's the first NFT minted
        uint256 tokenId = 0;

        // Check if recipient owns the NFT
        assertEq(collection.ownerOf(tokenId), recipient);
    }
}