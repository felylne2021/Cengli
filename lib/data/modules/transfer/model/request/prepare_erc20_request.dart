import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prepare_erc20_request.g.dart';

@JsonSerializable()
class PrepareErc20Request extends Equatable {
  @JsonKey(name: 'walletAddress')
  final String? walletAddress;

  @JsonKey(name: 'tokenAddress')
  final String? tokenAddress;

  @JsonKey(name: 'functionName')
  final String? functionName;
  
  @JsonKey(name: 'chainId')
  final int? chainId;

  @JsonKey(name: 'args')
  final List<String>? args;

  const PrepareErc20Request(
      {this.walletAddress,
      this.tokenAddress,
      this.functionName,
      this.chainId,
      this.args});

  @override
  List<Object?> get props => [
        walletAddress,
        tokenAddress,
        functionName,
        chainId,
        args
      ];

  Map<String, dynamic> toJson() => _$PrepareErc20RequestToJson(this);

  factory PrepareErc20Request.fromJson(Map<String, dynamic> json) =>
      _$PrepareErc20RequestFromJson(json);
}
