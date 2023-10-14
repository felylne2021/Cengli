// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC2771Context} from "@openzeppelin/contracts/metatx/ERC2771Context.sol";

contract TestContract is ERC2771Context {
    address public flagCapturer;

    function captureFlag() public payable {
        require(msg.value == 0.01 ether, "Must pay 0.01 ether");

        flagCapturer = msg.sender;
    }

    function withdraw() public {
        require(msg.sender == flagCapturer, "Only flag capturer can withdraw");

        payable(msg.sender).transfer(address(this).balance);
    }

    constructor(address trustedForwarder) ERC2771Context(trustedForwarder) {}
}
