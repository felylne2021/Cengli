// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrderRequest _$CreateOrderRequestFromJson(Map<String, dynamic> json) =>
    CreateOrderRequest(
      partnerId: json['partnerId'] as String?,
      buyerUserId: json['buyerUserId'] as String?,
      buyerAddress: json['buyerAddress'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      chatId: json['chatId'] as String?,
      destinationChainId: json['destinationChainId'] as int?,
      tokenAddress: json['tokenAddress'] as String?,
      chainId: json['chainId'] as int?,
    );

Map<String, dynamic> _$CreateOrderRequestToJson(CreateOrderRequest instance) =>
    <String, dynamic>{
      'partnerId': instance.partnerId,
      'buyerUserId': instance.buyerUserId,
      'buyerAddress': instance.buyerAddress,
      'amount': instance.amount,
      'chatId': instance.chatId,
      'destinationChainId': instance.destinationChainId,
      'tokenAddress': instance.tokenAddress,
      'chainId': instance.chainId,
    };
