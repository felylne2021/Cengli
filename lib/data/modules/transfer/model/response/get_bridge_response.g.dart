// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_bridge_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBridgeResponse _$GetBridgeResponseFromJson(Map<String, dynamic> json) =>
    GetBridgeResponse(
      id: json['id'] as String?,
      bridgeAddress: json['bridgeAddress'] as String?,
      chainId: json['chainId'] as int?,
      tokenAddress: json['tokenAddress'] as String?,
      destinationTokenAddress: json['destinationTokenAddress'] as String?,
    );

Map<String, dynamic> _$GetBridgeResponseToJson(GetBridgeResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bridgeAddress': instance.bridgeAddress,
      'chainId': instance.chainId,
      'tokenAddress': instance.tokenAddress,
      'destinationTokenAddress': instance.destinationTokenAddress,
    };
