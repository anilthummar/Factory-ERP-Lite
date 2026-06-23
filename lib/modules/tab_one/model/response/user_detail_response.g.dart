// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDetailResponseImpl _$$UserDetailResponseImplFromJson(
  Map<String, dynamic> json,
) => _$UserDetailResponseImpl(
  data: json['data'] == null
      ? null
      : UserDetail.fromJson(json['data'] as Map<String, dynamic>),
  support: json['support'] == null
      ? null
      : Support.fromJson(json['support'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$UserDetailResponseImplToJson(
  _$UserDetailResponseImpl instance,
) => <String, dynamic>{'data': instance.data, 'support': instance.support};

_$UserDetailImpl _$$UserDetailImplFromJson(Map<String, dynamic> json) =>
    _$UserDetailImpl(
      id: (json['id'] as num?)?.toInt(),
      email: json['email'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$$UserDetailImplToJson(_$UserDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'avatar': instance.avatar,
    };

_$SupportImpl _$$SupportImplFromJson(Map<String, dynamic> json) =>
    _$SupportImpl(url: json['url'] as String?, text: json['text'] as String?);

Map<String, dynamic> _$$SupportImplToJson(_$SupportImpl instance) =>
    <String, dynamic>{'url': instance.url, 'text': instance.text};
