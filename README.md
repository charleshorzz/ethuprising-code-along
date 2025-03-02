# ETHUprising Code-Along

Welcome to the ETHUprising Code-Along! In this session, we’ll dive into The Graph, a decentralized indexing protocol that enables fast and efficient querying of blockchain data.

## Prerequisites

Before starting the workshop, ensure you have the following set up:

1. **Foundry Installed & Running**
- Install [Foundry](https://book.getfoundry.sh/getting-started/installation) if you haven't already.
- Verify it's working by running:

```sh
forge --version
```

2. **Git Installed**
- Download and install [Git](https://git-scm.com/downloads) if needed.
- Verify installation:

```sh
git --version
```

3. **A Folder with at Least One Image**
- Prepare a folder containing at least one image.
- It is highly recommend you generate a few using [Notion Faces](https://faces.notion.com/).

Once you have these set up, you're ready to proceed with the workshop!

## 🛠️ What You’ll Learn

By the end of this session, you will:

- Set up and deploy a subgraph from scratch
- Track multiple contracts within a single subgraph
- Implement dynamic data tracking with subgraph templates

## :small_airplane: Getting Started

Follow these steps to prepare your metadata:

### 1. Upload Your Images & Get the CID
- Visit this [website](https://ipfs-uploader-eosin.vercel.app).
- Upload your images one by one.
- After each upload, record the CID (Content Identifier) for later use.

### 2. Create Your Metadata File
- Create a folder.
- Based on the `x` number of images uploaded, create `x` amount of JSON files (e.g. `image-1.json`).
- Edit each individual JSON file, and copy the following JSON template and replace the placeholders:

```json
{
  "name": "<NAME>",
  "description": "<DESCRIPTION>",
  "image": "ipfs://<CID>",
  "attributes": [
    { "trait_type": "Background", "value": "<COLOR>" },
    { "trait_type": "Rarity", "value": "<RARITY>" }
  ]
}
```

### 3. Replace The Placeholders
- `NAME`: Set a name for your NFT
- `DESCRIPTION`: Provide a short description
- `CID`: Paste the CID from your uploaded image
- `COLOR`: The "background" attribute's color (e.g. "Blue", "Yellow")
- `RARITY`: The "rarity" attribute of the NFT (e.g. "Common", "Rare")

> [!NOTE]
> Both `COLOR` and `RARITY` attributes are for cosmetic only, any value they have won't affect the final outcome.

### 4. Saving The Files
- Create a new folder.
- Save the JSON files in the created folder.

### 5. Upload Your Metadata Folder
- Go back to the [upload website](https://ipfs-uploader-eosin.vercel.app/).
- This time, upload the **entire folder** containing your JSON files.
- After the upload, record the new CID assigned to your folder.

> [!IMPORTANT]
> You are unable to proceed if you did not upload the **entire folder** at once.

### 6. Your Metadata CID
- You will receive a new CID.
- The new CID represents the folder containing all your metadata files.
- You will use this CID in the next steps of the workshop.

### 7. Deploy Your NFT Collection
- Go to [ScrollScan](https://sepolia.scrollscan.com/) or navigate to **your own deployed contract**.
- Click on the "Contracts" tab.
- Select "Write Contract" to interact with the contract.

### 8. Call `createNFTCollection`
- Locate the `createNFTCollection` function.
- Enter the following parameters:
  - Name → Can be anything (e.g., `"My NFT Collection"`).
  - Symbol → A short identifier (e.g., `"MNFT"`).
  - BaseURI → The CID from your **metadata** folder
- Example input:

```vbnet
Name: "Cool Avatars"
Symbol: "CAV"
BaseURI: "<YOUR_METADATA_FOLDER_CID>"
```
- Click "Write" to execute the transaction.

### 9. Find Your Deployed NFT Collection
- After executing `createNFTCollection`, locate the **Transaction Hash** in the confirmation details.
- Click on the **Transaction Hash** to view the transaction details on ScrollScan.
- In the transaction details, find the `NFTCollection` contract address (this is where your NFTs will be minted).

### 10. Mint Your First NFT
- Go to your `NFTCollection` contract on ScrollScan.
- Click on the "Contracts" tab and select "Write Contract".
- Find the `mintNFT` function and enter:
  - Recipient Address → Your wallet address (or another recipient's address).
  - MetadataCID → The name of your `metadata` file (e.g., `"metadata.json"`).
- Example input:

```vbnet
Recipient Address: 0xYourWalletAddress
MetadataCID: "metadata.json"
```

- Click "Write" to execute the transaction and mint your NFT!

## Explaining The Contracts

### [NFTCollection Contract](./contract/src/NFTCollection.sol)

This contract **creates and manages an NFT collection**. Each instance of `NFTCollection` represents a unique set of NFTs that can be monted and owned.

#### 🔹 Summary of What This Contract Does

1. Creates an NFT collection with a name, symbol, and metadata base URL.
2. Allows only the owner (creator) to mint new NFTs.
3. Automatically assigns a unique ID to each NFT.
4. Links each NFT to metadata stored off-chain (e.g., on IPFS).
5. Emits an event every time an NFT is minted for easy tracking.

This contract is used by `NFTFactory` to generate and manage NFT collections dynamically!

#### 🌟 Example Use Case

Let’s say Erica deploys an NFT collection with this contract:

```solidity
new NFTCollection("Cool Art", "CART", "https://ipfs.io/ipfs/Qm123/", msg.sender);
```

Now Erica can mint an NFT like this:

```solidity
mintNFT(0xRecipientAddress, "QmNFTMetadataCID");
```

This will create an NFT with metadata stored at:

```
https://ipfs.io/ipfs/Qm123/QmNFTMetadataCID.json
```

Here's the breakdown of each important code snippet:

#### 1️⃣ Importing OpenZeppelin Libraries

```solidity
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
```

The contract imports two important **OpenZeppelin** libraries:

1. **ERC721URIStorage**: A standard for NFTs, allowing them to store metadata (image, name, description, etc.).
2. **Ownable**: Provides ownership control, so only the creator (owner) can mint new NFTs.

#### 2️⃣ Declaring the Contract

```solidity
contract NFTCollection is ERC721URIStorage, Ownable {}
```

- `NFTCollection` **inherits from** `ERC721URIStorage` and `Ownable`.
- This means it **behaves like an NFT collection and has an owner** who controls minting.

#### 3️⃣ State Variables

```solidity
uint256 private _nextTokenId;
string private _baseTokenURI;
```

- `_nextTokenId`: A counter for **assigning unique IDs to NFTs**.
- `_baseTokenURI`: Stores the **base URL** where NFT metadata is located.

#### 4️⃣ Declaring an Event

```solidity
event NFTMinted(address indexed recipient, uint256 tokenId, string metadataCID);
```

- This event **logs every new NFT minting**.
- It records:
  - `recipient`: The address that received the NFT.
  - `tokenId`: The unique NFT ID.
  - `metadataCID`: The **Content Identifier (CID)** for the NFT’s metadata on **IPFS or other storage**.

#### 5️⃣ The Constructor (Initializing the Collection)

```solidity
constructor(
    string memory name,
    string memory symbol,
    string memory baseURI,
    address creator
) ERC721(name, symbol) Ownable(msg.sender) {
    _baseTokenURI = baseURI;
    transferOwnership(creator);
}
```

- This function **runs only once when the contract is deployed**.
- It sets up the NFT collection with:
  - `name`: The full name of the collection.
  - `symbol`: A short identifier (e.g., “NFTX”).
  - `baseURI`: The starting URL for metadata.
  - `creator`: The person who will own the collection.
  - `transferOwnership(creator)`: Gives control of the collection to the specified creator instead of the deployer.

#### 6️⃣ Minting New NFTs

```solidity
function mintNFT(address _recipient, string memory _metadataCID) public onlyOwner {}
```

- This function creates (mints) a new NFT.
- Only the owner of the contract (creator) can call it.

**Step 1: Assign a Token ID**

```solidity
uint256 tokenId = _nextTokenId++;
```

- Each NFT gets a unique ID, starting from 0 and increasing each time a new one is minted.

**Step 2: Mint the NFT to the Recipient**

```solidity
_mint(_recipient, tokenId);
```

- Calls the built-in `_mint()` function from `ERC-721` to officially create the NFT and assign it to` _recipient`.

**Step 3: Set the NFT’s Metadata**

```solidity
_setTokenURI(tokenId, string(abi.encodePacked(_baseTokenURI, _metadataCID, ".json")));
```

- This sets the NFT’s metadata link by combining:
  - `_baseTokenURI` (e.g., `"https://my-nft-api.com/metadata/"`)
  - `_metadataCID` (a unique Content Identifier for this NFT’s data).
  - `".json"` (NFT metadata is stored in JSON format).
- Example output:

```
https://my-nft-api.com/metadata/QmXyz123.json
```

- The NFT’s metadata is stored off-chain, typically on IPFS or a centralized server.

**Step 4: Emit an Event**

```solidity
emit NFTMinted(_recipient, tokenId, _metadataCID);
```

- This logs the minting event on the blockchain, making it easy to track NFT creation.

### [NFTFactory Contract](./contract/src/NFTFactory.sol)

This contract creates and stores NFT collections. Think of it like a factory that produces NFT collections on demand.

#### 🔹 Summary of What This Contract Does

1. Allows users to create new NFT collections by calling `createNFTCollection()`.
2. Deploys a new instance of `NFTCollection.sol` each time.
3. Stores the collection’s details in an array.
4. Emits an event so blockchain explorers can track new collections.
5. Provides a function to retrieve all collections for easy access.

Here's the breakdown of each important code snippet:

#### 1️⃣ Importing NFTCollection.sol

```solidity
import "./NFTCollection.sol";
```

- This line imports another smart contract, `NFTCollection.sol`.
- The factory **depends on this contract** because it will create new NFT collections using it.
- Think of `NFTCollection.sol` as a blueprint for NFT collections.

#### 2️⃣ Defining the CollectionInfo Struct

```solidity
struct CollectionInfo {
    address collectionAddress;
    address creator;
    string name;
    string symbol;
    string baseURI;
}
```

- This defines a struct called CollectionInfo.
- A struct is a custom data type that groups multiple values together.
- Each NFT collection will have the following details:
  - `collectionAddress`: Where the collection lives on the blockchain.
  - `creator`: The person who created it.
  - `name`: Name of the NFT collection.
  - `symbol`: Short symbol (e.g., “NFTX”).
  - `baseURI`: The starting URL for NFT metadata.

#### 3️⃣ Storing All Created Collections

```solidity
CollectionInfo[] public collections;
```

- This is a dynamic array that stores all NFT collections created by the factory.
- Whenever a new collection is created, it will be added to this list.

#### 4️⃣ Emitting an Event When a Collection is Created

```solidity
event CollectionCreated(
    address indexed collectionAddress,
    address creator,
    string name,
    string symbol,
    string baseURI
);
```

- An event helps record information on the blockchain.
- Whenever a new collection is created, this event will log:
  - The collection’s address.
  - The creator’s address.
  - The name, symbol, and baseURI of the collection.
- This makes it easy to track NFT collections in off-chain apps like block explorers.

#### 5️⃣ Function to Create an NFT Collection

```solidity
function createNFTCollection(
    string memory _name,
    string memory _symbol,
    string memory _baseURI
) public {}
```

- This function creates a new NFT collection when someone calls it.
- It takes three inputs:
  - `_name`: The collection’s name.
  - `_symbol`: The collection’s short symbol.
  - `_baseURI`: The base URL for the metadata.

#### 6️⃣ Deploying a New NFT Collection

```solidity
NFTCollection newCollection = new NFTCollection(_name, _symbol, _baseURI, msg.sender);
```

- Here, the contract deploys a new NFT collection using the NFTCollection contract.
- It passes the `_name`, `_symbol`, `_baseURI`, and `msg.sender` (the creator).
- This means the person who calls the function owns the collection.

#### 7️⃣ Storing the Collection Details

```solidity
collections.push(CollectionInfo({
    collectionAddress: address(newCollection),
    name: _name,
    symbol: _symbol,
    baseURI: _baseURI,
    creator: msg.sender
}));
```

- After creating the collection, we store its details in the collections array.
- This way, anyone can see all collections ever created.

#### 8️⃣ Emitting the Event

```solidity
emit CollectionCreated(address(newCollection), msg.sender, _name, _symbol, _baseURI);
```

- The contract emits an event with the collection details.
- This helps keep a record of all created collections on the blockchain.

#### 9️⃣ Function to Get All Collections

```solidity
function getAllCollections() public view returns (CollectionInfo[] memory) {
    return collections;
}
```

- This function returns all created collections.
- It is public and view, meaning it does not modify blockchain data, just reads it.
- Useful for front-end apps that want to display all NFT collections.

This contract makes it super easy for anyone to launch an NFT collection without writing complex smart contracts!

## Tracking Multiple Contracts

## Dynamic Contract Tracking
