import 'dart:convert';
import 'dart:typed_data';

import 'package:cengli/push_protocol/src/models/src/user_model.dart';
import 'package:ethers/signers/wallet.dart' as ethers;

import 'package:eth_sig_util/eth_sig_util.dart' as eth_sig;
import 'package:web3dart/web3dart.dart' as web3;


class EthersSigner extends Signer {
  final ethers.Wallet ethersWallet;

  final String address;

  EthersSigner({required this.ethersWallet, required this.address});

  @override
  String getAddress() {
    return address;
  }

  @override
  Future<String> getEip191Signature(String message) async {
    try {
      var m = utf8.encode(message);

      String signature = eth_sig.EthSigUtil.signPersonalMessage(
          privateKey: ethersWallet.privateKey, message: Uint8List.fromList(m));
      return signature;
    } catch (e) {
      print('override: getEip191Signature: error$e');
      return message;
    }
  }

  @override
  Future<String> getEip712Signature(String message) async {
    throw UnimplementedError();
  }

  @override
  Future<String> signMessage(String message) async {
    try {
      var m = utf8.encode(message);

      String signature = eth_sig.EthSigUtil.signMessage(
          privateKey: ethersWallet.privateKey, message: Uint8List.fromList(m));
      return signature;
    } catch (e) {
      return message;
    }
  }
  
  @override
  getChainId() {
    // TODO: implement getChainId
    throw UnimplementedError();
  }
  
  @override
  Future<String> signTypedData({domain, types, value}) {
    // TODO: implement signTypedData
    throw UnimplementedError();
  }
}

class Web3Signer extends Signer {
  final web3.Credentials credentials;

  Web3Signer(this.credentials);

  @override
  String getAddress() {
    return this.credentials.address.hex;
  }

  @override
  Future<String> getEip191Signature(String message) async {
    var m = utf8.encode(message);
    final sig = credentials.signToEcSignature(Uint8List.fromList(m));

    return sig.toString();
  }

  @override
  Future<String> getEip712Signature(String message) {
    throw UnimplementedError();
  }

  @override
  Future<String> signMessage(String message) async {
    var m = utf8.encode(message);
    final sig =
        credentials.signPersonalMessageToUint8List(Uint8List.fromList(m));
    return utf8.decode(sig);
  }
  
  @override
  getChainId() {
    throw UnimplementedError();
  }
  
  @override
  Future<String> signTypedData({domain, types, value}) {
    throw UnimplementedError();
  }
}
