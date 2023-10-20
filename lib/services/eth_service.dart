import 'package:hex/hex.dart';
import 'package:web3dart/web3dart.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;

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
}
