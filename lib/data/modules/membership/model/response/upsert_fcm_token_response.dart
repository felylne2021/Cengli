import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'upsert_fcm_token_response.g.dart';

@JsonSerializable()
class UpsertFcmTokenResponse extends Equatable {
  @JsonKey(name: 'walletAddress')
  final String? walletAddress;

  @JsonKey(name: 'fcmToken')
  final String? fcmToken;

  @JsonKey(name: 'createAt')
  final String? createAt;

   @JsonKey(name: 'updatedAt')
  final String? updatedAt;

  const UpsertFcmTokenResponse({
    this.walletAddress,
    this.fcmToken,
    this.createAt,
    this.updatedAt
  });

  @override
  List<Object?> get props => [walletAddress, fcmToken, createAt, updatedAt];

  Map<String, dynamic> toJson() => _$UpsertFcmTokenResponseToJson(this);

  factory UpsertFcmTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$UpsertFcmTokenResponseFromJson(json);
}
