// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./NFTCollection.sol";

contract NFTFactory {
    struct CollectionInfo {
        address collectionAddress;
        address creator;
        string name;
        string symbol;
        string baseURI;
    }

    CollectionInfo[] public collections;

    event CollectionCreated(
        address indexed collectionAddress,
        address creator,
        string name,
        string symbol,
        string baseURI
    );

    function createNFTCollection(
        string memory name, 
        string memory symbol, 
        string memory baseURI
    ) public {
        NFTCollection newCollection = new NFTCollection(name, symbol, baseURI, msg.sender);
        collections.push(CollectionInfo({
            collectionAddress: address(newCollection),
            name: name,
            symbol: symbol,
            baseURI: baseURI,
            creator: msg.sender
        }));

        emit CollectionCreated(address(newCollection), msg.sender, name, symbol, baseURI);
    }

    function getAllCollections() public view returns (CollectionInfo[] memory) {
        return collections;
    }
}