exports.getMetaTxTypedData = function (message) {
  const EIP712Domain = [
    { name: 'name', type: 'string' },
    { name: 'version', type: 'string' },
    { name: 'chainId', type: 'uint256' },
    { name: 'verifyingContract', type: 'address' },
  ]

  const domain = {
    name: 'CengliForwarder',
    version: '1',
    chainId: 5,  // Goerli Testnet
    verifyingContract: '0xf10BBBbD99f616F134e817B29465Cb671139e345',
  };

  const ForwardRequest = [
    { name: 'from', type: 'address' },
    { name: 'to', type: 'address' },
    { name: 'value', type: 'uint256' },
    { name: 'gas', type: 'uint256' },
    { name: 'nonce', type: 'uint256' },
    { name: 'deadline', type: 'uint48' },
    { name: 'data', type: 'bytes' }
  ];

  const data = {
    types: {
      ForwardRequest,
    },
    domain: domain,
    primaryType: 'ForwardRequest',
    message: message,
  }

  return data;
}