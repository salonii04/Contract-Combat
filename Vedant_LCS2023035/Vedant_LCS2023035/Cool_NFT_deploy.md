1. The smart_contract compiled and deployed on remix using `Injected Provider: Metamask`. During deployment the initial owner is set to my address => "0x04EbE25a9048F07dB3ae055030fD16EB1F05ca24".
2. Before minting , the NFT is created on `Pinata` using `IPFS` protocols . The image url as well as the metadata are stored on Pinata.
3. Then the created NFT is minted to a particular `address` suppose "0x04EbE25a9048F07dB3ae055030fD16EB1F05ca24" with `Token ID` as 0 and then `uri` as "ipfs://" . Each NFT created has a different `CID(Content Identifier)`.
4. There are additional features such as pause the NFT usage and burn the NFT.

## Network used : "Sepolia"