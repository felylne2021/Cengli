import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'currency_response.g.dart';

@JsonSerializable()
class CurrencyResponse extends Equatable {
  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'symbol')
  final String? symbol;

  @JsonKey(name: 'decimals')
  final double? decimals;

  const CurrencyResponse({this.name, this.symbol, this.decimals});

  @override
  List<Object?> get props => [name, symbol, decimals];

  Map<String, dynamic> toJson() => _$CurrencyResponseToJson(this);

  factory CurrencyResponse.fromJson(Map<String, dynamic> json) =>
      _$CurrencyResponseFromJson(json);
}
