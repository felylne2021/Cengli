import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prepare_bridge_request.g.dart';

@JsonSerializable()
class PrepareBridgeRequest extends Equatable {
  @JsonKey(name: 'walletAddress')
  final String? walletAddress;

  @JsonKey(name: 'recipientAddress')
  final String? recipientAddress;

  @JsonKey(name: 'tokenAddress')
  final String? tokenAddress;

  @JsonKey(name: 'fromChainId')
  final int? fromChainId;

  @JsonKey(name: 'destinationChainId')
  final int? destinationChainId;

  @JsonKey(name: 'amount')
  final String? amount;

  const PrepareBridgeRequest(
      {this.walletAddress,
      this.recipientAddress,
      this.tokenAddress,
      this.fromChainId,
      this.destinationChainId,
      this.amount});

  @override
  List<Object?> get props => [
        walletAddress,
        recipientAddress,
        tokenAddress,
        fromChainId,
        destinationChainId,
        amount
      ];

  Map<String, dynamic> toJson() => _$PrepareBridgeRequestToJson(this);

  factory PrepareBridgeRequest.fromJson(Map<String, dynamic> json) =>
      _$PrepareBridgeRequestFromJson(json);
}
