import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'upsert_fcm_token_request.g.dart';

@JsonSerializable()
class UpsertFcmTokenRequest extends Equatable {
  @JsonKey(name: 'walletAddress')
  final String? walletAddress;

  @JsonKey(name: 'fcmToken')
  final String? fcmToken;

  const UpsertFcmTokenRequest(
      {this.walletAddress, this.fcmToken});

  @override
  List<Object?> get props => [walletAddress, fcmToken];

  Map<String, dynamic> toJson() => _$UpsertFcmTokenRequestToJson(this);

  factory UpsertFcmTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$UpsertFcmTokenRequestFromJson(json);
}
