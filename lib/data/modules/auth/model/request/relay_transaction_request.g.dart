// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relay_transaction_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelayTransactionRequest _$RelayTransactionRequestFromJson(
        Map<String, dynamic> json) =>
    RelayTransactionRequest(
      to: json['to'] as String?,
      value: json['value'] as String?,
      data: json['data'] as String?,
      operation: json['operation'] as String?,
      safeTxGas: json['safeTxGas'] as String?,
      baseGas: json['baseGas'] as String?,
      gasPrice: json['gasPrice'] as String?,
      gasToken: json['gasToken'] as String?,
      refundReceiver: json['refundReceiver'] as String?,
      nonce: json['nonce'] as String?,
      signatures: json['signatures'] as String?,
    );

Map<String, dynamic> _$RelayTransactionRequestToJson(
        RelayTransactionRequest instance) =>
    <String, dynamic>{
      'to': instance.to,
      'value': instance.value,
      'data': instance.data,
      'operation': instance.operation,
      'safeTxGas': instance.safeTxGas,
      'baseGas': instance.baseGas,
      'gasPrice': instance.gasPrice,
      'gasToken': instance.gasToken,
      'refundReceiver': instance.refundReceiver,
      'nonce': instance.nonce,
      'signatures': instance.signatures,
    };
