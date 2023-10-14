// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenResponse _$TokenResponseFromJson(Map<String, dynamic> json) =>
    TokenResponse(
      address: json['address'] as String?,
      chainId: json['chainId'] as int?,
      name: json['name'] as String?,
      symbol: json['symbol'] as String?,
      decimals: (json['decimals'] as num?)?.toDouble(),
      logoURI: json['logoURI'] as String?,
      priceUsd: (json['priceUsd'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$TokenResponseToJson(TokenResponse instance) =>
    <String, dynamic>{
      'address': instance.address,
      'chainId': instance.chainId,
      'name': instance.name,
      'symbol': instance.symbol,
      'decimals': instance.decimals,
      'logoURI': instance.logoURI,
      'priceUsd': instance.priceUsd,
    };
