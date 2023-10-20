// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usdc_prepare_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsdcPrepareRequest _$UsdcPrepareRequestFromJson(Map<String, dynamic> json) =>
    UsdcPrepareRequest(
      walletAddress: json['walletAddress'] as String?,
      recipientAddress: json['recipientAddress'] as String?,
      fromChainId: json['fromChainId'] as int?,
      destinationChainId: json['destinationChainId'] as int?,
      amount: json['amount'] as int?,
    );

Map<String, dynamic> _$UsdcPrepareRequestToJson(UsdcPrepareRequest instance) =>
    <String, dynamic>{
      'walletAddress': instance.walletAddress,
      'recipientAddress': instance.recipientAddress,
      'fromChainId': instance.fromChainId,
      'destinationChainId': instance.destinationChainId,
      'amount': instance.amount,
    };
