class EthService {
  String normalizeEthereumAddress(String address) {
    if (!address.startsWith('0x')) {
      throw ArgumentError('Invalid Ethereum address format');
    }

    var addressWithoutPrefix = address.substring(2);
    var paddedAddress = addressWithoutPrefix.padLeft(40, '0');

    return '0x$paddedAddress';
  }
}
