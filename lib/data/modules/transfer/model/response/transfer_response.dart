import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transfer_response.g.dart';

@JsonSerializable()
class TransferResponse extends Equatable {
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

  @JsonKey(name: 'fromChainId')
  final int? fromChainId;

  @JsonKey(name: 'tokenAddress')
  final String? tokenAddress;

  @JsonKey(name: 'amount')
  final double? amount;

  @JsonKey(name: 'note')
  final String? note;

  @JsonKey(name: 'createdAt')
  final String? createdAt;

  @JsonKey(name: 'updatedAt')
  final String? updatedAt;

  const TransferResponse(
      {this.id,
      this.fromUserId,
      this.destinationUserId,
      this.fromAddress,
      this.destinationAddress,
      this.fromChainId,
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
        fromChainId,
        tokenAddress,
        amount,
        note,
        createdAt,
        updatedAt
      ];

  Map<String, dynamic> toJson() => _$TransferResponseToJson(this);

  factory TransferResponse.fromJson(Map<String, dynamic> json) =>
      _$TransferResponseFromJson(json);
}
