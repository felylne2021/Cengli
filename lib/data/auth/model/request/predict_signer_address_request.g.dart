// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'predict_signer_address_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PredictSignerAddressRequest _$PredictSignerAddressRequestFromJson(
        Map<String, dynamic> json) =>
    PredictSignerAddressRequest(
      publicKeyX: json['publicKeyX'] as String,
      publicKeyY: json['publicKeyY'] as String,
    );

Map<String, dynamic> _$PredictSignerAddressRequestToJson(
        PredictSignerAddressRequest instance) =>
    <String, dynamic>{
      'publicKeyX': instance.publicKeyX,
      'publicKeyY': instance.publicKeyY,
    };
