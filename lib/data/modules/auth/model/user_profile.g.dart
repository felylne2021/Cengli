// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      id: json['id'] as String?,
      userName: json['userName'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      walletAddress: json['walletAddress'] as String?,
      userRole: json['userRole'] as String?,
      imageProfile: json['imageProfile'] as String?,
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'name': instance.name,
      'email': instance.email,
      'walletAddress': instance.walletAddress,
      'userRole': instance.userRole,
      'imageProfile': instance.imageProfile,
    };
