import 'package:cengli/values/values.dart';

class AssetResponse {
  final String? imagePath;
  final String? assetType;
  final double? count;
  final String? unit;
  final double? value;

  const AssetResponse(
      this.imagePath, this.assetType, this.count, this.unit, this.value);
}

List<AssetResponse> assets = const [
  AssetResponse(IC_ASSET_USDC, "USDC", 105, "USDC", 829.14),
  AssetResponse(IC_ASSET_USDT, "USDT", 105, "USDT", 829.14),
  AssetResponse(IC_POLYGON, "POLYGON", 105, "MATIC", 829.14),
];
