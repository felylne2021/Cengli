Endpoint: https://cengli.engowl.studio

# Transfer & Information

---

## 1. **Fetch User Assets**

**GET** `{{baseUrl}}/account/assets`

| Parameter | Description |
|-----------|-------------|
| address   | User's Ethereum address |
| chainId   | Blockchain network ID |

**Example Request:**
```http
GET {{baseUrl}}/account/assets?address=0x278...04ECf&chainId=5
```

**Example Response:**
```json
{
  "totalBalanceUsd": 100,
  "tokens": [
    {
      "balance": 123,
      "balanceUSd": 123,
      "token": {
        "address": "0xe05...8C6",
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

## 2. **Initiate Token Transfer**

**POST** `{{baseUrl}}/transfer/send`

| Parameter           | Description |
|---------------------|-------------|
| fromUserId          | Sender's user ID |
| destinationUserId   | Receiver's user ID |
| fromAddress         | Sender's Ethereum address |
| destinationAddress  | Receiver's Ethereum address |
| tokenAddress        | Token contract address |
| fromChainId         | From Blockchain network ID |
| destinationChainId  | Destination Blockchain network ID |
| amount              | Amount to send |
| note                | Optional note |
| signer              | Sender's signature |

**Example Request:**
```json
{
  "fromUserId": "dummyFromUserId",
  "destinationUserId": "dummyDestinationUserId",
  "fromAddress": "dummyFromAddress",
  "destinationAddress": "dummyDestinationAddress",
  "tokenAddress": "0x999...f97",
  "fromChainId": 80001,
  "destinationChainId": 420,
  "amount": 100,
  "note": "dummyNote",
  "signer": "dummySigner"
}
```

**Example Response:**
```json
{
  "id": "334b475c-9864-4998-bf23-d5929577e1e0",
  "fromUserId": "dummyFromUserId",
  "destinationUserId": "dummyDestinationUserId",
  "fromAddress": "dummyFromAddress",
  "destinationAddress": "dummyDestinationAddress",
  "fromChainId": 80001,
  "destinationChainId": 420,
  "tokenAddress": "0x078...a37f",
  "amount": 100,
  "note": "dummyNote",
  "createdAt": "2023-10-12T17:18:55.747Z",
  "updatedAt": "2023-10-12T17:18:55.747Z"
}
```

---

## 3. **Fetch User Transactions**

**GET** `{{baseUrl}}/account/transactions`

| Parameter | Description |
|-----------|-------------|
| userId    | User ID |

**Example Request:**
```http
GET {{baseUrl}}/account/transactions?userId=dummyFromUserId
```

**Example Response:**
```json
[
  {
    "id": "334b475c-9864-4998-bf23-d5929577e1e0",
    "fromUserId": "dummyFromUserId",
    "destinationUserId": "dummyDestinationUserId",
    "fromAddress": "dummyFromAddress",
    "destinationAddress": "dummyDestinationAddress",
    "chainId": 80001,
    "tokenAddress": "0x078...a37f",
    "amount": 100,
    "note": "dummyNote",
    "createdAt": "2023-10-12T17:18:55.747Z",
    "updatedAt": "2023-10-12T17:18:55.747Z"
  }
]
```

---

## 4. **Fetch Blockchain Info**

**GET** `{{baseUrl}}/info/chains`

**Example Response:**
```json
[
  {
    "chainId": 80001,
    "chainName": "Polygon Mumbai Testnet",
    "rpcUrl": "https://polygon-mumbai-bor.publicnode.com",
    "nativeCurrency": {
      "name": "Matic",
      "symbol": "MATIC",
      "decimals": 18
    },
    "blockExplorer": "https://mumbai.polygonscan.com",
    "logoURI": "https://s2.coinmarketcap.com/static/img/coins/64x64/3408.png",
    "createdAt": "2023-10-13T11:46:21.915Z",
    "updatedAt": "2023-10-13T11:49:00.566Z"
  },
  {
    "chainId": 43113,
    "chainName": "Avalanche Fuji Testnet",
    "rpcUrl": "https://avalanche-fuji-c-chain.publicnode.com",
    "nativeCurrency": {
      "name": "Avalanche",
      "symbol": "AVAX",
      "decimals": 18
    },
    "blockExplorer": "https://testnet.snowtrace.io",
    "logoURI": "https://s2.coinmarketcap.com/static/img/coins/64x64/5805.png",
    "createdAt": "2023-10-13T11:46:22.251Z",
    "updatedAt": "2023-10-13T11:49:00.899Z"
  }
]
```

---

# P2P Marketplace

## 1. **Fetch Listings**

**GET** `{{baseUrl}}/listings`

**Query Parameters:**
- `isActive`: (Optional) Filter by active status, `true` for active listings, `false` for inactive listings.
- `userId`: (Optional) Filter by user ID to retrieve listings for a specific user.

**Example Request:**
```http
GET {{baseUrl}}/listings?isActive=true&userId=dummyUserId
```

---

## 2. **Create a New Listing**

**POST** `{{baseUrl}}/listings`

**Request Body:**
- `userId`: The user ID of the listing creator.
- `userAddress`: Ethereum address of the listing creator.
- `tokenAddress`: Address of the token contract.
- `tokenChainId`: Chain ID of the blockchain network the token resides on.
- `amount`: Amount of tokens listed.

**Example Request:**
```json
{
  "userId": "dummyUserId",
  "userAddress": "dummyUserAddress",
  "tokenAddress": "0x9999f7fea5938fd3b1e26a12c3f2fb024e194f97",
  "tokenChainId": 80001,
  "amount": 1000
}
```

---

## 3. **Fetch Orders**

**GET** `{{baseUrl}}/orders`

**Query Parameters:**
- `listingId`: ID of the listing to retrieve orders for.
- `statuses`: (Optional) Comma-separated list of order statuses to filter by.
- `orderId`: (Optional) Order ID to filter by a specific order.

**Example Request:**
```http
GET {{baseUrl}}/orders?listingId=dummyListingId&statuses=WFSAC,WFBP
```

---

## 4. **Fetch Order Details**

**GET** `{{baseUrl}}/orders/:id`

**Path Parameters:**
- `id`: ID of the order to retrieve.

**Example Request:**
```http
GET {{baseUrl}}/orders/dummyOrderId
```

---

## 5. **Create a New Order**

**POST** `{{baseUrl}}/orders`

**Request Body:**
- `listingId`: ID of the listing to create an order for.
- `buyerUserId`: User ID of the buyer.
- `buyerAddress`: Ethereum address of the buyer.
- `amount`: Amount of tokens to buy.
- `chatId`: ID of the chat associated with the order.
- `destinationChainId`: Chain ID of the blockchain network the tokens are to be transferred to.

**Example Request:**
```json
{
  "listingId": "dummyListingId",
  "buyerUserId": "dummyBuyerUserId",
  "buyerAddress": "dummyBuyerAddress",
  "amount": 100,
  "chatId": "dummyChatId",
  "destinationChainId": 80001
}
```

---

## 6. **Accept an Order**

**PUT** `{{baseUrl}}/orders/:id/accept`

**Path Parameters:**
- `id`: ID of the order to accept.

**Query Parameters:**
- `callerUserId`: User ID of the caller.

**Example Request:**
```http
PUT {{baseUrl}}/orders/dummyOrderId/accept?callerUserId=dummyUserId
```

---

## 7. **Cancel an Order**

**PUT** `{{baseUrl}}/orders/:id/cancel`

**Path Parameters:**
- `id`: ID of the order to cancel.

**Query Parameters:**
- `callerUserId`: User ID of the caller.

**Example Request:**
```http
PUT {{baseUrl}}/orders/dummyOrderId/cancel?callerUserId=dummyUserId
```

---

## 8. **Mark Payment as Done**

**PUT** `{{baseUrl}}/orders/:id/done-payment`

**Path Parameters:**
- `id`: ID of the order to mark payment as done for.

**Query Parameters:**
- `callerUserId`: User ID of the caller.

**Example Request:**
```http
PUT {{baseUrl}}/orders/dummyOrderId/done-payment?callerUserId=dummyUserId
```

---

## 9. **Release Funds to Buyer**

**PUT** `{{baseUrl}}/orders/:id/release-fund`

**Path Parameters:**
- `id`: ID of the order to release funds for.

**Query Parameters:**
- `callerUserId`: User ID of the caller.

**Example Request:**
```http
PUT {{baseUrl}}/orders/dummyOrderId/release-fund?callerUserId=dummyUserId
```

---

This documentation structure maintains consistency with the previous sections while clearly explaining the purpose, HTTP methods, and parameters for each endpoint. Each section also provides example requests to help users understand how to interact with these endpoints.