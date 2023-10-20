// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferRequest _$TransferRequestFromJson(Map<String, dynamic> json) =>
    TransferRequest(
      fromUserId: json['fromUserId'] as String?,
      destinationUserId: json['destinationUserId'] as String?,
      fromAddress: json['fromAddress'] as String?,
      destinationAddress: json['destinationAddress'] as String?,
      tokenAddress: json['tokenAddress'] as String?,
      fromChainId: json['fromChainId'] as int?,
      destinationChainId: json['destinationChainId'] as int?,
      amount: json['amount'] as int?,
      note: json['note'] as String?,
      signer: json['signer'] as String?,
    );

Map<String, dynamic> _$TransferRequestToJson(TransferRequest instance) =>
    <String, dynamic>{
      'fromUserId': instance.fromUserId,
      'destinationUserId': instance.destinationUserId,
      'fromAddress': instance.fromAddress,
      'destinationAddress': instance.destinationAddress,
      'tokenAddress': instance.tokenAddress,
      'fromChainId': instance.fromChainId,
      'destinationChainId': instance.destinationChainId,
      'amount': instance.amount,
      'note': instance.note,
      'signer': instance.signer,
    };
