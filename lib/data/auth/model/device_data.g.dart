// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceData _$DeviceDataFromJson(Map<String, dynamic> json) => DeviceData(
      browser: json['browser'] as String,
      os: json['os'] as String,
      platform: json['platform'] as String,
    );

Map<String, dynamic> _$DeviceDataToJson(DeviceData instance) =>
    <String, dynamic>{
      'browser': instance.browser,
      'os': instance.os,
      'platform': instance.platform,
    };
