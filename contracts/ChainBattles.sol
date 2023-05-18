// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage{
    //Allows our unint256 to be able to easily convert to strings
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private s_tokenIds;

    mapping(uint256 => uint256) public tokenIdtoLevels;

    //Calling the ERC721 constructor
    constructor() ERC721("Chain Battle", "CBTLS"){


    }



    //remember memory -> doesn't save the string that is returned, solidity just remembers it for the duration of the function
    function generateCharacter(uint256 tokenId) public returns (string memory){
        //Edit the text area of the svg to edit the text shown on the nft
        bytes memory svg = abi.encodePacked('<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
        '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
        '<rect width="100%" height="100%" fill="black" />',
        '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getLevels(tokenId),'</text>',
        '</svg>'
        );

        return string(
        abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(svg) //From Openzepplin. Used to convert to string
        )    
    );
    }

    function getLevels(uint256 tokenId) public view return(string memory){
        uint256 levels = tokenIdtoLevels[tokenId]
        //From the import and line "using Strings for uint256 - allows us to change uint256 to string type"
        return levels.toString()
    }

    //Allows opensea to know what we are miniting
    function getTokenURI(uint256 tokenId) public returns (string memory){
    bytes memory dataURI = abi.encodePacked(
        '{',
            '"name": "Chain Battles #', tokenId.toString(), '",',
            '"description": "Battles on chain",',
            '"image": "', generateCharacter(tokenId), '"',
        '}'
    );
    return string(
        abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(dataURI)
        )
    );

    function mint() public{
        s_tokenIds.increment();
        uint256 newItemId = s_tokenIds.current();
        _safemint(msg.sender, newItemId);
        tokenIdtoLevels[newItemId] = 0
        //Provided by ERC721 standard
        _setTokenURI(newItemId, getTokenURI(newItemId))
    }

    //dynamic stuff that will change the nft we are interacting with
    function train(uint256 tokenId) public {
        //Check that the token id exists
        require(_exists(tokenId), "Please use an existing Token");
        //Only the person who owns the token should be able to train the nft
        require(ownerOf(tokenId) == msg.sender, "You must own this token to train it")  

        uint256 currentLevel = tokenIdtoLevels[tokenId];
        tokenIdtoLevels[tokenId] = currentWins + 1;
        //will generate a new token uri after levels increases
        _setTokenURI(tokenId, getTokenURI(tokenId));

    }

}

//Big idea use abi.ecode to save a svg image text as bytes and store it on contract. Then when the nft is displayed it will display the svg item