// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_wallet_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateWalletResponse _$CreateWalletResponseFromJson(
        Map<String, dynamic> json) =>
    CreateWalletResponse(
      success: json['success'] as bool?,
      walletAddress: json['walletAddress'] as String?,
    );

Map<String, dynamic> _$CreateWalletResponseToJson(
        CreateWalletResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'walletAddress': instance.walletAddress,
    };
