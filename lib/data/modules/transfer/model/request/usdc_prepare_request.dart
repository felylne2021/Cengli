import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'usdc_prepare_request.g.dart';

@JsonSerializable()
class UsdcPrepareRequest extends Equatable {
  @JsonKey(name: 'walletAddress')
  final String? walletAddress;

  @JsonKey(name: 'recipientAddress')
  final String? recipientAddress;

  @JsonKey(name: 'fromChainId')
  final int? fromChainId;

   @JsonKey(name: 'destinationChainId')
  final int? destinationChainId;

    @JsonKey(name: 'amount')
  final int? amount;

  const UsdcPrepareRequest(
      {this.walletAddress,
      this.recipientAddress,
      this.fromChainId,
      this.destinationChainId,
      this.amount});

  @override
  List<Object?> get props => [
        walletAddress,
        recipientAddress,
        fromChainId,
        destinationChainId,
        amount
      ];

  Map<String, dynamic> toJson() => _$UsdcPrepareRequestToJson(this);

  factory UsdcPrepareRequest.fromJson(Map<String, dynamic> json) =>
      _$UsdcPrepareRequestFromJson(json);
}
