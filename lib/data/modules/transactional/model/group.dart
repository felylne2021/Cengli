import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'group.g.dart';

@JsonSerializable()
class Group extends Equatable {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'groupDescription')
  final String? groupDescription;

  @JsonKey(name: 'members')
  final List<String>? members;

  @JsonKey(name: 'groupType')
  final String? groupType;

  @JsonKey(name: 'p2pOrderId')
  final String? p2pOrderId;

  const Group(
      {this.id,
      this.name,
      this.groupDescription,
      this.members,
      this.groupType,
      this.p2pOrderId});

  @override
  List<Object?> get props =>
      [id, name, groupDescription, members, groupType, p2pOrderId];

  Map<String, dynamic> toJson() => _$GroupToJson(this);

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}
