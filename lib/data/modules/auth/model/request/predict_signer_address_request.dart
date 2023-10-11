import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'predict_signer_address_request.g.dart';

@JsonSerializable()
class PredictSignerAddressRequest extends Equatable {
  @JsonKey(name: 'publicKeyX')
  final String publicKeyX;

  @JsonKey(name: 'publicKeyY')
  final String publicKeyY;

  const PredictSignerAddressRequest(
      {required this.publicKeyX, required this.publicKeyY});

  @override
  List<Object?> get props => [publicKeyX, publicKeyY];

  Map<String, dynamic> toJson() => _$PredictSignerAddressRequestToJson(this);

  factory PredictSignerAddressRequest.fromJson(Map<String, dynamic> json) =>
      _$PredictSignerAddressRequestFromJson(json);
}
