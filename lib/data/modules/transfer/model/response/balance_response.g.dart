// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BalanceResponse _$BalanceResponseFromJson(Map<String, dynamic> json) =>
    BalanceResponse(
      balance: (json['balance'] as num?)?.toDouble(),
      balanceUSd: (json['balanceUSd'] as num?)?.toDouble(),
      token: json['token'] == null
          ? null
          : TokenResponse.fromJson(json['token'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BalanceResponseToJson(BalanceResponse instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'balanceUSd': instance.balanceUSd,
      'token': instance.token,
    };
