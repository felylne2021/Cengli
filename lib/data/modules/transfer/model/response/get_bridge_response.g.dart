// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_bridge_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBridgeResponse _$GetBridgeResponseFromJson(Map<String, dynamic> json) =>
    GetBridgeResponse(
      fromBridgeAddress: json['fromBridgeAddress'] as String?,
      destinationBridgeAddress: json['destinationBridgeAddress'] as String?,
    );

Map<String, dynamic> _$GetBridgeResponseToJson(GetBridgeResponse instance) =>
    <String, dynamic>{
      'fromBridgeAddress': instance.fromBridgeAddress,
      'destinationBridgeAddress': instance.destinationBridgeAddress,
    };
