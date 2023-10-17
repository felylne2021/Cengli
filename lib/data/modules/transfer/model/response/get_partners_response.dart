import 'package:cengli/data/modules/transfer/model/response/partner_balance_response.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_partners_response.g.dart';

@JsonSerializable()
class GetPartnersResponse extends Equatable {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'userId')
  final String? userId;

  @JsonKey(name: 'address')
  final String? address;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'createdAt')
  final String? createdAt;

  @JsonKey(name: 'updatedAt')
  final String? updatedAt;

  @JsonKey(name: 'balances')
  final List<PartnerBalanceResponse>? balances;

  const GetPartnersResponse(
      {this.id,
      this.userId,
      this.address,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.balances});

  @override
  List<Object?> get props =>
      [id, userId, address, name, createdAt, updatedAt, balances];

  Map<String, dynamic> toJson() => _$GetPartnersResponseToJson(this);

  factory GetPartnersResponse.fromJson(Map<String, dynamic> json) =>
      _$GetPartnersResponseFromJson(json);
}
