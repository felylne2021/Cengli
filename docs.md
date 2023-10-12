Endpoint: https://cengli.engowl.studio

# API Documentation for Token Management

## Overview

This API documentation provides details on how to interact with the backend services for managing user assets and transactions. It covers three main endpoints:

1. **Get User Assets**: To fetch the assets owned by a user.
2. **Send Token**: To initiate a token transfer between users.
3. **Get User Transactions**: To fetch the transaction history of a user.

---

## 1. Get User Assets

### Endpoint

**GET** `{{baseUrl}}/account/assets`

### Query Parameters

- `address`: The Ethereum address of the user.
- `chainId`: The ID of the blockchain network.

### Example Request

```http
GET {{baseUrl}}/account/assets?address=0x278A2d5B5C8696882d1D2002cE107efc74704ECf&chainId=5
```

### Example Response

```json
{
  "totalBalanceUsd": 100,
  "tokens": [
    {
      "balance": 123,
      "balanceUSd": 123,
      "token": {
        "address": "0xe05606174bac4A6364B31bd0eCA4bf4dD368f8C6",
        "chainId": 420,
        "name": "USD Coin",
        "symbol": "USDC",
        "decimals": 6,
        "logoURI": "https://s2.coinmarketcap.com/static/img/coins/64x64/3408.png",
        "priceUsd": 1
      }
    }
  ]
}
```

---

## 2. Send Token

### Endpoint

**POST** `{{baseUrl}}/transfer/send`

### Request Body

- `fromUserId`: Sender's user ID.
- `destinationUserId`: Receiver's user ID.
- `fromAddress`: Sender's Ethereum address.
- `destinationAddress`: Receiver's Ethereum address.
- `tokenAddress`: Token contract address.
- `chainId`: Blockchain network ID.
- `amount`: Amount to send.
- `note`: Optional note.
- `signer`: Signature of the sender.

### Example Request

```json
{
  "fromUserId": "dummyFromUserId",
  "destinationUserId": "dummyDestinationUserId",
  "fromAddress": "dummyFromAddress",
  "destinationAddress": "dummyDestinationAddress",
  "tokenAddress": "0x07865c6e87b9f70255377e024ace6630c1eaa37f",
  "chainId": 5,
  "amount": 100,
  "note": "dummyNote",
  "signer": "dummySigner"
}
```

### Example Response

```json
{
  "id": "334b475c-9864-4998-bf23-d5929577e1e0",
  "fromUserId": "dummyFromUserId",
  "destinationUserId": "dummyDestinationUserId",
  "fromAddress": "dummyFromAddress",
  "destinationAddress": "dummyDestinationAddress",
  "chainId": 5,
  "tokenAddress": "0x07865c6e87b9f70255377e024ace6630c1eaa37f",
  "amount": 100,
  "note": "dummyNote",
  "createdAt": "2023-10-12T17:18:55.747Z",
  "updatedAt": "2023-10-12T17:18:55.747Z"
}
```

---

## 3. Get User Transactions

### Endpoint

**GET** `{{baseUrl}}/account/transactions`

### Query Parameters

- `userId`: The user ID for whom the transactions are to be fetched.

### Example Request

```http
GET {{baseUrl}}/account/transactions?userId=dummyFromUserId
```

### Example Response

```json
[
  {
    "id": "334b475c-9864-4998-bf23-d5929577e1e0",
    "fromUserId": "dummyFromUserId",
    "destinationUserId": "dummyDestinationUserId",
    "fromAddress": "dummyFromAddress",
    "destinationAddress": "dummyDestinationAddress",
    "chainId": 5,
    "tokenAddress": "0x07865c6e87b9f70255377e024ace6630c1eaa37f",
    "amount": 100,
    "note": "dummyNote",
    "createdAt": "2023-10-12T17:18:55.747Z",
    "updatedAt": "2023-10-12T17:18:55.747Z"
  }
  // More transactions
]
```