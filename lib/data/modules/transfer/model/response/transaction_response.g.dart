// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionResponse _$TransactionResponseFromJson(Map<String, dynamic> json) =>
    TransactionResponse(
      id: json['id'] as String?,
      fromUserId: json['fromUserId'] as String?,
      destinationUserId: json['destinationUserId'] as String?,
      fromAddress: json['fromAddress'] as String?,
      destinationAddress: json['destinationAddress'] as String?,
      chainId: json['chainId'] as int?,
      tokenAddress: json['tokenAddress'] as String?,
      amount: json['amount'] as int?,
      note: json['note'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$TransactionResponseToJson(
        TransactionResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromUserId': instance.fromUserId,
      'destinationUserId': instance.destinationUserId,
      'fromAddress': instance.fromAddress,
      'destinationAddress': instance.destinationAddress,
      'chainId': instance.chainId,
      'tokenAddress': instance.tokenAddress,
      'amount': instance.amount,
      'note': instance.note,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
