// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginationDetailResponseImpl _$$PaginationDetailResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PaginationDetailResponseImpl(
      userId: (json['userId'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      body: json['body'] as String?,
    );

Map<String, dynamic> _$$PaginationDetailResponseImplToJson(
        _$PaginationDetailResponseImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
    };
