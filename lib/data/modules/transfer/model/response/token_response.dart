import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token_response.g.dart';

@JsonSerializable()
class TokenResponse extends Equatable {
  @JsonKey(name: 'address')
  final String? address;

  @JsonKey(name: 'chainId')
  final int? chainId;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'symbol')
  final String? symbol;

  @JsonKey(name: 'decimals')
  final double? decimals;

  @JsonKey(name: 'logoURI')
  final String? logoURI;

  @JsonKey(name: 'priceUsd')
  final double? priceUsd;

  const TokenResponse(
      {this.address,
      this.chainId,
      this.name,
      this.symbol,
      this.decimals,
      this.logoURI,
      this.priceUsd});

  @override
  List<Object?> get props => [address, chainId, name, symbol, decimals, logoURI, priceUsd];

  Map<String, dynamic> toJson() => _$TokenResponseToJson(this);

  factory TokenResponse.fromJson(Map<String, dynamic> json) => _$TokenResponseFromJson(json);
}
