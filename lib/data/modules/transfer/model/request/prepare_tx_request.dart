import 'package:cengli/data/modules/transfer/model/request/safe_transaction_request.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prepare_tx_request.g.dart';

@JsonSerializable()
class PrepareTxRequest extends Equatable {
  @JsonKey(name: 'walletAddress')
  final String? walletAddress;

  @JsonKey(name: 'safeTransactionData')
  final SafeTransactionRequest? safeTransactionData;

  const PrepareTxRequest(
      {this.walletAddress,
      this.safeTransactionData});

  @override
  List<Object?> get props => [
        walletAddress,
        safeTransactionData
      ];

  Map<String, dynamic> toJson() => _$PrepareTxRequestToJson(this);

  factory PrepareTxRequest.fromJson(Map<String, dynamic> json) =>
      _$PrepareTxRequestFromJson(json);
}
