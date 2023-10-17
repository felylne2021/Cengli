// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bill _$BillFromJson(Map<String, dynamic> json) => Bill(
      json['groupId'] as String?,
      json['recipient'] as String?,
      json['tokenUnit'] as String?,
      json['chain'] as String?,
      json['walletAddress'] as String?,
      json['date'] as String?,
      json['notes'] as String?,
      json['status'] as String?,
      json['amount'] as String?,
    );

Map<String, dynamic> _$BillToJson(Bill instance) => <String, dynamic>{
      'groupId': instance.groupId,
      'recipient': instance.recipient,
      'tokenUnit': instance.tokenUnit,
      'chain': instance.chain,
      'walletAddress': instance.walletAddress,
      'date': instance.date,
      'notes': instance.notes,
      'status': instance.status,
      'amount': instance.amount,
    };
