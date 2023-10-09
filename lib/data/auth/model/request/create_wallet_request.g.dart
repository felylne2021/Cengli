// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_wallet_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateWalletRequest _$CreateWalletRequestFromJson(Map<String, dynamic> json) =>
    CreateWalletRequest(
      walletAddress: json['walletAddress'] as String,
      publicKeyId: json['publicKeyId'] as String,
      publicKeyX: json['publicKeyX'] as String,
      publicKeyY: json['publicKeyY'] as String,
      deviceData:
          DeviceData.fromJson(json['deviceData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateWalletRequestToJson(
        CreateWalletRequest instance) =>
    <String, dynamic>{
      'walletAddress': instance.walletAddress,
      'publicKeyId': instance.publicKeyId,
      'publicKeyX': instance.publicKeyX,
      'publicKeyY': instance.publicKeyY,
      'deviceData': instance.deviceData,
    };
