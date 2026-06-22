import 'package:json_annotation/json_annotation.dart';

part 'base_request.g.dart';

/// Base request class for all API requests.
///
/// This class provides a generic structure for requests with a head and body.
/// It is used for requests with the following structure:
/// {
///   head: {...},
///   body: {...}
/// }.
@JsonSerializable(ignoreUnannotated: true, genericArgumentFactories: true)
class BaseRequest<T> {
  /// The head of the request.
  @JsonKey(name: 'Head')
  HeadRequest? head;

  /// The body of the request.
  @JsonKey(name: 'Body')
  T? body;

  /// Creates a base request with the specified head and body.
  BaseRequest({this.head, this.body});

  /// Creates a base request from a JSON object.
  factory BaseRequest.fromJson(
          Map<String, dynamic> json, T Function(dynamic json) jsonFrom) =>
      _$BaseRequestFromJson<T>(json, jsonFrom);

  /// Converts the base request to a JSON object.
  Map<String, dynamic> toJson(Object? Function(T) toJson) =>
      _$BaseRequestToJson(this, toJson);
}

/// Represents the head of a request.
@JsonSerializable(ignoreUnannotated: true)
class HeadRequest {
  /// The code of the request.
  @JsonKey(name: 'Code')
  String? code;

  /// The key of the request.
  @JsonKey(name: 'Key')
  String? key;

  /// The app version of the request.
  @JsonKey(name: 'AppVer')
  String? appVersion;

  /// The app name of the request.
  @JsonKey(name: 'AppName')
  String? appName;

  /// The OS name of the request.
  @JsonKey(name: 'OSName')
  String? osName;

  /// The device make of the request.
  @JsonKey(name: 'device_make')
  String? deviceMake;

  /// The device model of the request.
  @JsonKey(name: 'device_model')
  String? deviceModel;

  /// The OS version of the request.
  @JsonKey(name: 'os_version')
  String? osVersion;

  /// The device type of the request.
  @JsonKey(name: 'device_type')
  String? deviceType;

  /// The request code of the request.
  @JsonKey(name: 'RequestCode')
  String? requestCode;

  /// The token of the request.
  @JsonKey(name: 'Token')
  String? token;

  /// Creates a head request with the specified properties.
  HeadRequest(
      {this.code,
      this.key,
      this.requestCode,
      this.token,
      this.appName,
      this.deviceMake,
      this.deviceModel,
      this.deviceType,
      this.appVersion});

  /// Creates a head request from a JSON object.
  factory HeadRequest.fromJson(Map<String, dynamic> json) =>
      _$HeadRequestFromJson(json);

  /// Converts the head request to a JSON object.
  Map<String, dynamic> toJson() => _$HeadRequestToJson(this);
}
