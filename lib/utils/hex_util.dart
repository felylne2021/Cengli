class HexUtil {
  String hexArrayStr(List<int> array) {
    return array.fold(
        '0x', (acc, v) => acc + v.toRadixString(16).padLeft(2, '0'));
  }

  String toHexString(List<int> numbers) {
    return numbers
        .map((number) => number.toRadixString(16).padLeft(2, '0'))
        .join();
  }
}
