import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_chat_response.g.dart';

@JsonSerializable()
class OrderChatResponse extends Equatable {
  @JsonKey(name: 'orderId')
  final String? orderId;

  @JsonKey(name: 'chatId')
  final String? chatId;

  @JsonKey(name: 'isActive')
  final bool? isActive;

  const OrderChatResponse({this.orderId, this.chatId, this.isActive});

  @override
  List<Object?> get props => [orderId, chatId, isActive];

  Map<String, dynamic> toJson() => _$OrderChatResponseToJson(this);

  factory OrderChatResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderChatResponseFromJson(json);
}
