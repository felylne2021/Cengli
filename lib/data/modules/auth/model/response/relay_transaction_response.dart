import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'relay_transaction_response.g.dart';

@JsonSerializable()
class RelayTransactionResponse extends Equatable {
  @JsonKey(name: 'success')
  final bool? success;

  @JsonKey(name: 'safeTxHash')
  final String? safeTxHash;

  const RelayTransactionResponse({this.success, this.safeTxHash});

  @override
  List<Object?> get props => [success, safeTxHash];

  Map<String, dynamic> toJson() => _$RelayTransactionResponseToJson(this);

  factory RelayTransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$RelayTransactionResponseFromJson(json);
}
