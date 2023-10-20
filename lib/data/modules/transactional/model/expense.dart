import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'charges.dart';

part 'expense.g.dart';

@JsonSerializable()
class Expense extends Equatable {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'title')
  final String? title;
  @JsonKey(name: 'group_id')
  final String? groupId;

  @JsonKey(name: 'amount')
  final String? amount;

  @JsonKey(name: 'category')
  final String? category;

  @JsonKey(name: 'date')
  final String? date;

  @JsonKey(name: 'memberPayId')
  final String? memberPayId;

  @JsonKey(name: 'tokenUnit')
  final String? tokenUnit;

  @JsonKey(name: 'charges')
  final List<Charges>? charges;

  @JsonKey(name: 'status')
  final String? status;

  const Expense(
      {this.id,
      this.title,
      this.groupId,
      this.amount,
      this.category,
      this.memberPayId,
      this.tokenUnit,
      this.charges,
      this.date,
      this.status});

  @override
  List<Object?> get props => [
        id,
        title,
        groupId,
        amount,
        category,
        date,
        memberPayId,
        tokenUnit,
        charges,
        status
      ];

  Map<String, dynamic> toJson() => _$ExpenseToJson(this);

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);
}
