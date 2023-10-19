import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'domain_response.g.dart';

@JsonSerializable()
class DomainResponse extends Equatable {
  @JsonKey(name: 'chainId')
  final String? chainId;

  @JsonKey(name: 'verifyingContract')
  final String? verifyingContract;

  const DomainResponse(
      {this.chainId,
      this.verifyingContract});

  @override
  List<Object?> get props => [
        chainId,
        verifyingContract
      ];

  Map<String, dynamic> toJson() => _$DomainResponseToJson(this);

  factory DomainResponse.fromJson(Map<String, dynamic> json) =>
      _$DomainResponseFromJson(json);
}
