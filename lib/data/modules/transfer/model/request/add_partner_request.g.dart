// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_partner_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetPartnerRequest _$GetPartnerRequestFromJson(Map<String, dynamic> json) =>
    GetPartnerRequest(
      userId: json['userId'] as String?,
      userAddress: json['userAddress'] as String?,
    );

Map<String, dynamic> _$GetPartnerRequestToJson(GetPartnerRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userAddress': instance.userAddress,
    };
