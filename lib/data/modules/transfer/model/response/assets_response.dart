import 'package:cengli/data/modules/transfer/model/response/balance_response.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'assets_response.g.dart';

@JsonSerializable()
class AssetsResponse extends Equatable {
  @JsonKey(name: 'totalBalanceUsd')
  final double? totalBalanceUsd;

  @JsonKey(name: 'tokens')
  final List<BalanceResponse>? tokens;

  const AssetsResponse({this.totalBalanceUsd, this.tokens});

  @override
  List<Object?> get props =>
      [totalBalanceUsd, tokens];

  Map<String, dynamic> toJson() => _$AssetsResponseToJson(this);

  factory AssetsResponse.fromJson(Map<String, dynamic> json) =>
      _$AssetsResponseFromJson(json);
}
