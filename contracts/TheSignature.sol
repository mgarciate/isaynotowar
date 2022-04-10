// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC721.sol";
import "./ERC20.sol";
import "./utils/Base64.sol";

/*
~~ The Signature ~~
by Simon de la Rouviere (@simondlr)

A conceptual art project that emphasises the provenance of an NFT.
All pieces look the same. Anyone can mint a "signature" at any time (only pay gas). No restrictions. Uncapped supply.
The only way they differ is when it was minted & by whom. Over time, if transferred, a piece will attract more signatures from more holders.

It's all about the signature. Just follow it.

The on-chain SVG image produced is licensed as CC0.
You can copy, modify, distribute and perform the work, even for commercial purposes, all without asking permission.
*/

/**
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
 * the Metadata extension, but not including the Enumerable extension, which is available separately as
 * {ERC721Enumerable}.
 */
contract TheSignature is ERC721 {

    address public owner = 0x0; // for opensea integration. doesn't do anything else.
    address payable _recipient = payable(0x0);

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor (string memory name_, string memory symbol_) ERC721(name_, symbol_) {
        _mintSignature(owner);
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory name = "I say no to War"; 
        string memory description = "I say no to war is a project inspired and forked from the conceptual art project The Signatures by Simon de la Rouviere. It's not only aimed to raise funds for the humanitarian action of Unchain.fund to relieve our Ukrainian brothers and sisters suffering, but to be the first web3 signatures collection, against war, and show the world a massive amount of inmutable signatures as onchain svg's forever in the Ethereum blockchain. There is no capped supply as opposition to war should not have a cap, everyone can mint their proofs of opposition to war just paying the gas or attach an amount in ETH to unchain's fund ETH multisig, hardcoded in the NFT contract. As in Simon's project , the importance of provenance and date in NFT's is what is really meaningful not the image itselt , and in this case stamping our big no to war forever.";

        string memory imageUrl = "https://ipfs.io/ipfs/QmdeVeLGtZmw6TFU3PzK5CQ4YK1Za3hACdFZj7ugwdEYmA";
        return string(
            abi.encodePacked(
                'data:application/json;base64,',
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"', 
                            name,
                            '", "description":"', 
                            description,
                            '", "image": "',
                            imageUrl,
                            '"}'
                        )
                    )
                )
            )
        );
    }

    function generateBase64Image() public pure returns (string memory) {
        bytes memory img = bytes(generateImage());
        return Base64.encode(img);
    }

    function generateImage() public pure returns (string memory) {
        return string(
            abi.encodePacked(
                '<svg xmlns="http://www.w3.org/2000/svg" width="1493.338" height="1493.338" viewBox="0 0 1400 1400"><path stroke="#000" d="M616 933c-5.84-2.04-18.74 2.17-26 1.79-17.08-.88-36.78-6.12-53-11.62-10.97-3.72-23.77-10.08-32.72-17.46-8.87-7.33-23.1-22.32-28.02-32.71-9.92-20.91 1.82-41.48 17.74-55.27 4.92-4.27 9.61-8.81 15-12.51 20.47-14.08 59.06-27.78 84.01-28.65l25.99.6 7.71 1.35 22.29 1.67c6.36.23 16.59-2.28 16-10.19l-9 2.75c-12.41 2.25-26.61-1.98-38.83-2.53-26.58-1.22-47.1.46-72.17 10.33-7.88 3.1-25.43 8.66-30 15.45-6.3.62-14.97 7.71-20 11.67-5.93 4.67-16.99 16.02-21.03 22.42-1.29 2.05-3.12 6.53-4.07 8.91-4.61 11.53-6.22 22.16-1.27 34 6.53 15.64 26.98 36.73 41.37 45.54 9.75 5.96 28.77 13.66 39.91 16.59l10.66 1.87 5.02 1.57c8.68 2.09 25.46 3.83 34.45 3.11l7.96-1.5c8.37-1.1 22.2-3.49 30.09-6.08l7.91-3.35 11-4.3c26.73-12.54 57.13-35.24 75.33-58.45 11.83-15.07 17.15-28.37 23.72-46 3.39-9.11 6.89-18.45 8.85-28l1.18-10 2.75-17c2.05-19.62-1.05-46.32-7.44-65-3.02-8.83-13.92-27.46-19.63-35-24.7-32.65-58.61-47.31-95.76-60.95-16.45-6.03-35.01-9.5-45.33-25.05-2.56-3.86-3.75-7.67-5.12-12-1.43-4.5-2.1-6.07-2.21-11-.22-9.58 3.95-23.49 8.29-32 14.85-29.17 42.97-47.03 74.46-53.57l8.91-2.27 35.46-4.36c4.39.19 14.55 3.38 17.25 2.01 1.5-.76 1.57-1.57 2.29-2.81-2.52-1.82-4.99-3.9-7.96-4.74-4.25-1.64-25.15-.66-30.13 0l-7.91 1.83c-4.05.41-8.05.58-12 1.69l-6 1.85-7 1.13c-7.88 2.03-15.73 5.7-23 9.28l-10 4.84c-18.4 10.68-32.96 26.41-41.14 46.12-4.51 10.87-9.26 25.09-6.83 37 1.53 7.48 7.65 21.61 13.07 26.87 11.83 11.47 38.31 18.68 53.9 24.86 14.74 5.84 43.19 18.88 55.08 28.41l5.09 4.85 13.75 12.14c6.53 6.24 11.33 14.09 15.78 21.87 14.15 24.76 17.39 43.85 17.58 72 .08 11.31-.74 8.4-1.99 18l-.72 9-5.1 23c-3.19 12.43-12.08 35.45-19.01 45.99l-12.14 16.84c-4.34 5.06-21.72 21.18-27.32 25.71-11.97 9.68-33.67 23.46-48 28.93l-19 6.16c-4.07 1.03-9.7 1.81-13 4.37ZM284 662l20-16.32c14.33-9.74 19.82-11.02 35-17.72l8-3.87c29.18-11.85 59.67-21.5 89.73-30.85l18.31-5.12 5.96-2.45 42.01-11.83c18.65-7.65 34.8-11.64 52.99-21.7 3.47-1.92 15.76-10.27 10.25-15.22-4.26-3.82-5.5 3.34-14.25 8.38-11.61 6.7-24.35 11.45-37 15.84l-13 4.16-56 16.44-35.72 12.24-16.28 4.76-31 11.37-20 7.35-13 6.12c-4.9 2.1-19.94 9.41-23.83 12.14L294 645.58c-5.58 4.36-11.78 8.53-10 16.42Zm144 57c5.47-5.53 7.23-16.62 9.59-24 6.75-21.15 13.97-54.96 12.96-77 .08-3.24.79-11.35 0-13.92-1.61-3.75-5.97-4.49-6.62 0V613c.11 24.25-5.11 48.36-10.05 72-1.93 9.24-8.08 25.12-5.88 34Zm44-45c-5.14 5.38-11.14 10.7-13.7 18-1.32 3.76.06 8.17 4.7 7.12 5.81-1.32 12.74-13.01 18-17.12 1.9 2.35 2.02 2.09 5 2 2.24 3.26 10.15 5.89 14 7.99 15.71 8.57 21.41 16.58 41 12.68 14.97-2.99 27.88-16.69 19-31.67-5.66 6.23-2.59 10.36-6.7 15.89-2.09 2.81-4 3.28-6.88 4.78-9.65 5.06-16.84 4.07-27.42 3.33 6.31-7.89 11.41-11.95 12.52-23 .74-7.38-4.67-11.93-11.52-8.07-4.03 2.28-7.68 7.09-9.96 11.07-1.07 1.87-2.77 6.13-4.45 7.19-2.25 1.41-4.5-.14-6.59-1.02-3.85-1.63-14.44-3.51-13.99-9.26.2-2.59 6.85-13.87 8.39-16.91l10.99-28c.98-3.34 4.56-13.7 0-15.83-5.49-2.77-7.48 10.72-8.21 13.83l-7.7 22-7.07 13c-2.19 4.24-4.53 10.51-9.41 12Zm53-2c-1.72 7.36-3.66 14.79-11 18 .19-7.77 2.89-15.6 11-18Zm-18 14v1l-1-1h1Zm472 31-1 9-21-1.74c-3.42-.78-9.67-2.67-12.79-.57-2.53 1.7-4.93 6.42-.56 7.82l7.63.63c11.25 1.93 13.87 2.86 25.72 2.86-6.37 12.58-10.45 34.17-25 40 .44-3.63 1.37-7.88-2.22-10.59-1.06-.48-2.25-.81-3.47 0-2.95 1.14-1.84 5.9-2.91 8.4-2.65 6.21-9.51 4.96-14.4 3.19 1.88-3.85 2.82-8.4 6.62-10.87 4.82-3.12 11.46-2.47 11.84-7.14.41-5.01-6.5-4.1-9.46-3.19-7.2 2.22-11.3 7.07-13 14.2-10.17-3.99-13.92-16.31-24-15.11-6.44.77-11.85 10.66-13.9 16.11-1.39 2.81-2.46 6.21 0 8.58 2.89 2.35 5.56.49 7.51-1.69 3.44-3.87 6.09-10.8 5.39-15.89 7.79 2.02 9.26 5.85 15 10.79l6.7 5.41c2.28 2.26 3.51 4.57 6.47 6.22 7.11 3.93 13.51-1.05 16.7-2 3.44-.97 5.28.78 8.64 0 5.27-1.3 9.82-6.71 13.49-10.42.07 7.58 1.69 14.27 7.62 19.57 6.57 5.88 16.66 3.1 20.38-4.57 4.1 3.44 7.83 5.63 13 2.4 2.07-1.29 4.54-4.27 6.58-4.78 2.14-.54 4.16 1.57 7.7.8 3.21-.71 9.69-5.46 12.72-7.42-1.76 4.08-3.8 7.74 2 9 1.96 4.53 4.7.79 6.16-2.02 2.38-4.56 2.94-11.03 1.84-15.98 4.37.89 10.61 3.65 12.4 8.09 1.15 2.85-.14 6.05 2.34 9.89 3.42 5.29 11.34 7.14 17.26 7.38 6.92.28 26.57-5.43 32.99-8.54 5.33-2.59 10.3-7.96 3.01-11.82-4.37 7.03-11.47 7.89-19 9.88-9.78 2.6-22.44 8.62-29-2.88 7.68 1.25 10.19 3.22 17.99-.75 6.93-3.53 13.82-14.3 13.73-22.25-.03-2.76-1-4.83-2.95-6.58-5.11-5.3-10.5-2.99-15.77 0-3.7 2.43-6.29 4.28-9.33 7.38-4.37 4.45-5.37 6.57-7.67 12.2h-2c-1.05-2.23-1.41-3.06-3.14-4.96-.96-1.07-2.67-2.63-3.86-3.43-8.29-5.55-14.25 4.99-17.45 7.91-3.24 2.95-10.19 6.67-14.62 7.48v-7.58c.12-3.98 1.68-7.68.92-12.4-.71-4.5-4.03-5.45-6.09-3.4-2.38 2.37-1.11 8.5-2.03 12.38-1.71 7.22-4.94 12.46-9.73 18l2.42-9.83V757l-3.42-5c-10.44 8.22-4.17 24.51-12.3 31.68-3.12 2.75-10.01 2.95-12.39-.92-.95-1.55-1.46-4.91-1.71-6.76-1.77-13.24 6.44-30.68 7.4-40l20 1c3.58-.02 9.17-.18 10.83-4.17 1.32-3.18-2.18-5.37-4.83-5.86h-23c1.58-2.85 3.79-8.64 3.67-11.95-.2-5.39-4.11-4.36-7.09-1.67L979 717Zm-163 24c-.98-1.13-1.57-2.22-3.02-2.83-4.86-1.93-4.73 5.66 0 4.52 1.38-.32 2.04-1.07 3.02-1.69Zm36 19c1.66 4.55 2.6 11.14 2.6 16v5l1.08 5v5l2.48 8.42 3.42 31.58c.34 6.2-.68 12.86-1.4 19-.4 3.33-.23 6.1-1.27 9.42-1.66 5.34-4.35 14.4-8.08 18.37-3.81 4.05-8.52 1.32-9.83 7.21-8.06.35-12.27-4.23-17.27-10-9.12-10.53-14.77-22.45-20.52-35-3.58-7.89-7.56-15.67 0-22.73 7.09-6.67 25.07-11.19 34.79-13.1 7.38-1.45 12.83 1.14 17-7.17-13.04-3.25-36.01 3.15-48 8.63-6.54 2.99-12.55 7.22-14.98 14.37-3.19 9.36 1.83 18.1 6.08 26l3.59 8c5.05 10.78 9.42 18.06 17.48 27 4.45 4.93 10.04 10.17 16.83 11.43 14.41 2.68 27-13.8 29.3-26.34l3.34-13.09v-41.72L865.66 792l-1.89-7.59L861.1 765c-.39-2.94-1.74-9.52-3.68-11.68-2.68-2.98-6.94-1.38-10.42-1.27-9.88.29-20.46 6.1-26.47 13.95-2.5 3.27-5.15 7.86-2.64 11.87 2.77 4.39 8.8 4.73 13.11 2.69 6.4-3.03 17.74-14.28 21-20.56Zm-50-7c-3.71 5.44-6.62 14.35-6.9 21-.09 2.1-.11 6.8 2.99 6.8 3.08 0 4.34-4.47 4.89-6.8 1.57-6.58 4.3-15.65-.98-21Zm288 2c-1.72 12.97-9.11 21.95-23 18 3.71-9.38 11.79-20.18 23-18Zm-244 3c-5.41 8.52-11.63 16.12-22 18 .83-10.32 12.71-16.54 22-18Z"/></svg>'
            )
        );
    }

    function mintAndDonate() public payable {
        if (msg.value > 0) {
            (bool success,) = _recipient.call{value: msg.value}("");
            require(success, "Failed to make donation");
        }
        _mintSignature(msg.sender);
    }

    function mintSignature() public {
        _mintSignature(msg.sender);
    }

    function _mintSignature(address _owner) internal {
        uint256 tokenId = uint(keccak256(abi.encodePacked(block.timestamp, _owner)));
        super._mint(_owner, tokenId);
    }

    /// @notice The `escapeHatch()` should only be called as a last resort if a
    /// security issue is uncovered or something unexpected happened
    /// @param _token to transfer, use 0x0 for ether
    function escapeHatch(address _token) public {
        uint256 balance;

        /// @dev Logic for ether
        if (_token == address(0x0)) {
            balance = address(this).balance;
            _recipient.transfer(balance);
            emit EscapeHatchCalled(_token, balance);
            return;
        }
        /// @dev Logic for tokens
        ERC20 token = ERC20(_token);
        balance = token.balanceOf(address(this));
        require(token.transfer(_recipient, balance),"err_escapableTransfer");
        emit EscapeHatchCalled(_token, balance);
    }

    event EscapeHatchCalled(address token, uint amount);
}