## Cengli's Cometh API Guide

### Preliminary Steps

Before proceeding, ensure to check all transactions and contracts on [Snowtrace Testnet](https://testnet.snowtrace.io/).
All things done here will be on Avalanche Fuji Testnet (chainId: 43113), and the RPC URL is `https://rpc.ankr.com/avalanche_fuji`.

### Wallet Creation Flow

Refer to the file: `packages/ui/src/components/ComethBurnerWalletFlow.jsx` -> `startFlow()` for the following steps:

1. **Create a Random Wallet**:
   Generate a random wallet to obtain an address and private key. This will serve as the signer wallet to control the Cometh's wallet.

    ```javascript
    const newSignerWallet = ethers.Wallet.createRandom();
    console.log('newSignerWallet', {
        address: newSignerWallet.address,
        privateKey: newSignerWallet.privateKey
    });
    ```

2. **Initiate Cometh Wallet**:
   After creating a regular EOA (Externally Owned Account) wallet locally, call the `/wallets/init` endpoint on the Cometh API to create Cometh's wallet.

    ```javascript
    const createComethWallet = await axios({
        method: 'POST',
        url: 'https://api.connect.cometh.io/wallets/init',
        headers: {
            'apiKey': import.meta.env.VITE_COMETH_API_KEY
        },
        data: {
            ownerAddress: _address,
        }
    });
    console.log('createComethWallet', {
        address: createComethWallet.data.walletAddress
    });
    ```

3. **Retrieve Cometh's Wallet Address**:
   If you have the signer address, obtain the Cometh's wallet associated with that signer wallet using the following:

    ```javascript
    const getComethWallet = await axios({
        method: 'GET',
        url: `https://api.connect.cometh.io/wallets/${_address}/wallet-address`,
        headers: {
            'apiKey': import.meta.env.VITE_COMETH_API_KEY
        },
    });
    console.log('getComethWallet', {
        address: getComethWallet.data.walletAddress
    });
    ```

### Call Contract’s Function Flow

Refer to the file: `packages/ui/src/components/ComethCengliDemo.jsx` -> `approveToken()` for the following steps:

#### Setup:

- **Cometh Wallet Address**: `0x1E1960b1528541fa85a331C8933521073D6d3682`
- **Signer Address**: `0x8f8A15956565670AC6F298596CBf70EF074D5A25`
- **Signer Private Key**: `0x09913785ce30baabcead5164541216f1e07150fb0f23620ac9d58de284521699`
- **Target Contract (ERC20 Token Contract)**:
  - **Contract Name**: FujiTestingToken
  - **Contract Address**: `0x7ee6eb942378f7082fc58ab09dafd5f7c33a98bd`
  - [View on Snowtrace](https://testnet.snowtrace.io/address/0x7ee6eb942378f7082fc58ab09dafd5f7c33a98bd)

#### Case Scenario:

Approval of 10,000 USDC to a target address (mostly Febi's or P2PEscrow Contract in Cengli's case).

#### Flow:

1. **Initialize Provider and Wallet Instance**:
   Setup the provider using the FUJI RPC URL, and initiate the wallet instance from the signer private key.

    ```javascript
    // Setup provider and wallet instance
    const provider = new ethers.JsonRpcProvider(import.meta.env.VITE_COMETH_RPC_URL);
    const walletInstance = new ethers.Wallet(walletPrivateKey, provider);
    ```

2. **Initiate the ERC20 Contract**:
   All ERC20 tokens can use the same ABI but have different addresses.

    ```javascript
    // Create an instance of the token contract
    const TestTokenContract = new ethers.Contract(TEST_TOKEN_ADDRESS, ERC_20_ABI, walletInstance);
    ```

3. **Populate the Transaction**:
   This step doesn’t send the transaction to the blockchain but encodes the transaction.

    ```javascript
    const approveTransaction = await TestTokenContract.approve.populateTransaction(comethWalletAddress, formattedAmount, {
      from: comethWalletAddress,
      value: 0,
      chainId: 43113,
    });
    console.log('populated approve transaction', approveTransaction);
    ```

    **populatedTransaction Example:**
    ```json
    {
      "chainId": 43113,
      "data": "0x095ea7b30000000000000000000000001e1960b1528541fa85a331c8933521073d6d368200000000000000000000000000000000000000000000000000000004a817c800",
      "from": "0x1E1960b1528541fa85a331C8933521073D6d3682",
      "to": "0x7ee6eb942378f7082fc58ab09dafd5f7c33a98bd"
    }
    ```

4. **Request Prepared Transaction**:
   Send a request to Cengli's backend to prepare the transaction.

    ```javascript
    // Request to a backend service to prepare the transaction
    const preparedTxRes = await axios({
      method: 'POST',
      url: `${backendUrl}/cometh/prepare-tx`,
      data: {
        walletAddress: comethWalletAddress,
        safeTransactionData: {
          from: comethWalletAddress,
          to: TEST_TOKEN_ADDRESS,
          value: "0",
          data: approveTransaction.data,
        }
      }
    });
    ```

5. **Sign the Prepared Transaction**:
   The prepared transaction data will consist of a domain and types. Sign it with the Signer Wallet instance using `signTypedData`, then add the signature to the `preparedTx.types`.

    ```javascript
    const signedTx = await walletInstance.signTypedData(preparedTx.domain, EIP712_SAFE_TX_TYPES, preparedTx.types);
    preparedTx.types.signatures = signedTx;
    ```

6. **Send the Prepared Transaction**:
   Transmit the `preparedTx.types` data to Cometh’s relay API.

    ```javascript
    // Send the transaction through a relay service
    const sendRelayTxRes = await axios({
      method: 'POST',
      url: `https://api.connect.cometh.io/wallets/${comethWalletAddress}/relay`,
      headers: {
        'apiKey': import.meta.env.VITE_COMETH_API_KEY
      },
      data: preparedTx.types
    });
    ```

7. **Verify Transaction**:
   Check the Cometh's wallet address on [Snowtrace Testnet](https://testnet.snowtrace.io) to verify the transaction.

---
---

#### Easier Flow

Below is a simpler flow to call a contract's function. The data is prepared by the backend, and the frontend only needs to sign and send the transaction. Works for ERC20 tokens only.

The function `approveTokenWithPrepared` demonstrates the process of preparing and sending an ERC-20 token transaction, with the transaction data being prepared by a backend service. Here are the steps elaborated based on the provided code snippet:

---

1. **Format the Amount**:
   Convert the amount to the lowest denomination using the token's decimals.

```javascript
const formattedAmount = amount * 10 ** 6;
```

2. **Request Backend-Prepared Transaction Data**:
   Send a request to the backend to prepare the ERC-20 transaction data.

```javascript
const toBeSignedData = await axios({
  method: 'POST',
  url: `${backendUrl}/cometh/prepare-erc20-tx`,
  data: {
    walletAddress: comethWalletAddress,
    tokenAddress: TEST_TOKEN_ADDRESS,
    functionName: "approve",
    "args": ["0x3999032F30A9be2Fd2732B4cFe3e61ADe9531509", formattedAmount]
  }
})
```

3. **Initialize Provider and Wallet Instance**:
   Setup the provider using the specified RPC URL, and create a wallet instance using the private key.

```javascript
const provider = new ethers.JsonRpcProvider(import.meta.env.VITE_COMETH_RPC_URL);
const walletInstance = new ethers.Wallet(walletPrivateKey, provider);
```

4. **Sign the Prepared Transaction**:
   The backend provides the prepared transaction data. Sign this data with the wallet instance using `signTypedData`.

```javascript
const signedTx = await walletInstance.signTypedData(toBeSignedData.data.domain, EIP712_SAFE_TX_TYPES, toBeSignedData.data.types);
toBeSignedData.data.types.signatures = signedTx;
```

5. **Send the Prepared Transaction**:
   Transmit the signed transaction data to Cometh’s relay API.

```javascript
const sendRelayTxRes = await axios({
  method: 'POST',
  url: `https://api.connect.cometh.io/wallets/${comethWalletAddress}/relay`,
  headers: {
    'apiKey': import.meta.env.VITE_COMETH_API_KEY
  },
  data: toBeSignedData.data.types
});

