import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile extends Equatable {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'userName')
  final String? userName;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'email')
  final String? email;

  @JsonKey(name: 'walletAddress')
  final String? walletAddress;

  @JsonKey(name: 'userRole')
  final String? userRole;

  @JsonKey(name: 'imageProfile')
  final String? imageProfile;

  const UserProfile(
      {this.id,
      this.userName,
      this.name,
      this.email,
      this.walletAddress,
      this.userRole,
      this.imageProfile});

  @override
  List<Object?> get props =>
      [id, userName, name, email, walletAddress, userRole, imageProfile];

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
