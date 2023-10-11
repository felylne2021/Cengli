// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signer_address_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignerAddressResponse _$SignerAddressResponseFromJson(
        Map<String, dynamic> json) =>
    SignerAddressResponse(
      success: json['success'] as bool?,
      signerAddress: json['signerAddress'] as String?,
    );

Map<String, dynamic> _$SignerAddressResponseToJson(
        SignerAddressResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'signerAddress': instance.signerAddress,
    };
