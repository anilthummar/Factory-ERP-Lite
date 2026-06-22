// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_local.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginationLocalImpl _$$PaginationLocalImplFromJson(
        Map<String, dynamic> json) =>
    _$PaginationLocalImpl(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) =>
              PaginationDetailResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: (json['page'] as num?)?.toInt(),
      isLoadMore: json['isLoadMore'] as bool?,
      isRequiredLoadMore: json['isRequiredLoadMore'] as bool?,
    );

Map<String, dynamic> _$$PaginationLocalImplToJson(
        _$PaginationLocalImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'page': instance.page,
      'isLoadMore': instance.isLoadMore,
      'isRequiredLoadMore': instance.isRequiredLoadMore,
    };
