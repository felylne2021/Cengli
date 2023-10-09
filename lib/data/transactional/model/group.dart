import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'group.g.dart';

@JsonSerializable()
class Group extends Equatable {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'users')
  final List<String>? users;

  @JsonKey(name: 'participants')
  final List<String>? participants;

  const Group({this.id, this.name, this.users, this.participants});

  @override
  List<Object?> get props => [id, name, users, participants];

  Map<String, dynamic> toJson() => _$GroupToJson(this);

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}
