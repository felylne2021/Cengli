import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'signer_address_response.g.dart';

@JsonSerializable()
class SignerAddressResponse extends Equatable {
  @JsonKey(name: 'success')
  final bool? success;

  @JsonKey(name: 'signerAddress')
  final String? signerAddress;

  const SignerAddressResponse({this.success, this.signerAddress});

  @override
  List<Object?> get props => [success, signerAddress];

  Map<String, dynamic> toJson() => _$SignerAddressResponseToJson(this);

  factory SignerAddressResponse.fromJson(Map<String, dynamic> json) =>
      _$SignerAddressResponseFromJson(json);
}
