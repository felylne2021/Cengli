import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_response.g.dart';

@JsonSerializable()
class OrderResponse extends Equatable {
  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'amount')
  final double? amount;

  @JsonKey(name: 'method')
  final String? method;

  @JsonKey(name: 'creator')
  final String? creator;

  @JsonKey(name: 'groupId')
  final double? groupId;

  const OrderResponse(
      {this.status,
      this.amount,
      this.method,
      this.creator,
      this.groupId});

  @override
  List<Object?> get props => [status, amount, method, creator, groupId];

  Map<String, dynamic> toJson() => _$OrderResponseToJson(this);

  factory OrderResponse.fromJson(Map<String, dynamic> json) => _$OrderResponseFromJson(json);
}
