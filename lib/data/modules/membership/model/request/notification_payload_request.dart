import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_payload_request.g.dart';

@JsonSerializable()
class NotificationPayloadRequest extends Equatable {
  @JsonKey(name: 'title')
  final String? title;

  @JsonKey(name: 'body')
  final String? body;

  @JsonKey(name: 'screen')
  final String? screen;

  const NotificationPayloadRequest({this.title, this.body, this.screen});

  @override
  List<Object?> get props => [title, body, screen];

  Map<String, dynamic> toJson() => _$NotificationPayloadRequestToJson(this);

  factory NotificationPayloadRequest.fromJson(Map<String, dynamic> json) =>
      _$NotificationPayloadRequestFromJson(json);
}
