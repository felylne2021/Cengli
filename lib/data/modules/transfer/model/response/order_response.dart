import 'package:cengli/data/modules/transfer/model/response/order_chat_response.dart';
import 'package:cengli/data/modules/transfer/model/response/partner_balance_response.dart';
import 'package:cengli/data/modules/transfer/model/response/token_response.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_response.g.dart';

@JsonSerializable()
class OrderResponse extends Equatable {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'partnerId')
  final String? partnerId;

  @JsonKey(name: 'buyerUserId')
  final String? buyerUserId;

  @JsonKey(name: 'buyerAddress')
  final String? buyerAddress;

  @JsonKey(name: 'destinationChainId')
  final int? destinationChainId;

  @JsonKey(name: 'tokenAddress')
  final String? tokenAddress;

  @JsonKey(name: 'amount')
  final int? amount;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'isActive')
  final bool? isActive;

  @JsonKey(name: 'createdAt')
  final String? createdAt;

  @JsonKey(name: 'updatedAt')
  final String? updatedAt;

  @JsonKey(name: 'chat')
  final OrderChatResponse? chat;

  @JsonKey(name: 'token')
  final TokenResponse? token;

  @JsonKey(name: 'partner')
  final PartnerBalanceResponse? partner;

  const OrderResponse({
    this.id,
    this.partnerId,
    this.buyerUserId,
    this.buyerAddress,
    this.destinationChainId,
    this.tokenAddress,
    this.amount,
    this.status,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.chat,
    this.token,
    this.partner,
  });

  @override
  List<Object?> get props => [
        id,
        partnerId,
        buyerUserId,
        buyerAddress,
        destinationChainId,
        tokenAddress,
        amount,
        status,
        isActive,
        createdAt,
        updatedAt,
        chat,
        token,
        partner,
      ];

  Map<String, dynamic> toJson() => _$OrderResponseToJson(this);

  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseFromJson(json);
}
