// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateOrderResponse _$UpdateOrderResponseFromJson(Map<String, dynamic> json) =>
    UpdateOrderResponse(
      id: json['id'] as String?,
      partnerId: json['partnerId'] as String?,
      buyerUserId: json['buyerUserId'] as String?,
      buyerAddress: json['buyerAddress'] as String?,
      destinationChainId: json['destinationChainId'] as int?,
      tokenAddress: json['tokenAddress'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      status: json['status'] as String?,
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$UpdateOrderResponseToJson(
        UpdateOrderResponse instance) =>
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
    };
