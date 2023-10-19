// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionDataResponse _$TransactionDataResponseFromJson(
        Map<String, dynamic> json) =>
    TransactionDataResponse(
      domain: json['domain'] == null
          ? null
          : DomainResponse.fromJson(json['domain'] as Map<String, dynamic>),
      types: json['types'] == null
          ? null
          : TypesResponse.fromJson(json['types'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionDataResponseToJson(
        TransactionDataResponse instance) =>
    <String, dynamic>{
      'domain': instance.domain,
      'types': instance.types,
    };
