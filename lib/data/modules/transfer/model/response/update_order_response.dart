import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_order_response.g.dart';

@JsonSerializable()
class UpdateOrderResponse extends Equatable {
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
  final double? amount;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'isActive')
  final bool? isActive;

  @JsonKey(name: 'createdAt')
  final String? createdAt;

  @JsonKey(name: 'updatedAt')
  final String? updatedAt;

  const UpdateOrderResponse({
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
      ];

  Map<String, dynamic> toJson() => _$UpdateOrderResponseToJson(this);

  factory UpdateOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateOrderResponseFromJson(json);
}
