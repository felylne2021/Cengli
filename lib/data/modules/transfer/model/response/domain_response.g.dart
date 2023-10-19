// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'domain_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DomainResponse _$DomainResponseFromJson(Map<String, dynamic> json) =>
    DomainResponse(
      chainId: json['chainId'] as String?,
      verifyingContract: json['verifyingContract'] as String?,
    );

Map<String, dynamic> _$DomainResponseToJson(DomainResponse instance) =>
    <String, dynamic>{
      'chainId': instance.chainId,
      'verifyingContract': instance.verifyingContract,
    };
