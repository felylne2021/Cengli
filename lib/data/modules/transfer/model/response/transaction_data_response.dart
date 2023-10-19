import 'package:cengli/data/modules/transfer/model/response/domain_response.dart';
import 'package:cengli/data/modules/transfer/model/response/types_response.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_data_response.g.dart';

@JsonSerializable()
class TransactionDataResponse extends Equatable {
  @JsonKey(name: 'domain')
  final DomainResponse? domain;

  @JsonKey(name: 'types')
  final TypesResponse? types;

  const TransactionDataResponse(
      {this.domain,
      this.types});

  @override
  List<Object?> get props => [
        domain,
        types
      ];

  Map<String, dynamic> toJson() => _$TransactionDataResponseToJson(this);

  factory TransactionDataResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionDataResponseFromJson(json);
}