console.log('sendRelayTxRes', sendRelayTxRes.data);
```

---

# Cometh API
---

## 1. **Fetch Sponsored Addresses**
**Endpoint:** `GET /sponsored-address`
- Description: Retrieve a list of all sponsored addresses.

**Response Example:**
```json
[
    {
        "chainId": 43113,
        "targetAddress": "0x36285302bd47f1db795dd8ebe2d2de0b866298b4",
        "createdAt": "2023-10-18T20:16:32.125Z",
        "updatedAt": "2023-10-18T20:21:31.612Z"
    },
    {
        "chainId": 43113,
        "targetAddress": "0x4a7a4ffad91b4f4588dc61f517b7c712c9e7bfd7",
        "createdAt": "2023-10-18T20:16:32.274Z",
        "updatedAt": "2023-10-18T20:21:31.788Z"
    }
]
```

---

## 2. **Add Sponsored Address**
**Endpoint:** `POST /sponsored-address`
- Description: Register a new sponsored address.

**Request Example:**
```json
{
    "targetAddress": "0x36285302bd47F1db795dD8ebe2d2De0B866298b4"
}
```

---

## 3. **Prepare Transaction**
**Endpoint:** `POST /prepare-tx`
- Description: Prepare a transaction by estimating the gas, checking the sponsored address, and formatting the transaction data.

**Request Example:**
```json
{
    "walletAddress": "0x94d48965E73603a7CCf1632177ce5A9e0a5A16C6",
    "safeTransactionData": {
        "from": "0x94d48965E73603a7CCf1632177ce5A9e0a5A16C6",
        "to": "0x7ee6eb942378f7082fc58ab09dafd5f7c33a98bd",
        "data": "0x095ea7b3000000000000000000000000278a2d5b5c8696882d1d2002ce107efc74704ecf00000000000000000000000000000000000000000000d3c21bcecceda1000000",
        "value": "0"
    }
}
```

---

**Response Example:**
```json
{
    "domain": {
        "chainId": 43113,
        "verifyingContract": "0x94d48965E73603a7CCf1632177ce5A9e0a5A16C6"
    },
    "types": {
        "to": "0x7ee6eb942378f7082fc58ab09dafd5f7c33a98bd",
        "value": "0",
        "data": "0x095ea7b3000000000000000000000000278a2d5b5c8696882d1d2002ce107efc74704ecf00000000000000000000000000000000000000000000d3c21bcecceda1000000",
        "operation": "0",
        "safeTxGas": "0",
        "baseGas": "0",
        "gasPrice": "0",
        "gasToken": "0x0000000000000000000000000000000000000000",
        "refundReceiver": "0x0000000000000000000000000000000000000000",
        "nonce": "5"
    }
}
```

---

## **4. Prepare ERC-20 Transaction**
**Endpoint:** `POST /prepare-erc20-tx`

Prepare a transaction for an ERC-20 token operation. This endpoint populates a transaction, checks if the recipient address is sponsored, and generates a transaction object to be signed.

### **Request Body:**

- `walletAddress` (string): The address of the wallet initiating the transaction.
- `tokenAddress` (string): The address of the ERC-20 token contract.
- `functionName` (string): The name of the function to call on the ERC-20 contract (e.g., "approve").
- `args` (array): The arguments to pass to the function. The number of arguments and their types depend on the function being called.

**Request Example:**
```json
{
  "walletAddress": "0x1E1960b1528541fa85a331C8933521073D6d3682",
  "tokenAddress": "0x7ee6eb942378f7082fc58ab09dafd5f7c33a98bd",
  "functionName": "approve",
  "args": ["0x1E1960b1528541fa85a331C8933521073D6d3682", "10000000"] // more params = more length
}
```

### **Response:**

The response contains the transaction data to be signed.

**Response Example:**
```json
{
    "domain": {
        "chainId": "43113",
        "verifyingContract": "0x1E1960b1528541fa85a331C8933521073D6d3682"
    },
    "types": {
        "to": "0x7ee6eb942378f7082fc58ab09dafd5f7c33a98bd",
        "value": "0",
        "data": "0x095ea7b30000000000000000000000001e1960b1528541fa85a331c8933521073d6d36820000000000000000000000000000000000000000000000000000000000989680",
        "operation": "0",
        "safeTxGas": "0",
        "baseGas": "0",
        "gasPrice": "0",
        "gasToken": "0x0000000000000000000000000000000000000000",
        "refundReceiver": "0x0000000000000000000000000000000000000000",
        "nonce": "10"
    }
}
```

--- 

### ERC20 Token Transfer Flow (Same Chain)

#### 1. Approve ERC20 Token

```javascript
const toBeSignedData_approve = await axios.post(`${backendUrl}/cometh/prepare-erc20-tx`, {
  walletAddress: comethWalletAddress,
  tokenAddress: TEST_TOKEN_ADDRESS,
  functionName: "approve",
  args: ["0x3999032F30A9be2Fd2732B4cFe3e61ADe9531509", formattedAmount]
});
```

**Sign**: Use HTML interface to sign `toBeSignedData_approve`.

---

#### 2. Transfer ERC20 Token

```javascript
const toBeSignedData_transfer = await axios.post(`${backendUrl}/cometh/prepare-erc20-tx`, {
  walletAddress: comethWalletAddress,
  tokenAddress: TEST_TOKEN_ADDRESS,
  functionName: "transfer",
  args: ["0x3999032F30A9be2Fd2732B4cFe3e61ADe9531509", formattedAmount]
});
```

**Sign**: Use HTML interface to sign `toBeSignedData_transfer`.

### Different Chain Transfer Flow

#### 1. Get Hyperlane Bridge Contract Address

```javascript
const getHyperlaneBridge = await axios.get(`${backendUrl}/transfer/bridge?fromChainId=43313&destinationChainId=5`);
```

**Example Response:**

```json
{
  "fromBridgeAddress": "0x...",
  "destinationBridgeAddress": "0x..."
}
```

---

#### 2. Approve ERC20 to Hyperlane Bridge Address

```javascript
const toBeSignedData_approve = await axios.post(`${backendUrl}/cometh/prepare-erc20-tx`, {
  walletAddress: comethWalletAddress,
  tokenAddress: TEST_TOKEN_ADDRESS,
  functionName: "approve",
  args: [fromBridgeAddress, formattedAmount]
});
```

**Sign**: Use HTML interface to sign `toBeSignedData_approve`.

---

#### 3. Prepare Transaction for Different Chain Transfer

```javascript
const toBeSignedData = await axios.post(`${backendUrl}/cometh/prepare-transfer-tx`, {
  walletAddress: comethWalletAddress,
  recipientAddress: "0x....",
  destinationChainId: "5",
  amount: 10000,
  tokenAddress: ""
});
```

---