import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'safe_transaction_request.g.dart';

@JsonSerializable()
class SafeTransactionRequest extends Equatable {
  @JsonKey(name: 'from')
  final String? from;

  @JsonKey(name: 'to')
  final String? to;

  @JsonKey(name: 'value')
  final String? value;

  @JsonKey(name: 'data')
  final String? data;

  const SafeTransactionRequest(
      {this.from,
      this.to,
      this.value,
      this.data});

  @override
  List<Object?> get props => [
        from,
        to,
        value,
        data
      ];

  Map<String, dynamic> toJson() => _$SafeTransactionRequestToJson(this);

  factory SafeTransactionRequest.fromJson(Map<String, dynamic> json) =>
      _$SafeTransactionRequestFromJson(json);
}
