import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'expense.g.dart';

@JsonSerializable()
class Expense extends Equatable {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'group_id')
  final String? groupId;

  @JsonKey(name: 'amount')
  final String? amount;

  @JsonKey(name: 'category')
  final String? category;

  @JsonKey(name: 'date')
  final String? date;

  const Expense({this.id, this.groupId, this.amount, this.category, this.date});

  @override
  List<Object?> get props => [id, groupId, amount, category, date];

  Map<String, dynamic> toJson() => _$ExpenseToJson(this);

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);
}
