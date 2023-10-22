// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prepare_erc20_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrepareErc20Request _$PrepareErc20RequestFromJson(Map<String, dynamic> json) =>
    PrepareErc20Request(
      walletAddress: json['walletAddress'] as String?,
      tokenAddress: json['tokenAddress'] as String?,
      functionName: json['functionName'] as String?,
      chainId: json['chainId'] as int?,
      args: (json['args'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PrepareErc20RequestToJson(
        PrepareErc20Request instance) =>
    <String, dynamic>{
      'walletAddress': instance.walletAddress,
      'tokenAddress': instance.tokenAddress,
      'functionName': instance.functionName,
      'chainId': instance.chainId,
      'args': instance.args,
    };
