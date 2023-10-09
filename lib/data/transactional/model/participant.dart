import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'participant.g.dart';

@JsonSerializable()
class Participant extends Equatable {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'group_id')
  final String? groupId;

  @JsonKey(name: 'name')
  final String? name;

  const Participant({this.id, this.groupId, this.name});

  @override
  List<Object?> get props => [id, groupId, name];

  Map<String, dynamic> toJson() => _$ParticipantToJson(this);

  factory Participant.fromJson(Map<String, dynamic> json) => _$ParticipantFromJson(json);
}
