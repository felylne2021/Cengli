import 'package:cengli/data/modules/transfer/model/response/token_response.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'balance_response.g.dart';

@JsonSerializable()
class BalanceResponse extends Equatable {
  @JsonKey(name: 'balance')
  final double? balance;

  @JsonKey(name: 'balanceUSd')
  final double? balanceUSd;

  @JsonKey(name: 'token')
  final TokenResponse? token;

  const BalanceResponse({this.balance, this.balanceUSd, this.token});

  @override
  List<Object?> get props => [balance, balanceUSd, token];

  Map<String, dynamic> toJson() => _$BalanceResponseToJson(this);

  factory BalanceResponse.fromJson(Map<String, dynamic> json) =>
      _$BalanceResponseFromJson(json);
}
