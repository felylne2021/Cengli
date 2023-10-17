import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'charges.g.dart';

@JsonSerializable()
class Charges extends Equatable {
  @JsonKey(name: 'userId')
  final String? userId;

  @JsonKey(name: 'count')
  final double? count;

  @JsonKey(name: 'price')
  final double? price;

  const Charges({this.userId, this.count, this.price});
  @override
  List<Object?> get props => [userId, count, price];

  Map<String, dynamic> toJson() => _$ChargesToJson(this);

  factory Charges.fromJson(Map<String, dynamic> json) =>
      _$ChargesFromJson(json);
}
