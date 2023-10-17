// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_balance_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerBalanceResponse _$PartnerBalanceResponseFromJson(
        Map<String, dynamic> json) =>
    PartnerBalanceResponse(
      partnerId: json['partnerId'] as String?,
      tokenAddress: json['tokenAddress'] as String?,
      tokenChainId: json['tokenChainId'] as int?,
      amount: (json['amount'] as num?)?.toDouble(),
      token: json['token'] == null
          ? null
          : TokenResponse.fromJson(json['token'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PartnerBalanceResponseToJson(
        PartnerBalanceResponse instance) =>
    <String, dynamic>{
      'partnerId': instance.partnerId,
      'tokenAddress': instance.tokenAddress,
      'tokenChainId': instance.tokenChainId,
      'amount': instance.amount,
      'token': instance.token,
    };
