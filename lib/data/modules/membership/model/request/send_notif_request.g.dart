// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_notif_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendNotifRequest _$SendNotifRequestFromJson(Map<String, dynamic> json) =>
    SendNotifRequest(
      walletAddresses: (json['walletAddresses'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      notificationPayload: json['notificationPayload'] == null
          ? null
          : NotificationPayloadRequest.fromJson(
              json['notificationPayload'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SendNotifRequestToJson(SendNotifRequest instance) =>
    <String, dynamic>{
      'walletAddresses': instance.walletAddresses,
      'notificationPayload': instance.notificationPayload,
    };
