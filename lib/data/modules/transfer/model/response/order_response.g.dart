// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderResponse _$OrderResponseFromJson(Map<String, dynamic> json) =>
    OrderResponse(
      id: json['id'] as String?,
      partnerId: json['partnerId'] as String?,
      buyerUserId: json['buyerUserId'] as String?,
      buyerAddress: json['buyerAddress'] as String?,
      destinationChainId: json['destinationChainId'] as int?,
      tokenAddress: json['tokenAddress'] as String?,
      amount: json['amount'] as int?,
      status: json['status'] as String?,
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      chat: json['chat'] == null
          ? null
          : OrderChatResponse.fromJson(json['chat'] as Map<String, dynamic>),
      token: json['token'] == null
          ? null
          : TokenResponse.fromJson(json['token'] as Map<String, dynamic>),
      partner: json['partner'] == null
          ? null
          : PartnerBalanceResponse.fromJson(
              json['partner'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderResponseToJson(OrderResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'partnerId': instance.partnerId,
      'buyerUserId': instance.buyerUserId,
      'buyerAddress': instance.buyerAddress,
      'destinationChainId': instance.destinationChainId,
      'tokenAddress': instance.tokenAddress,
      'amount': instance.amount,
      'status': instance.status,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'chat': instance.chat,
      'token': instance.token,
      'partner': instance.partner,
    };
