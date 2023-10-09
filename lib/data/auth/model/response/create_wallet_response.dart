import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_wallet_response.g.dart';

@JsonSerializable()
class CreateWalletResponse extends Equatable {
  @JsonKey(name: 'success')
  final bool? success;

  @JsonKey(name: 'walletAddress')
  final String? walletAddress;

  const CreateWalletResponse({this.success, this.walletAddress});

  @override
  List<Object?> get props => [success, walletAddress];

  Map<String, dynamic> toJson() => _$CreateWalletResponseToJson(this);

  factory CreateWalletResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateWalletResponseFromJson(json);
}
