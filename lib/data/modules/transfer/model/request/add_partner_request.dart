import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_partner_request.g.dart';

@JsonSerializable()
class GetPartnerRequest extends Equatable {
  @JsonKey(name: 'userId')
  final String? userId;

  @JsonKey(name: 'userAddress')
  final String? userAddress;

  const GetPartnerRequest(
      {this.userId,
      this.userAddress});

  @override
  List<Object?> get props =>
      [userId, userAddress];

  Map<String, dynamic> toJson() => _$GetPartnerRequestToJson(this);

  factory GetPartnerRequest.fromJson(Map<String, dynamic> json) =>
      _$GetPartnerRequestFromJson(json);
}
