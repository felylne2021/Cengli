// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upsert_fcm_token_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpsertFcmTokenRequest _$UpsertFcmTokenRequestFromJson(
        Map<String, dynamic> json) =>
    UpsertFcmTokenRequest(
      walletAddress: json['walletAddress'] as String?,
      fcmToken: json['fcmToken'] as String?,
    );

Map<String, dynamic> _$UpsertFcmTokenRequestToJson(
        UpsertFcmTokenRequest instance) =>
    <String, dynamic>{
      'walletAddress': instance.walletAddress,
      'fcmToken': instance.fcmToken,
    };
