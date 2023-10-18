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