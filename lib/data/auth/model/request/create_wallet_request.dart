import 'package:cengli/data/auth/model/device_data.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_wallet_request.g.dart';

@JsonSerializable()
class CreateWalletRequest extends Equatable {
  @JsonKey(name: 'walletAddress')
  final String walletAddress;

  @JsonKey(name: 'publicKeyId')
  final String publicKeyId;

  @JsonKey(name: 'publicKeyX')
  final String publicKeyX;

  @JsonKey(name: 'publicKeyY')
  final String publicKeyY;

  @JsonKey(name: 'deviceData')
  final DeviceData deviceData;

  const CreateWalletRequest(
      {required this.walletAddress,
      required this.publicKeyId,
      required this.publicKeyX,
      required this.publicKeyY,
      required this.deviceData});

  @override
  List<Object?> get props =>
      [walletAddress, publicKeyId, publicKeyX, publicKeyY, deviceData];

  Map<String, dynamic> toJson() => _$CreateWalletRequestToJson(this);

  factory CreateWalletRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateWalletRequestFromJson(json);
}
