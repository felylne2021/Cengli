// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/metatx/ERC2771Forwarder.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CengliRelayer is Ownable {
    ERC2771Forwarder private forwarder;

    constructor(address forwarderAddress) {
        forwarder = ERC2771Forwarder(forwarderAddress);
        transferOwnership(msg.sender);
    }

    function executeMetaTransaction(
        ERC2771Forwarder.ForwardRequest calldata request,
        bytes calldata signature
    ) external returns (bytes memory) {
        return forwarder.execute(request, signature);
    }

    function sweepTokens(IERC20 token, address to) external onlyOwner {
        token.transfer(to, token.balanceOf(address(this)));
    }

    function sweepEther(address payable to) external onlyOwner {
        uint256 balance = address(this).balance;

        require(balance > 0, "CengliRelayer: no ether to sweep");
        to.transfer(balance);
    }

    function getChainId() external view returns (uint256) {
        return block.chainid;
    }
}
