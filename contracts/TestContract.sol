// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC2771Context} from "@openzeppelin/contracts/metatx/ERC2771Context.sol";

contract TestContract is ERC2771Context {
    address public flagCapturer;

    function captureFlag() public payable {
        flagCapturer = _msgSender();
    }

    function withdraw() public {
        require(_msgSender() == flagCapturer, "Only flag capturer can withdraw");
        payable(_msgSender()).transfer(address(this).balance);
    }

    constructor(address trustedForwarder) ERC2771Context(trustedForwarder) {}
}
