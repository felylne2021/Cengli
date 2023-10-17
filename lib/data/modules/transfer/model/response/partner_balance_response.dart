import 'package:cengli/data/modules/transfer/model/response/token_response.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'partner_balance_response.g.dart';

@JsonSerializable()
class PartnerBalanceResponse extends Equatable {
  @JsonKey(name: 'partnerId')
  final String? partnerId;

  @JsonKey(name: 'tokenAddress')
  final String? tokenAddress;

  @JsonKey(name: 'tokenChainId')
  final int? tokenChainId;

  @JsonKey(name: 'amount')
  final double? amount;

  @JsonKey(name: 'token')
  final TokenResponse? token;

  const PartnerBalanceResponse(
      {this.partnerId,
      this.tokenAddress,
      this.tokenChainId,
      this.amount,
      this.token});

  @override
  List<Object?> get props =>
      [partnerId, tokenAddress, tokenChainId, amount, token];

  Map<String, dynamic> toJson() => _$PartnerBalanceResponseToJson(this);

  factory PartnerBalanceResponse.fromJson(Map<String, dynamic> json) =>
      _$PartnerBalanceResponseFromJson(json);
}
