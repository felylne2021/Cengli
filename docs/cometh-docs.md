## Cengli's Cometh API Guide

### Preliminary Steps

Before proceeding, ensure to check all transactions and contracts on [Snowtrace Testnet](https://testnet.snowtrace.io/).

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