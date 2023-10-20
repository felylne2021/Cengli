import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'registration.g.dart';

@JsonSerializable()
class Registration extends Equatable {
  @JsonKey(name: 'walletAddress')
  final String? walletAddress;

  @JsonKey(name: 'status')
  final String? status;

  const Registration({
    this.walletAddress,
    this.status
  });

  @override
  List<Object?> get props => [walletAddress, status];

  Map<String, dynamic> toJson() => _$RegistrationToJson(this);

  factory Registration.fromJson(Map<String, dynamic> json) =>
      _$RegistrationFromJson(json);
}
