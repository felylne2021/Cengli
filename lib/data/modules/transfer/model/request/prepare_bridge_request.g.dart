// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prepare_bridge_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrepareBridgeRequest _$PrepareBridgeRequestFromJson(
        Map<String, dynamic> json) =>
    PrepareBridgeRequest(
      walletAddress: json['walletAddress'] as String?,
      recipientAddress: json['recipientAddress'] as String?,
      tokenAddress: json['tokenAddress'] as String?,
      fromChainId: json['fromChainId'] as int?,
      destinationChainId: json['destinationChainId'] as int?,
      amount: json['amount'] as String?,
    );

Map<String, dynamic> _$PrepareBridgeRequestToJson(
        PrepareBridgeRequest instance) =>
    <String, dynamic>{
      'walletAddress': instance.walletAddress,
      'recipientAddress': instance.recipientAddress,
      'tokenAddress': instance.tokenAddress,
      'fromChainId': instance.fromChainId,
      'destinationChainId': instance.destinationChainId,
      'amount': instance.amount,
    };
