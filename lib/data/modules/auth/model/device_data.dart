import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_data.g.dart';

@JsonSerializable()
class DeviceData extends Equatable {
  @JsonKey(name: 'browser')
  final String browser;

  @JsonKey(name: 'os')
  final String os;

  @JsonKey(name: 'platform')
  final String platform;

  const DeviceData(
      {required this.browser, required this.os, required this.platform});

  @override
  List<Object?> get props => [browser, os, platform];

  Map<String, dynamic> toJson() => _$DeviceDataToJson(this);

  factory DeviceData.fromJson(Map<String, dynamic> json) =>
      _$DeviceDataFromJson(json);
}
