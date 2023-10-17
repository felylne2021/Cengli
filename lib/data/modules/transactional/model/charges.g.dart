// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charges.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Charges _$ChargesFromJson(Map<String, dynamic> json) => Charges(
      userId: json['userId'] as String?,
      count: (json['count'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ChargesToJson(Charges instance) => <String, dynamic>{
      'userId': instance.userId,
      'count': instance.count,
      'price': instance.price,
    };
