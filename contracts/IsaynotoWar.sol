// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC721.sol";
import "./ERC20.sol";
import "./utils/Base64.sol";

/*
~~ I say no to War ~~
I say no to war is a project inspired and forked from the conceptual art project "The Signatures" by Simon de la Rouviere

It's not only aimed to raise funds for the humanitarian action of Unchain.fund to relieve our Ukrainian brothers and sisters suffering, but to be the first web3 signatures collection, against war, and show the world a massive amount of inmutable signatures as onchain svg's forever in the Ethereum blockchain. 

There is no capped supply as opposition to war should not have a cap, everyone can mint their proofs of opposition to war just paying the gas or attach an amount in ETH to unchain's fund ETH multisig, hardcoded in the NFT contract. 

As in Simon's project , the importance of provenance and date in NFT's is what is really meaningful not the image itselt , and in this case stamping our big no to war forever.
*/

/**
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
 * the Metadata extension, but not including the Enumerable extension, which is available separately as
 * {ERC721Enumerable}.
 */
contract IsaynotoWar is ERC721 {

    address public owner = 0x0; // for opensea integration. doesn't do anything else.
    address payable _recipient = payable(0x10E1439455BD2624878b243819E31CfEE9eb721C); // Unchain.fund address

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

    function mintSignatureAndDonate() public payable {
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