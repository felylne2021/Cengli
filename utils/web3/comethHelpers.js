import { ethers } from 'ethers';
// console.log('-> gasService.estimateSafeTxGas()', {
//   walletAddress,
//   safeTransactionData,
//   provider
// });

// let safeTxGas = ethers_1.BigNumber.from(0);
// for (let i = 0; i < safeTransactionData.length; i++) {
//   safeTxGas = safeTxGas.add(yield provider.estimateGas(Object.assign(Object.assign({}, safeTransactionData[i]), { from: walletAddress })));
// }

// console.log('safeTxGas', safeTxGas.toString());

// return safeTxGas;

export const estimateSafeTxGas = async ({
  walletAddress,
  safeTransactionData,
  provider
}) => {
  let safeTxGas = ethers.toBigInt(0)
  console.log('safeTxGas', safeTxGas)

  for (let i = 0; i < safeTransactionData.length; i += 1) {
    const gas = await provider.estimateGas(Object.assign({}, safeTransactionData[i]), {
      from: walletAddress
    })

    // add gas to safeTxGas
    safeTxGas = Number(safeTxGas) + Number(gas)
  }

  return safeTxGas
}