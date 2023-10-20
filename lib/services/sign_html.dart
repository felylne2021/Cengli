const String signScript = '''
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sign</title>

    <script
      src="https://cdnjs.cloudflare.com/ajax/libs/ethers/6.8.0/ethers.umd.min.js"
      integrity="sha512-R7ASZgpXeoiujgi/4yoTErsG7ZWVq57+vLtQmFZV1LKap0Gmgbc/QeafAmOz1n66/iKfp+w5mSKabl/6Mi6UKg=="
      crossorigin="anonymous"
      referrerpolicy="no-referrer"
    ></script>

    <script
      src="https://cdnjs.cloudflare.com/ajax/libs/axios/1.5.1/axios.min.js"
      integrity="sha512-emSwuKiMyYedRwflbZB2ghzX8Cw8fmNVgZ6yQNNXXagFzFOaQmbvQ1vmDkddHjm5AITcBIZfC7k4ShQSjgPAmQ=="
      crossorigin="anonymous"
      referrerpolicy="no-referrer"
    ></script>
  </head>

  <body>
    <script>

      const EIP712_SAFE_TX_TYPES = {
        SafeTx: [
          { type: "address", name: "to" },
          { type: "uint256", name: "value" },
          { type: "bytes", name: "data" },
          { type: "uint8", name: "operation" },
          { type: "uint256", name: "safeTxGas" },
          { type: "uint256", name: "baseGas" },
          { type: "uint256", name: "gasPrice" },
          { type: "address", name: "gasToken" },
          { type: "address", name: "refundReceiver" },
          { type: "uint256", name: "nonce" },
        ],
      };

      async function signTransaction(comethWalletAddress, walletPrivateKey, preparedTx, rpcUrl) {

        const preparedTxData = JSON.parse(preparedTx);
        const provider = new ethers.JsonRpcProvider(rpcUrl);
        const walletInstance = new ethers.Wallet(walletPrivateKey, provider);

        try {
          const signedTx = await walletInstance.signTypedData(
            preparedTxData.domain,
            EIP712_SAFE_TX_TYPES,
            preparedTxData.types
          );

          preparedTxData.types.signatures = signedTx;

          window.flutter_inappwebview.callHandler('signedTx', preparedTxData.types);
          
        } catch (e) {
          console.log("error", e);
        }
      };

      signTransaction(comethWalletAddress, walletPrivateKey, preparedTx, rpcUrl);

    </script>
  </body>
</html>
''';
