// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {

    // errors
    error MoodNft__CantFlipMoodIfNotOwner();

    uint256 public s_tokenCounter;
    string private s_sadSVGImageURI;
    string private s_happySVGImageURI;
    mapping(uint256 => Mood) private s_tokenIdToMood;

    

    enum Mood {
        HAPPY,
        SAD
    }

    function flipMood(uint256 tokenId) public {
        // only want the NFT owner or a approve person to be able to change the mood
        if ((ownerOf(tokenId) != msg.sender) || !_isAuthorized(ownerOf(tokenId), msg.sender, tokenId)) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    constructor(
        string memory sadSVGImageURI,
        string memory happySVGImageURI
    ) ERC721("Mood NFT", "MOOD") {
        s_tokenCounter = 0;
        s_sadSVGImageURI = sadSVGImageURI;
        s_happySVGImageURI = happySVGImageURI;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId)  public view override returns (string memory) {
        string memory imageURI;
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySVGImageURI;
        } else {
            imageURI = s_sadSVGImageURI;
        }

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes( // bytes casting actually unnecessary as 'abi.encodePacked()' returns a bytes
                        abi.encodePacked(
                            '{"name":"',
                            name(), // You can add whatever name here
                            '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                            '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        );

    }


    // getter

}
