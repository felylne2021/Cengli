// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_chat_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderChatResponse _$OrderChatResponseFromJson(Map<String, dynamic> json) =>
    OrderChatResponse(
      orderId: json['orderId'] as String?,
      chatId: json['chatId'] as String?,
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$OrderChatResponseToJson(OrderChatResponse instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'chatId': instance.chatId,
      'isActive': instance.isActive,
    };
