import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_wallet_request.g.dart';

@JsonSerializable()
class CreateWalletRequest extends Equatable {
  @JsonKey(name: 'ownerAddress')
  final String ownerAddress;

  const CreateWalletRequest(
      {required this.ownerAddress,});

  @override
  List<Object?> get props =>
      [ownerAddress];

  Map<String, dynamic> toJson() => _$CreateWalletRequestToJson(this);

  factory CreateWalletRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateWalletRequestFromJson(json);
}
