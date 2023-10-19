// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import "library/ReentrancyGuard.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

interface GasRouter{
    function quoteGasPayment(uint32 _destinationDomain)
        external
        view
        returns (uint256 _gasPayment);
}

interface TokenRouter is GasRouter {
  function transferRemote(
        uint32 _destinationDomain,
        bytes32 _recipientAddress,
        uint256 _amountOrId // amount in wei
    ) external payable returns (bytes32 messageId);
}

interface IHypERC20 is TokenRouter{ // can be ERC20 collateral from origin chain or HypERC20 in synthetic chain

    function _transferFromSender(uint256 _amount) // will wrap original ERC20
        external
        returns (bytes memory);

    function _transferTo(
        address _recipient,
        uint256 _amount,
        bytes calldata // no metadata
    ) external;
    
}

contract HypERC20TransferCengli is ReentrancyGuard{
    address public USDCAddress;
    address public HypERC20Address;
    address public owner; // testing purposes

    event SentTransferRemote(
        bytes32 messageId,
        uint32 indexed destination,
        bytes32 indexed recipient,
        uint256 amount
    );

    constructor(address _USDCAddress, address _HypERC20Address){
        USDCAddress = _USDCAddress;
        HypERC20Address = _HypERC20Address;
        IERC20(USDCAddress).approve(HypERC20Address, 100000000e6); // approve HypERC20 router spending USDC of this contract

        owner = msg.sender;
        IERC20(USDCAddress).approve(owner, 100000000e6); // approve owner spending of USDC in this contract, emergency case only, testnet purposes
    }

    receive() external payable {}
    
    // user/sender must approve allowance of USDC for this contract before able to successfully call this function
    function transferXchainHypERC20(uint32 _destinationDomain, bytes32 _recipientAddress, uint256 _amount) nonReentrant external returns (bytes32) {
        require(IERC20(USDCAddress).balanceOf(msg.sender) >= _amount, "Insufficient USDC balance of sender.");
        IERC20(USDCAddress).transferFrom(msg.sender, address(this), _amount); // contract holds USDC

         // Get the required gas payment
        uint256 quote = IHypERC20(HypERC20Address).quoteGasPayment(
            _destinationDomain
        );
        require(address(this).balance >= quote, "Insufficient native token for gas inside contract.");
        
        bytes32 messageId = IHypERC20(HypERC20Address).transferRemote{value:quote}(_destinationDomain, _recipientAddress, _amount);
        emit SentTransferRemote(messageId, _destinationDomain, _recipientAddress, _amount);

        return messageId;
    }

    // owner functions
    function withdrawUSDC() external onlyOwner {
        require(IERC20(USDCAddress).balanceOf(address(this)) != 0, "Contract has 0 USDC.");
        IERC20(USDCAddress).transfer(owner, IERC20(USDCAddress).balanceOf(address(this)));
    }

    function withdrawNative() external onlyOwner {
        require(address(this).balance != 0, "Contract has 0 Native.");
        payable(msg.sender).transfer(address(this).balance);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

}