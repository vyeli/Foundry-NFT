// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodNft is Script {
    function run() external returns (MoodNft){
        string memory sadSVG = vm.readFile("./img/sad.svg");
        string memory happySVG = vm.readFile("./img/happy.svg");

        vm.startBroadcast();
        console.log(svgToImageURI(happySVG));
        MoodNft moodNft = new MoodNft(svgToImageURI(sadSVG), svgToImageURI(happySVG));
        vm.stopBroadcast();
        return moodNft;
    }

    function svgToImageURI(
        string memory svg
    ) internal pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
        return string.concat(baseURL, svgBase64Encoded);
    }
}
