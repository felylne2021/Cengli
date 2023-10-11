class WalletUtil {
  static shortAddress(String address) {
    return "${address.substring(0, 4)}...${address.substring(address.length - 4, address.length)}";
  }

  static secureNumber(String number) {
    return "*********${number.substring(number.length - 3)}";
  }
}
