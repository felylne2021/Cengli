import 'dart:typed_data';

import 'package:cengli/services/services.dart';
import 'package:ethers/crypto/keccak.dart';
import 'package:hex/hex.dart';
import 'package:web3dart/web3dart.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;

import 'package:eth_sig_util/util/utils.dart';

import '../data/modules/transfer/model/response/transaction_data_response.dart';

class EthService {
  static List<String> crateRandom() {
    final mnemonic = bip39.generateMnemonic();

    final seed = bip39.mnemonicToSeed(mnemonic);
    final root = bip32.BIP32.fromSeed(seed);

    final child1 = root.derivePath("m/44'/60'/0'/0/0");
    final privateKey = HEX.encode(child1.privateKey!);
    final address = EthPrivateKey.fromHex(privateKey).address.hex;

    return [privateKey, address];
  }

  String normalizeEthereumAddress(String address) {
    if (!address.startsWith('0x')) {
      throw ArgumentError('Invalid Ethereum address format');
    }

    var addressWithoutPrefix = address.substring(2);
    var paddedAddress = addressWithoutPrefix.padLeft(40, '0');

    return '0x$paddedAddress';
  }

  Future<String> signTransaction(TransactionDataResponse response) async {
    String walletAddress = await SessionService.getWalletAddress();
    String privateKey = await SessionService.getPrivateKey(walletAddress);

    final credentials = EthPrivateKey.fromHex(privateKey);

    final typedDataHash = _hashTypedData(response);
    final signature = credentials.signPersonalMessageToUint8List(typedDataHash);

    // final signatureDua =
    //     SignatureUtil.sign(message: typedDataHash, privateKey: privateKey);

    return bytesToHex(signature, include0x: true);
  }
}

Uint8List _hashTypedData(TransactionDataResponse response) {
  final domain = response.domain;

  final chainId =
      int.parse(domain?.chainId ?? "").toRadixString(16).padLeft(64, '0');
  final verifyingContract =
      domain?.verifyingContract?.substring(2).padLeft(64, '0');

  final domainSeparator = keccak256(Uint8List.fromList([
    ...hexToBytes('0x$chainId'),
    ...hexToBytes(verifyingContract ?? ""),
  ]));

  final typeData = response.types;
  final typeDataStr = '${typeData?.to}'
      '${typeData?.value}'
      '${typeData?.data}'
      '${typeData?.operation}'
      '${typeData?.safeTxGas}'
      '${typeData?.baseGas}'
      '${typeData?.gasPrice}'
      '${typeData?.gasToken}'
      '${typeData?.refundReceiver}'
      '${typeData?.nonce}';

  final hashedTypeData = keccak256(Uint8List.fromList(typeDataStr.codeUnits));

  final combined = '0x1901$domainSeparator$hashedTypeData';
  return keccak256(Uint8List.fromList(combined.codeUnits));
}

const ERC_20_ABI = '''
[
    {
        "constant": true,
        "inputs": [],
        "name": "name",
        "outputs": [
            {
                "name": "",
                "type": "string"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [
            {
                "name": "_spender",
                "type": "address"
            },
            {
                "name": "_value",
                "type": "uint256"
            }
        ],
        "name": "approve",
        "outputs": [
            {
                "name": "",
                "type": "bool"
            }
        ],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [],
        "name": "totalSupply",
        "outputs": [
            {
                "name": "",
                "type": "uint256"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [
            {
                "name": "_from",
                "type": "address"
            },
            {
                "name": "_to",
                "type": "address"
            },
            {
                "name": "_value",
                "type": "uint256"
            }
        ],
        "name": "transferFrom",
        "outputs": [
            {
                "name": "",
                "type": "bool"
            }
        ],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [],
        "name": "decimals",
        "outputs": [
            {
                "name": "",
                "type": "uint8"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [
            {
                "name": "_owner",
                "type": "address"
            }
        ],
        "name": "balanceOf",
        "outputs": [
            {
                "name": "balance",
                "type": "uint256"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [],
        "name": "symbol",
        "outputs": [
            {
                "name": "",
                "type": "string"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [
            {
                "name": "_to",
                "type": "address"
            },
            {
                "name": "_value",
                "type": "uint256"
            }
        ],
        "name": "transfer",
        "outputs": [
            {
                "name": "",
                "type": "bool"
            }
        ],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [
            {
                "name": "_owner",
                "type": "address"
            },
            {
                "name": "_spender",
                "type": "address"
            }
        ],
        "name": "allowance",
        "outputs": [
            {
                "name": "",
                "type": "uint256"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "payable": true,
        "stateMutability": "payable",
        "type": "fallback"
    },
    {
        "anonymous": false,
        "inputs": [
            {
                "indexed": true,
                "name": "owner",
                "type": "address"
            },
            {
                "indexed": true,
                "name": "spender",
                "type": "address"
            },
            {
                "indexed": false,
                "name": "value",
                "type": "uint256"
            }
        ],
        "name": "Approval",
        "type": "event"
    },
    {
        "anonymous": false,
        "inputs": [
            {
                "indexed": true,
                "name": "from",
                "type": "address"
            },
            {
                "indexed": true,
                "name": "to",
                "type": "address"
            },
            {
                "indexed": false,
                "name": "value",
                "type": "uint256"
            }
        ],
        "name": "Transfer",
        "type": "event"
    }
]
''';
