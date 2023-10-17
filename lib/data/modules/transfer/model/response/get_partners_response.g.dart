// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_partners_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetPartnersResponse _$GetPartnersResponseFromJson(Map<String, dynamic> json) =>
    GetPartnersResponse(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      address: json['address'] as String?,
      name: json['name'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      balances: (json['balances'] as List<dynamic>?)
          ?.map(
              (e) => PartnerBalanceResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetPartnersResponseToJson(
        GetPartnersResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'address': instance.address,
      'name': instance.name,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'balances': instance.balances,
    };
