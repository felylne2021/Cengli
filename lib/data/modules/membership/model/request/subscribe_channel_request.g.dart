// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscribe_channel_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscribeChannelRequest _$SubscribeChannelRequestFromJson(
        Map<String, dynamic> json) =>
    SubscribeChannelRequest(
      walletAddress: json['walletAddress'] as String?,
      pgpk: json['pgpk'] as String?,
    );

Map<String, dynamic> _$SubscribeChannelRequestToJson(
        SubscribeChannelRequest instance) =>
    <String, dynamic>{
      'walletAddress': instance.walletAddress,
      'pgpk': instance.pgpk,
    };
