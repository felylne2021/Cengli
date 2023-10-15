// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferResponse _$TransferResponseFromJson(Map<String, dynamic> json) =>
    TransferResponse(
      id: json['id'] as String?,
      fromUserId: json['fromUserId'] as String?,
      destinationUserId: json['destinationUserId'] as String?,
      fromAddress: json['fromAddress'] as String?,
      destinationAddress: json['destinationAddress'] as String?,
      fromChainId: json['fromChainId'] as int?,
      tokenAddress: json['tokenAddress'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      note: json['note'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$TransferResponseToJson(TransferResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromUserId': instance.fromUserId,
      'destinationUserId': instance.destinationUserId,
      'fromAddress': instance.fromAddress,
      'destinationAddress': instance.destinationAddress,
      'fromChainId': instance.fromChainId,
      'tokenAddress': instance.tokenAddress,
      'amount': instance.amount,
      'note': instance.note,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
