import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_response.g.dart';

@JsonSerializable()
class TransactionResponse extends Equatable {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'fromUserId')
  final String? fromUserId;

  @JsonKey(name: 'destinationUserId')
  final String? destinationUserId;

  @JsonKey(name: 'fromAddress')
  final String? fromAddress;

  @JsonKey(name: 'destinationAddress')
  final String? destinationAddress;

  @JsonKey(name: 'chainId')
  final int? chainId;

  @JsonKey(name: 'tokenAddress')
  final String? tokenAddress;

  @JsonKey(name: 'amount')
  final int? amount;

  @JsonKey(name: 'note')
  final String? note;
  
  @JsonKey(name: 'createdAt')
  final String? createdAt;

  @JsonKey(name: 'updatedAt')
  final String? updatedAt;

  const TransactionResponse(
      {this.id,
      this.fromUserId,
      this.destinationUserId,
      this.fromAddress,
      this.destinationAddress,
      this.chainId,
      this.tokenAddress,
      this.amount,
      this.note,
      this.createdAt,
      this.updatedAt});

  @override
  List<Object?> get props => [
        id,
        fromUserId,
        destinationUserId,
        fromAddress,
        destinationAddress,
        chainId,
        tokenAddress,
        amount,
        note,
        createdAt,
        updatedAt
      ];

  Map<String, dynamic> toJson() => _$TransactionResponseToJson(this);

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseFromJson(json);
}
