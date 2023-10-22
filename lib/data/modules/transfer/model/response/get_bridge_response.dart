import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_bridge_response.g.dart';

@JsonSerializable()
class GetBridgeResponse extends Equatable {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'bridgeAddress')
  final String? bridgeAddress;

  @JsonKey(name: 'chainId')
  final int? chainId;

  @JsonKey(name: 'tokenAddress')
  final String? tokenAddress;

  @JsonKey(name: 'destinationTokenAddress')
  final String? destinationTokenAddress;

  const GetBridgeResponse(
      {this.id,
      this.bridgeAddress,
      this.chainId,
      this.tokenAddress,
      this.destinationTokenAddress});

  @override
  List<Object?> get props =>
      [id, bridgeAddress, chainId, tokenAddress, destinationTokenAddress];

  Map<String, dynamic> toJson() => _$GetBridgeResponseToJson(this);

  factory GetBridgeResponse.fromJson(Map<String, dynamic> json) =>
      _$GetBridgeResponseFromJson(json);
}
