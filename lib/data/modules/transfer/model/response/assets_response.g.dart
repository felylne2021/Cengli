// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assets_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetsResponse _$AssetsResponseFromJson(Map<String, dynamic> json) =>
    AssetsResponse(
      totalBalanceUsd: (json['totalBalanceUsd'] as num?)?.toDouble(),
      tokens: (json['tokens'] as List<dynamic>?)
          ?.map((e) => BalanceResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AssetsResponseToJson(AssetsResponse instance) =>
    <String, dynamic>{
      'totalBalanceUsd': instance.totalBalanceUsd,
      'tokens': instance.tokens,
    };
