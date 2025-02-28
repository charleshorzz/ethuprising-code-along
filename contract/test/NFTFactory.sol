// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {NFTFactory} from "../src/NFTFactory.sol";

contract NFTFactoryTest is Test {
    // NFTFactory public factory;

    // // Random address
    // address user1 = 0xc48Cdea7CeE68648De69eAf7d1605aD98b15b13E;
    // address recipient = 0x53D5f6e9255320451B273Cbd5EBe1021acEC7E3b;
    // string nftFolderURI = 'ipfs://bafybeigdiro5gj4nqujsyqxpvkp33e64ymla7di2ccdknibm3uqv6z6eae/';

    // function setUp() public {
    //     collection = new NFTCollection('Notion Faces', 'NF', nftFolderURI, user1);
    // }

    // function test_Mint() public {
    //     vm.prank(user1);
    //     collection.mintNFT(recipient, "1");
    //     // Token ID should be 0 since it's the first NFT minted
    //     uint256 tokenId = 0;

    //     // Check if recipient owns the NFT
    //     assertEq(collection.ownerOf(tokenId), recipient);
    // }
}

    // function createNFTCollection(
    //     string memory _name, 
    //     string memory _symbol, 
    //     string memory _baseURI
    // ) public {
    //     NFTCollection newCollection = new NFTCollection(_name, _symbol, _baseURI, msg.sender);
    //     collections.push(CollectionInfo({
    //         collectionAddress: address(newCollection),
    //         name: _name,
    //         symbol: _symbol,
    //         baseURI: _baseURI,
    //         creator: msg.sender
    //     }));

    //     emit CollectionCreated(address(newCollection), msg.sender, _name, _symbol, _baseURI);
    // }

    // function getAllCollections() public view returns (CollectionInfo[] memory) {
    //     return collections;
    // }