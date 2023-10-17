import 'dart:convert';
import 'dart:typed_data';

import 'package:cengli/services/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:webauthn/webauthn.dart';

class EthService {
  String normalizeEthereumAddress(String address) {
    if (!address.startsWith('0x')) {
      throw ArgumentError('Invalid Ethereum address format');
    }

    var addressWithoutPrefix = address.substring(2);
    var paddedAddress = addressWithoutPrefix.padLeft(40, '0');

    return '0x$paddedAddress';
  }

  void sendTransaction(String receiverAddress) async {
    try {
      String walletAddress = await SessionService.getWalletAddress();
      String signerAddress =
          await SessionService.getSignerAddress(walletAddress);

      const String rpcUrl = 'https://rpc.ankr.com/eth_goerli';

      final client = Web3Client(rpcUrl, Client());

      final credentials = EthPrivateKey.fromHex(signerAddress);
      final address = credentials.address;

      final publicKeyId = await SessionService.getPublicKeyId();

      final auth = Authenticator(true, false);
      final attestation = await auth.getAssertion(GetAssertionOptions(
          allowCredentialDescriptorList: [
            PublicKeyCredentialDescriptor(
                type: PublicKeyCredentialType.publicKey,
                id: parseHex(publicKeyId))
          ],
          rpId: "cengli",
          clientDataHash: Uint8List(32),
          requireUserPresence: true,
          requireUserVerification: false));
      debugPrint(base64Encode(attestation.signature));

      // final tx = Transaction(
      //   to: EthereumAddress.fromHex(walletAddress),
      //   value: EtherAmount.fromInt(EtherUnit.gwei, 10),
      //   gasPrice: EtherAmount.inWei(BigInt.parse("30000")),
      //   maxGas: 22000,
      // );
      // final rpl = Rlp.encode(tx.data);
      // final txBytes = Uint8List.fromList(Rlp.encode(tx));

      // final signedTx =
      //     Uint8List.fromList([...txBytes, ...attestation.signature]);

      // final safeTxDataTye = await prepareTransaction();
      

      //signature

      // final balance = await client.getBalance(EthereumAddress.fromHex(
      //     "0xD3d103Bb6064FA4642470d1b3a950F0652E1ec36"));
      // debugPrint(balance.toString());

      // debugPrint(signedTx.toString());

      debugPrint(EtherAmount.inWei(BigInt.parse("30000")).toString());

      // debugPrint(EtherAmount.fromInt(EtherUnit.gwei, 1).toString());

      // final send = await client.sendTransaction(
      //     credentials,
      //     Transaction(
      //       from: EthereumAddress.fromHex(walletAddress),
      //       to: EthereumAddress.fromHex(receiverAddress),
      //       gasPrice: EtherAmount.inWei(BigInt.parse("30000")),
      //       maxGas: 22000,
      //       value: EtherAmount.fromInt(EtherUnit.gwei, 10),
      //     ),
      //     chainId: 5);
      // debugPrint(balance.toString());
    } catch (e) {
      debugPrint("duarr mmk ${e.toString()}");
    }
  }

  Uint8List parseHex(String str) {
    return Uint8List.fromList(
      RegExp(r'[\da-f]{2}', caseSensitive: false)
          .allMatches(str)
          .map((match) => int.parse(match.group(0)!, radix: 16))
          .toList(),
    );
  }
}
