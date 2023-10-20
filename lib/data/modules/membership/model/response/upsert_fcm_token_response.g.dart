// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upsert_fcm_token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpsertFcmTokenResponse _$UpsertFcmTokenResponseFromJson(
        Map<String, dynamic> json) =>
    UpsertFcmTokenResponse(
      walletAddress: json['walletAddress'] as String?,
      fcmToken: json['fcmToken'] as String?,
      createAt: json['createAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$UpsertFcmTokenResponseToJson(
        UpsertFcmTokenResponse instance) =>
    <String, dynamic>{
      'walletAddress': instance.walletAddress,
      'fcmToken': instance.fcmToken,
      'createAt': instance.createAt,
      'updatedAt': instance.updatedAt,
    };
