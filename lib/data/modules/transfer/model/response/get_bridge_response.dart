import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_bridge_response.g.dart';

@JsonSerializable()
class GetBridgeResponse extends Equatable {
  @JsonKey(name: 'fromBridgeAddress')
  final String? fromBridgeAddress;

  @JsonKey(name: 'destinationBridgeAddress')
  final String? destinationBridgeAddress;

  const GetBridgeResponse(
      {this.fromBridgeAddress,
      this.destinationBridgeAddress});

  @override
  List<Object?> get props =>
      [fromBridgeAddress, destinationBridgeAddress];

  Map<String, dynamic> toJson() => _$GetBridgeResponseToJson(this);

  factory GetBridgeResponse.fromJson(Map<String, dynamic> json) =>
      _$GetBridgeResponseFromJson(json);
}
