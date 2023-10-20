// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'safe_transaction_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SafeTransactionRequest _$SafeTransactionRequestFromJson(
        Map<String, dynamic> json) =>
    SafeTransactionRequest(
      from: json['from'] as String?,
      to: json['to'] as String?,
      value: json['value'] as String?,
      data: json['data'] as String?,
    );

Map<String, dynamic> _$SafeTransactionRequestToJson(
        SafeTransactionRequest instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'value': instance.value,
      'data': instance.data,
    };
