// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title CengliP2PEscrow - Peer to peer escrow contract for Cengli
/// @author YourName
/// @notice This contract facilitates a P2P exchange between a buyer and a partner.
/// @dev All function calls are currently implemented without side effects
contract CengliP2PEscrow is Ownable {
    /// @notice Order status enumeration for better tracking and logic handling
    enum OrderStatus {
        NONE,
        WFBP,
        CANCEL,
        COMPLETE
    }

    /// @notice Struct to hold the order data
    struct Order {
        address buyer;
        address partner;
        address token;
        uint256 amount;
        OrderStatus status;
    }

    // constructor
    constructor(address initialOwner) Ownable(initialOwner) {}

    /// @notice Counter to generate unique order IDs
    uint256 public orderIdCounter = 1;

    /// @notice Mapping to hold the orders
    mapping(uint256 => Order) public orders;

    /// @notice Event emitted whenever an order is updated
    event OrderUpdated(uint256 indexed orderId, OrderStatus newStatus);

    /// @notice Accepts a new order or updates an existing one
    /// @dev Only callable by the contract owner
    /// @return uint256 The newly generated Order ID
    function acceptOrder(
        address buyer,
        address partner,
        address token,
        uint256 amount
    ) external onlyOwner returns (uint256) {
        uint256 newOrderId = orderIdCounter++;

        IERC20 erc20Token = IERC20(token);
        require(
            erc20Token.transferFrom(partner, address(this), amount),
            "Token transfer failed"
        );

        orders[newOrderId] = Order(
            buyer,
            partner,
            token,
            amount,
            OrderStatus.WFBP
        );
        emit OrderUpdated(newOrderId, OrderStatus.WFBP);

        return newOrderId;
    }

    /// @notice Cancels an existing order
    /// @dev Only callable by the contract owner
    /// @param orderId Unique identifier for the order
    function cancelOrder(uint256 orderId) external onlyOwner {
        require(
            orders[orderId].status == OrderStatus.WFBP,
            "Invalid order status"
        );

        Order storage order = orders[orderId];
        IERC20 erc20Token = IERC20(order.token);
        require(
            erc20Token.transfer(order.partner, order.amount),
            "Token return failed"
        );

        order.status = OrderStatus.CANCEL;
        emit OrderUpdated(orderId, OrderStatus.CANCEL);
    }

    /// @notice Releases the escrowed funds to the buyer
    /// @dev Only callable by the contract owner
    /// @param orderId Unique identifier for the order
    function releaseFunds(uint256 orderId) external onlyOwner {
        require(
            orders[orderId].status == OrderStatus.WFBP,
            "Invalid order status"
        );

        Order storage order = orders[orderId];
        IERC20 erc20Token = IERC20(order.token);
        require(
            erc20Token.transfer(order.buyer, order.amount),
            "Token transfer failed"
        );

        order.status = OrderStatus.COMPLETE;
        emit OrderUpdated(orderId, OrderStatus.COMPLETE);
    }

    /// @notice Fetches the details of an order
    /// @param orderId The ID of the order
    /// @return buyer The buyer's address
    /// @return partner The partner's address
    /// @return token The ERC20 token address used for the payment
    /// @return amount The amount escrowed
    /// @return status The status of the order
    function getOrder(
        uint256 orderId
    )
        external
        view
        returns (
            address buyer,
            address partner,
            address token,
            uint256 amount,
            OrderStatus status
        )
    {
        Order storage order = orders[orderId];
        return (
            order.buyer,
            order.partner,
            order.token,
            order.amount,
            order.status
        );
    }
}