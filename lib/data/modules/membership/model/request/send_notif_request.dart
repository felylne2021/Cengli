import 'package:cengli/data/modules/membership/model/request/notification_payload_request.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'send_notif_request.g.dart';

@JsonSerializable()
class SendNotifRequest extends Equatable {
  @JsonKey(name: 'walletAddresses')
  final List<String>? walletAddresses;

  @JsonKey(name: 'notificationPayload')
  final NotificationPayloadRequest? notificationPayload;

  const SendNotifRequest({this.walletAddresses, this.notificationPayload});

  @override
  List<Object?> get props => [walletAddresses, notificationPayload];

  Map<String, dynamic> toJson() => _$SendNotifRequestToJson(this);

  factory SendNotifRequest.fromJson(Map<String, dynamic> json) =>
      _$SendNotifRequestFromJson(json);
}
