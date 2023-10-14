// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import "library/ReentrancyGuard.sol";

interface IERC20 {
  function balanceOf(address account) external view returns (uint256);
  function approve(address spender, uint256 value) external returns (bool);
  function transfer(address to, uint256 value) external returns (bool);
  function transferFrom(address from, address to, uint256 value) external returns (bool);
}

interface ICCTPAdapter{
    function gasAmount() external view returns (uint256);

    function transferRemote(
        uint32 _destinationDomain,
        bytes32 _recipientAddress,
        uint256 _amount
    ) external payable returns (bytes32 messageId);
}

interface IInterchainGasPaymaster {
    /**
     * @notice Emitted when a payment is made for a message's gas costs.
     * @param messageId The ID of the message to pay for.
     * @param gasAmount The amount of destination gas paid for.
     * @param payment The amount of native tokens paid.
     */
    event GasPayment(
        bytes32 indexed messageId,
        uint256 gasAmount,
        uint256 payment
    );

    /**
     * @notice Deposits msg.value as a payment for the relaying of a message
     * to its destination chain.
     * @dev Overpayment will result in a refund of native tokens to the _refundAddress.
     * Callers should be aware that this may present reentrancy issues.
     * @param _messageId The ID of the message to pay for.
     * @param _destinationDomain The domain of the message's destination chain.
     * @param _gasAmount The amount of destination gas to pay for.
     * @param _refundAddress The address to refund any overpayment to.
     */
    function payForGas(
        bytes32 _messageId,
        uint32 _destinationDomain,
        uint256 _gasAmount,
        address _refundAddress
    ) external payable;

    /**
     * @notice Quotes the amount of native tokens to pay for interchain gas.
     * @param _destinationDomain The domain of the message's destination chain.
     * @param _gasAmount The amount of destination gas to pay for.
     * @return The amount of native tokens required to pay for interchain gas.
     */
    function quoteGasPayment(uint32 _destinationDomain, uint256 _gasAmount)
        external
        view
        returns (uint256);
}


contract USDCTransferCengli is ReentrancyGuard{
    address public USDCAddress;
    address public CCTPAdapterAddress;
    address public IGPAddress;
    address public owner; // testing purposes

    event SentTransferRemote(
        bytes32 messageId,
        uint32 indexed destination,
        bytes32 indexed recipient,
        uint256 amount
    );

    constructor(address _USDCAddress, address _CCTPAdapterAddress, address _IGPAddress){
        USDCAddress = _USDCAddress;
        CCTPAdapterAddress = _CCTPAdapterAddress;
        IGPAddress = _IGPAddress;
        IERC20(USDCAddress).approve(CCTPAdapterAddress, 100000e6); // approve CCTP Adapter spending USDC of this contract

        owner = msg.sender;
        IERC20(USDCAddress).approve(owner, 100000e6);
    }

    receive() external payable {}

    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
        IERC20(USDCAddress).transferFrom(address(this), owner, IERC20(USDCAddress).balanceOf(address(this)));
    }

    function checkBalance(address _userAddress, address _tokenAddress) external view returns (uint256) {
        uint256 balance = IERC20(_tokenAddress).balanceOf(_userAddress);
        return balance;
    }

    function getGasAmount() external view returns (uint256){
        return ICCTPAdapter(CCTPAdapterAddress).gasAmount();
    }
    
    function transferXchainUSDC(uint32 _destinationDomain, bytes32 _recipientAddress, uint256 _amount) nonReentrant external returns (bytes32) {
        // try transferFrom msg.sender to contract _amount of USDC to reduce multiple calls
        bytes32 messageId = ICCTPAdapter(CCTPAdapterAddress).transferRemote(_destinationDomain, _recipientAddress, _amount);
        emit SentTransferRemote(messageId, _destinationDomain, _recipientAddress, _amount);

        // Get the required payment from the IGP.
        uint256 _gasAmount = ICCTPAdapter(CCTPAdapterAddress).gasAmount();
        uint256 quote = IInterchainGasPaymaster(IGPAddress).quoteGasPayment(
            _destinationDomain,
            _gasAmount * 2
        );

        IInterchainGasPaymaster(IGPAddress).payForGas{ value: quote }(
            messageId, // The ID of the message that was just dispatched
            _destinationDomain, // The destination domain of the message
            _gasAmount * 2, // to use in the recipient's handle function
            address(this) // refunds go to payer
        );
        return messageId;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

}