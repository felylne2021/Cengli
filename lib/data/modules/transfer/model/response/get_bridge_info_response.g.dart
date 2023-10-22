// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_bridge_info_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBridgeInfoResponse _$GetBridgeInfoResponseFromJson(
        Map<String, dynamic> json) =>
    GetBridgeInfoResponse(
      route: json['route'] as String?,
      routeType: json['route_type'] as String?,
      description: json['description'] as String?,
      fromBridgeAddress: json['fromBridgeAddress'] as String?,
      destinationBridgeAddress: json['destinationBridgeAddress'] as String?,
    );

Map<String, dynamic> _$GetBridgeInfoResponseToJson(
        GetBridgeInfoResponse instance) =>
    <String, dynamic>{
      'route': instance.route,
      'route_type': instance.routeType,
      'description': instance.description,
      'fromBridgeAddress': instance.fromBridgeAddress,
      'destinationBridgeAddress': instance.destinationBridgeAddress,
    };
