// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      id: json['id'] as String?,
      name: json['name'] as String?,
      groupDescription: json['groupDescription'] as String?,
      members:
          (json['members'] as List<dynamic>?)?.map((e) => e as String).toList(),
      groupType: json['groupType'] as String?,
      p2pOrderId: json['p2pOrderId'] as String?,
    );

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'groupDescription': instance.groupDescription,
      'members': instance.members,
      'groupType': instance.groupType,
      'p2pOrderId': instance.p2pOrderId,
    };
