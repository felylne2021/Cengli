Endpoint: https://cengli.engowl.studio

# 💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖

---

# Transfer & Information

---

## 1. **Fetch User Assets**

**GET** `{{baseUrl}}/account/assets`

| Parameter | Description             |
| --------- | ----------------------- |
| address   | User's Ethereum address |
| chainId   | Blockchain network ID   |

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

| Parameter          | Description                       |
| ------------------ | --------------------------------- |
| fromUserId         | Sender's user ID                  |
| destinationUserId  | Receiver's user ID                |
| fromAddress        | Sender's Ethereum address         |
| destinationAddress | Receiver's Ethereum address       |
| tokenAddress       | Token contract address            |
| fromChainId        | From Blockchain network ID        |
| destinationChainId | Destination Blockchain network ID |
| amount             | Amount to send                    |
| note               | Optional note                     |
| signer             | Sender's signature                |

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
| --------- | ----------- |
| userId    | User ID     |

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

## 1. **Fetch Partners**

**GET** `{{baseUrl}}/partners`

**Query Parameters:**
- `userId`: Ethereum address of the user.
- `userAddress`: Ethereum address of the user. *(Same as `userId`)*

**Example Request:**
```http
GET {{baseUrl}}/partners?userId=0x278A2d5B5C8696882d1D2002cE107efc74704ECf&userAddress=0x278A2d5B5C8696882d1D2002cE107efc74704ECf
```

**Example Response:**
```json
[
    {
        "id": "ef0407e5-3088-4bf2-a5ec-4a8dcdc24657",
        "userId": "0x278A2d5B5C8696882d1D2002cE107efc74704ECf",
        "address": "0x278A2d5B5C8696882d1D2002cE107efc74704ECf",
        "createdAt": "2023-10-15T15:09:31.492Z",
        "updatedAt": "2023-10-15T15:09:31.492Z",
        "balances": [
            {
                "partnerId": "ef0407e5-3088-4bf2-a5ec-4a8dcdc24657",
                "tokenAddress": "0x07865c6e87b9f70255377e024ace6630c1eaa37f",
                "tokenChainId": 5,
                "amount": 249904453258388,
                "token": {
                    "address": "0x07865c6e87b9f70255377e024ace6630c1eaa37f",
                    "chainId": 5,
                    "name": "USD Coin",
                    "symbol": "USDC",
                    "decimals": 6,
                    "logoURI": "https://s2.coinmarketcap.com/static/img/coins/64x64/3408.png",
                    "priceUsd": 1,
                    "createdAt": "2023-10-14T22:02:47.985Z",
                    "updatedAt": "2023-10-15T17:31:27.592Z"
                }
            }
        ]
    }
]
```

---

## 2. **Add a New Partner**

**POST** `{{baseUrl}}/partners`

**Request Body:**
- `userId`: Ethereum address of the user.
- `userAddress`: Ethereum address of the user. *(Same as `userId`)*
- `name`: Name of the partner.

**Example Request:**
```http
POST {{baseUrl}}/partners
Content-Type: application/json

{
    "userId": "0x278A2d5B5C8696882d1D2002cE107efc74704ECf",
    "userAddress": "0x278A2d5B5C8696882d1D2002cE107efc74704ECf",
    "name": "Partner 1"
}
```

---

## 3. **Fetch All Orders**

**GET** `{{baseUrl}}/orders`

**Query Parameters:**
- `partnerId`: The ID of the partner.
- `statuses`: Comma-separated list of order statuses.

**Example Request:**
```http
GET {{baseUrl}}/orders?partnerId=ef0407e5-3088-4bf2-a5ec-4a8dcdc24657
```

---
## 4. **Fetch Order by ID**

**Endpoint:** `GET /orders/:id`

**Path Parameters:**
- `id` (string): The ID of the order.

---

## 5. **Create a New Order**

**Endpoint:** `POST /orders`

**Request Body:**
- `partnerId` (string): The ID of the partner.
- `buyerUserId` (string): The ID of the buyer user.
- `buyerAddress` (string): The address of the buyer.
- `amount` (number): The amount for the order.
- `chatId` (string): The ID of the chat associated with the order.
- `destinationChainId` (number): The ID of the destination chain.
- `tokenAddress` (string): The address of the token.
- `orderId` (string, optional): The ID of the order (if provided).

---

## 6. **Accept an Order by Partner**

**Endpoint:** `PUT /orders/:id/accept`

**Path Parameters:**
- `id` (string): The ID of the order.

**Query Parameters:**
- `callerUserId` (string): The ID of the user making the call.

---

## 7. **Cancel an Order by Partner or Buyer**

**Endpoint:** `PUT /orders/:id/cancel`

**Path Parameters:**
- `id` (string): The ID of the order.

**Query Parameters:**
- `callerUserId` (string): The ID of the user making the call.

---

## 8. **Mark Payment as Done by the Buyer**

**Endpoint:** `PUT /orders/:id/done-payment`

**Path Parameters:**
- `id` (string): The ID of the order.

**Query Parameters:**
- `callerUserId` (string): The ID of the user making the call.

---

## 9. **Release Funds to Buyer**

**Endpoint:** `PUT /orders/:id/release-fund`

**Path Parameters:**
- `id` (string): The ID of the order.

**Query Parameters:**
- `callerUserId` (string): The ID of the user making the call.

## 10 **Update Partner User ID**

**Endpoint:** `POST /change-partner-user-id`

This endpoint allows the updating of a partner's user ID in the database, using the provided wallet address to identify the partner.

**Request Body:**

- `walletAddress` (string): The wallet address of the partner whose user ID needs to be updated.
- `userId` (string): The new user ID to be associated with the partner.

**Request Example:**
```json
{
  "walletAddress": "0x1234567890abcdef1234567890abcdef12345678",
  "userId": "newUserID123"
}
```

---

# 💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖💖
