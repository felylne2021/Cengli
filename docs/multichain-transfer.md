# Multi-Chain Token Transfer API Documentation

## Overview

This API enables multi-chain token transfer functionalities including bridge information retrieval, token approvals, and transaction preparations for two types of routes: Hyperlane WARP and Hyperlane CCTP.

---

## Endpoints

### 1. Get Bridge Info

#### Request

`GET /transfer/bridge?fromChainId={fromChainId}&destinationChainId={destinationChainId}&tokenAddress={tokenAddress}`

##### Parameters

- `fromChainId`: Source chain ID (e.g., 43113)
- `destinationChainId`: Destination chain ID (e.g., 80001)
- `tokenAddress`: Token contract address (e.g., 0x5425890298aed601595a70AB815c96711a31Bc65)

#### Response

- `route`: Route type (e.g., "Hyperlane Warp")
- `route_type`: Internal route type identifier
- `description`: Route description
- `fromBridgeAddress`: Bridge address in the source chain
- `destinationBridgeAddress`: Bridge address in the destination chain

##### Warp Case Example:

```json
{
    "route": "Hyperlane Warp",
    "route_type": "HYPERLANE_WARP",
    "description": "Hyperlane Warp Description",
    "fromBridgeAddress": "0xC39f664Aa28293781C3C2907C172C50cA0596a98",
    "destinationBridgeAddress": "0xf0b28E28aE68cB563758Fee6062b01250a6916ef"
}
```

##### CCTP Case Example:

```json
{
    "route": "Hyperlane CCTP",
    "route_type": "HYPERLANE_CCTP",
    "description": "Hyperlane CCTP Description",
    "fromBridgeAddress": "0xfFE648692689bD72Ba223F3feC1D16a0d9e7FAdB",
    "destinationBridgeAddress": "0x..._cctp_mumbai"
}
```

---

### 2. Prepare ERC20 Transaction for Approvals

#### Request

`POST /cometh/prepare-erc20-tx`

##### Body

- `walletAddress`: User's wallet address
- `tokenAddress`: Token contract address
- `functionName`: Smart contract function to call (e.g., "approve")
- `args`: Smart contract function arguments
- `chainId`: Source chain ID

#### Action

Sign the `toBeSignedData_approve` using the HTML interface and then send the signed transaction to the Cometh Relay API.

---

### 3. Prepare Bridge Transfer Transaction

#### Hyperlane WARP Case

`POST /cometh/prepare-bridge-transfer-tx`

#### Hyperlane CCTP Case

`POST /cometh/prepare-usdc-bridge-transfer-tx`

##### Body

- `walletAddress`: User's wallet address
- `recipientAddress`: Destination wallet address
- `tokenAddress`: Token contract address
- `fromChainId`: Source chain ID
- `destinationChainId`: Destination chain ID
- `amount`: Amount to transfer

#### Action

Sign the `toBeSignedData_approve` using the HTML interface and then send the signed transaction to the Cometh Relay API.

---

## Actions After API Calls

- For both WARP and CCTP cases, after receiving the `toBeSignedData_approve`, use the HTML interface to sign it.
- Send the signed transaction to the Cometh Relay API.