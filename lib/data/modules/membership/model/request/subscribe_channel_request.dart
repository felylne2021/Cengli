import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscribe_channel_request.g.dart';

@JsonSerializable()
class SubscribeChannelRequest extends Equatable {
  @JsonKey(name: 'walletAddress')
  final String? walletAddress;

  @JsonKey(name: 'pgpk')
  final String? pgpk;

  const SubscribeChannelRequest(
      {this.walletAddress, this.pgpk});

  @override
  List<Object?> get props => [walletAddress, pgpk];

  Map<String, dynamic> toJson() => _$SubscribeChannelRequestToJson(this);

  factory SubscribeChannelRequest.fromJson(Map<String, dynamic> json) =>
      _$SubscribeChannelRequestFromJson(json);
}
