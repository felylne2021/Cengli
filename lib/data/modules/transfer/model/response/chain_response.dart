import 'package:cengli/data/modules/transfer/model/response/currency_response.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chain_response.g.dart';

@JsonSerializable()
class ChainResponse extends Equatable {
  @JsonKey(name: 'chainId')
  final int? chainId;

  @JsonKey(name: 'chainName')
  final String? chainName;

  @JsonKey(name: 'rpcUrl')
  final String? rpcUrl;

  @JsonKey(name: 'nativeCurrency')
  final CurrencyResponse? nativeCurrency;

  @JsonKey(name: 'blockExplorer')
  final String? blockExplorer;

  @JsonKey(name: 'logoURI')
  final String? logoURI;

  @JsonKey(name: 'createdAt')
  final String? createdAt;

  @JsonKey(name: 'updatedAt')
  final String? updatedAt;

  const ChainResponse(
      {this.chainId,
      this.chainName,
      this.rpcUrl,
      this.nativeCurrency,
      this.blockExplorer,
      this.logoURI,
      this.createdAt,
      this.updatedAt});

  @override
  List<Object?> get props => [
        chainId,
        chainName,
        rpcUrl,
        nativeCurrency,
        blockExplorer,
        logoURI,
        createdAt,
        updatedAt
      ];

  Map<String, dynamic> toJson() => _$ChainResponseToJson(this);

  factory ChainResponse.fromJson(Map<String, dynamic> json) =>
      _$ChainResponseFromJson(json);
}
