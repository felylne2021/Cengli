import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_bridge_info_response.g.dart';

@JsonSerializable()
class GetBridgeInfoResponse extends Equatable {
  @JsonKey(name: 'route')
  final String? route;

  @JsonKey(name: 'route_type')
  final String? routeType;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'fromBridgeAddress')
  final String? fromBridgeAddress;

   @JsonKey(name: 'destinationBridgeAddress')
  final String? destinationBridgeAddress;

  const GetBridgeInfoResponse(
      {this.route,
      this.routeType,
      this.description,
      this.fromBridgeAddress,
      this.destinationBridgeAddress});

  @override
  List<Object?> get props =>
      [route, routeType, description, fromBridgeAddress, destinationBridgeAddress];

  Map<String, dynamic> toJson() => _$GetBridgeInfoResponseToJson(this);

  factory GetBridgeInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$GetBridgeInfoResponseFromJson(json);
}
