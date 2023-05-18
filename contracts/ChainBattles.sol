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

}