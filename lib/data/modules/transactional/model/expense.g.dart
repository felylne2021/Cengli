// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expense _$ExpenseFromJson(Map<String, dynamic> json) => Expense(
      id: json['id'] as String?,
      title: json['title'] as String?,
      groupId: json['group_id'] as String?,
      amount: json['amount'] as String?,
      category: json['category'] as String?,
      memberPayId: json['memberPayId'] as String?,
      tokenUnit: json['tokenUnit'] as String?,
      charges: (json['charges'] as List<dynamic>?)
          ?.map((e) => Charges.fromJson(e as Map<String, dynamic>))
          .toList(),
      date: json['date'] as String?,
    );

Map<String, dynamic> _$ExpenseToJson(Expense instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'group_id': instance.groupId,
      'amount': instance.amount,
      'category': instance.category,
      'date': instance.date,
      'memberPayId': instance.memberPayId,
      'tokenUnit': instance.tokenUnit,
      'charges': instance.charges,
    };
