// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderResponse _$OrderResponseFromJson(Map<String, dynamic> json) =>
    OrderResponse(
      status: json['status'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      method: json['method'] as String?,
      creator: json['creator'] as String?,
      groupId: (json['groupId'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$OrderResponseToJson(OrderResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'amount': instance.amount,
      'method': instance.method,
      'creator': instance.creator,
      'groupId': instance.groupId,
    };
