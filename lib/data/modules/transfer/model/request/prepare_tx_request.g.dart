// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prepare_tx_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrepareTxRequest _$PrepareTxRequestFromJson(Map<String, dynamic> json) =>
    PrepareTxRequest(
      walletAddress: json['walletAddress'] as String?,
      safeTransactionData: json['safeTransactionData'] == null
          ? null
          : SafeTransactionRequest.fromJson(
              json['safeTransactionData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PrepareTxRequestToJson(PrepareTxRequest instance) =>
    <String, dynamic>{
      'walletAddress': instance.walletAddress,
      'safeTransactionData': instance.safeTransactionData,
    };
