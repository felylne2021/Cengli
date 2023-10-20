// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_payload_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationPayloadRequest _$NotificationPayloadRequestFromJson(
        Map<String, dynamic> json) =>
    NotificationPayloadRequest(
      title: json['title'] as String?,
      body: json['body'] as String?,
      screen: json['screen'] as String?,
    );

Map<String, dynamic> _$NotificationPayloadRequestToJson(
        NotificationPayloadRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
      'screen': instance.screen,
    };
