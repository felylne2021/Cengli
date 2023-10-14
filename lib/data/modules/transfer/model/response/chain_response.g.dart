// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chain_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChainResponse _$ChainResponseFromJson(Map<String, dynamic> json) =>
    ChainResponse(
      chainId: json['chainId'] as int?,
      chainName: json['chainName'] as String?,
      rpcUrl: json['rpcUrl'] as String?,
      nativeCurrency: json['nativeCurrency'] == null
          ? null
          : CurrencyResponse.fromJson(
              json['nativeCurrency'] as Map<String, dynamic>),
      blockExplorer: json['blockExplorer'] as String?,
      logoURI: json['logoURI'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$ChainResponseToJson(ChainResponse instance) =>
    <String, dynamic>{
      'chainId': instance.chainId,
      'chainName': instance.chainName,
      'rpcUrl': instance.rpcUrl,
      'nativeCurrency': instance.nativeCurrency,
      'blockExplorer': instance.blockExplorer,
      'logoURI': instance.logoURI,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
