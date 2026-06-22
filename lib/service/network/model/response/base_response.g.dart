// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$BaseResponseToJson<T>(
  BaseResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'head': instance.head,
      'body': _$nullableGenericToJson(instance.body, toJsonT),
    };

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);

Map<String, dynamic> _$HeadResponseToJson(HeadResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'successUserStatus': instance.successUserStatus,
      'responseCode': instance.responseCode,
      'statusDescription': instance.statusDescription,
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
      'Token': instance.methodName,
      'MethodName': instance.token,
      'Errors': instance.errors,
    };

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'subStatusCode': instance.subStatusCode,
      'message': instance.message,
    };
