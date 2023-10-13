Endpoint: https://cengli.engowl.studio

# Token Management API Documentation

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
| chainId             | Blockchain network ID |
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
  "chainId": 80001,
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
  "chainId": 80001,
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