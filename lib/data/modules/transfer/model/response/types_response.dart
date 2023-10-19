import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'types_response.g.dart';

@JsonSerializable()
class TypesResponse extends Equatable {
  @JsonKey(name: 'to')
  final String? to;

  @JsonKey(name: 'value')
  final String? value;

  @JsonKey(name: 'data')
  final String? data;

  @JsonKey(name: 'operation')
  final String? operation;

  @JsonKey(name: 'safeTxGas')
  final String? safeTxGas;

  @JsonKey(name: 'baseGas')
  final String? baseGas;

  @JsonKey(name: 'gasPrice')
  final String? gasPrice;

  @JsonKey(name: 'gasToken')
  final String? gasToken;

  @JsonKey(name: 'refundReceiver')
  final String? refundReceiver;

  @JsonKey(name: 'nonce')
  final String? nonce;

  const TypesResponse({
    this.to,
    this.value,
    this.data,
    this.operation,
    this.safeTxGas,
    this.baseGas,
    this.gasPrice,
    this.gasToken,
    this.refundReceiver,
    this.nonce,
  });

  @override
  List<Object?> get props => [
        to,
        value,
        data,
        operation,
        safeTxGas,
        baseGas,
        gasPrice,
        gasToken,
        refundReceiver,
        nonce,
      ];

  Map<String, dynamic> toJson() => _$TypesResponseToJson(this);

  factory TypesResponse.fromJson(Map<String, dynamic> json) =>
      _$TypesResponseFromJson(json);
}
