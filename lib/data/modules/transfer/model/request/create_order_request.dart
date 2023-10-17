import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_order_request.g.dart';

@JsonSerializable()
class CreateOrderRequest extends Equatable {
  @JsonKey(name: 'partnerId')
  final String? partnerId;

  @JsonKey(name: 'buyerUserId')
  final String? buyerUserId;

  @JsonKey(name: 'buyerAddress')
  final String? buyerAddress;

  @JsonKey(name: 'amount')
  final double? amount;

  @JsonKey(name: 'chatId')
  final String? chatId;

  @JsonKey(name: 'destinationChainId')
  final int? destinationChainId;

  @JsonKey(name: 'tokenAddress')
  final String? tokenAddress;

  @JsonKey(name: 'chainId')
  final int? chainId;

  const CreateOrderRequest(
      {this.partnerId,
      this.buyerUserId,
      this.buyerAddress,
      this.amount,
      this.chatId,
      this.destinationChainId,
      this.tokenAddress,
      this.chainId});

  @override
  List<Object?> get props => [
        partnerId,
        buyerUserId,
        buyerAddress,
        amount,
        chatId,
        destinationChainId,
        tokenAddress,
        chainId
      ];

  Map<String, dynamic> toJson() => _$CreateOrderRequestToJson(this);

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderRequestFromJson(json);
}
