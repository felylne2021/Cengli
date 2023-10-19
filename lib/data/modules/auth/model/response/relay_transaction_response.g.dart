// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relay_transaction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelayTransactionResponse _$RelayTransactionResponseFromJson(
        Map<String, dynamic> json) =>
    RelayTransactionResponse(
      success: json['success'] as bool?,
      safeTxHash: json['safeTxHash'] as String?,
    );

Map<String, dynamic> _$RelayTransactionResponseToJson(
        RelayTransactionResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'safeTxHash': instance.safeTxHash,
    };
