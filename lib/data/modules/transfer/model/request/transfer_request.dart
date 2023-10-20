import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transfer_request.g.dart';

@JsonSerializable()
class TransferRequest extends Equatable {
  @JsonKey(name: 'fromUserId')
  final String? fromUserId;

  @JsonKey(name: 'destinationUserId')
  final String? destinationUserId;

  @JsonKey(name: 'fromAddress')
  final String? fromAddress;

  @JsonKey(name: 'destinationAddress')
  final String? destinationAddress;

  @JsonKey(name: 'tokenAddress')
  final String? tokenAddress;

  @JsonKey(name: 'fromChainId')
  final int? fromChainId;

  @JsonKey(name: 'destinationChainId')
  final int? destinationChainId;

  @JsonKey(name: 'amount')
  final int? amount;

  @JsonKey(name: 'note')
  final String? note;

  @JsonKey(name: 'signer')
  final String? signer;

  const TransferRequest(
      {this.fromUserId,
      this.destinationUserId,
      this.fromAddress,
      this.destinationAddress,
      this.tokenAddress,
      this.fromChainId,
      this.destinationChainId,
      this.amount,
      this.note,
      this.signer});

  @override
  List<Object?> get props => [
        fromUserId,
        destinationUserId,
        fromAddress,
        destinationAddress,
        tokenAddress,
        fromChainId,
        destinationChainId,
        amount,
        note,
        signer
      ];

  Map<String, dynamic> toJson() => _$TransferRequestToJson(this);

  factory TransferRequest.fromJson(Map<String, dynamic> json) =>
      _$TransferRequestFromJson(json);
}
