//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.4;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./core/NPass.sol";

/**
 * @title CheeseN contract
 * @author @0xQueso
 * @notice This contract allows n-project holders to mint an CheeseN
 */
contract CheeseN is NPass {
    using Strings for uint256;

    constructor(address _nContractAddress) NPass(_nContractAddress, "CheeseN", "CHEESEN", true) {}

    string constant CHEESE_CUT = '<svg xmlns="http://www.w3.org/2000/svg" version="1.1" x="0px" y="0px" viewBox="0 0 330 330"><rect width="100%" height="100%" fill="#F96A53"/><polygon points="40,259 277,259 277,148 40,174" fill="#E2B04D" stroke="#E2B04D" stroke-width="20" stroke-linejoin="round"/><polygon points="200,89 277,148 40,174" fill="#F4CD76" stroke="#F4CD76" stroke-width="20" stroke-linejoin="round"/>';
    string constant CHEESE_CLOSE = '</svg>';

    function joinString(string memory prefix, uint n, string memory close) public view virtual returns (string memory) {
        string memory property = string(abi.encodePacked(prefix, toString(n), close));

        return property;
    }

    function finalizeCircle(uint n, uint r, uint _cx, uint _cy) public view virtual returns (string memory) {

        string[5] memory circle;
        circle[0] = '<circle ';
        circle[1] = joinString(' cx="', _cx, '"');
        circle[2] = joinString(' cy="', _cy, '"');
        circle[3] = joinString(' r="', r, '"');
        circle[4] = string(abi.encodePacked(' fill="', '#D89D30', '" />'));

        string memory output = string(abi.encodePacked(circle[0], circle[1], circle[2], circle[3], circle[4]));
        console.log('output',output);
        return output;
    }

    function getCxPosition(uint totalN, uint n, uint _max, uint _min) public view virtual returns (uint) {
        //        to offset and not overflow if the radius gets bigger;
        //        radius is calculated n + 5;
        _min = _min + n + 5;
        // number to be used for position;
        uint computed = totalN + n + _min * 8888;


        console.log("init position cx", computed);
        uint modulo = _max - _min;

        uint pos = uint(keccak256(abi.encodePacked(uint (computed)))) % modulo;
        console.log('position x', pos);
        pos += _min;
        console.log("position cx", pos);
        return pos;
    }

    function getCyPosition(uint totalN, uint _top, uint _bot,  uint n) public view virtual returns (uint) {
        uint computed = totalN + n + _bot * 8888;
        console.log("position cy", computed);
        uint modulo = _bot - _top;

        uint pos = uint(keccak256(abi.encodePacked(uint (computed)))) % modulo;
        pos += _top;
        console.log("position cy", pos);
        return pos;
    }

    function tokenSVG(uint256 tokenId) public view virtual returns (string memory) {
        //        first 3 red dot till blue
        //        purple rare
        //        green bottom purple and so on.
        uint[8] memory ns;
        ns[0] = n.getFirst(tokenId);
        ns[1] = n.getSecond(tokenId);
        ns[2] = n.getThird(tokenId);
        ns[3] = n.getFourth(tokenId);
        ns[4] = n.getFifth(tokenId);
        ns[5] = n.getSixth(tokenId);
        ns[6] = n.getSeventh(tokenId);
        ns[7] = n.getEight(tokenId);

        uint n = 11;
        uint totalN = 0;
        uint r = n + 5;

        for (uint i = 0; i < ns.length; i++) {
            totalN += ns[i];
        }
        string memory tempDes = "";

        for (uint i = 0; i < 5; i++) {
            console.log('got pass', ns[i]);
            tempDes = string(abi.encodePacked(tempDes,
                finalizeCircle(ns[i],
                ns[i] + 5,
                getCxPosition(totalN,  ns[i], 275, 52),
                getCyPosition(totalN, 170, 260, ns[i]))));
        }

        if (31 < totalN && totalN <= 40) {
            //
            tempDes = string(abi.encodePacked(tempDes,
                finalizeCircle(ns[5],
                ns[5] + 5,
                getCxPosition(totalN,  ns[5], 275, 85),
                getCyPosition(totalN, 130, 150, ns[5]))));

            console.log('low uncommon');
        }
//        else if (41 < totalN && totalN <= 50) {
//            //
//            tempDes = string(abi.encodePacked(tempDes,
//                finalizeCircle(ns[5],
//                ns[5] + 5,
//                getCxPosition(totalN,  ns[5], 275, 85),
//                getCyPosition(totalN, 130, 150, ns[5]))));
//
//            console.log('common');
//        } else if (51 < totalN && totalN <= 60) {
//            //
//            tempDes = string(abi.encodePacked(tempDes,
//                finalizeCircle(ns[5],
//                ns[5] + 5,
//                getCxPosition(totalN,  ns[5], 275, 85),
//                getCyPosition(totalN, 130, 150, ns[5]))));
//
//            console.log('high uncommon');
//        }
        else {
            tempDes = string(abi.encodePacked(tempDes,
                finalizeCircle(ns[5],
                ns[5] + 5,
                getCxPosition(totalN,  ns[5], 275, 85),
                getCyPosition(totalN, 130, 150, ns[5]))));
            console.log('rare');
        }

        string memory outputSvg = string (abi.encodePacked(CHEESE_CUT, tempDes, CHEESE_CLOSE));

        console.log('output svg', outputSvg);
        return outputSvg;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        string memory output = tokenSVG(tokenId);

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "Cheese #',
                        toString(tokenId),
                        '", "description": "Cheese`N are generated and stored on chain using N tokens.", "animation_url" : "https://gateway.pinata.cloud/ipfs/QmY7ZR6v6HeyA42asmSTf5KxhFz13k9fTuXFPQcKQLezg3/', toString(tokenId) , '.html"' , ', "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(output)),
                        '", "attributes": [{"trait_type": "Bug", "value": "',
                        'fly',
                        '"}]}'
                    )
                )
            )
        );
        output = string(abi.encodePacked("data:application/json;base64,", json));

        return output;
    }


    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT license
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}

/// [MIT License]
/// @title Base64
/// @notice Provides a function for encoding some bytes in base64
/// @author Brecht Devos <brecht@loopring.org>
library Base64 {
    bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    /// @notice Encodes some bytes to the base64 representation
    function encode(bytes memory data) internal pure returns (string memory) {
        uint256 len = data.length;
        if (len == 0) return "";

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((len + 2) / 3);

        // Add some extra buffer at the end
        bytes memory result = new bytes(encodedLen + 32);

        bytes memory table = TABLE;

        assembly {
            let tablePtr := add(table, 1)
            let resultPtr := add(result, 32)

            for {
                let i := 0
            } lt(i, len) {

            } {
                i := add(i, 3)
                let input := and(mload(add(data, i)), 0xffffff)

                let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
                out := shl(224, out)

                mstore(resultPtr, out)

                resultPtr := add(resultPtr, 4)
            }

            switch mod(len, 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }

            mstore(result, encodedLen)
        }

        return string(result);
    }
}
