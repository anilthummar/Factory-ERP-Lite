// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagination_local.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaginationLocal _$PaginationLocalFromJson(Map<String, dynamic> json) {
  return _PaginationLocal.fromJson(json);
}

/// @nodoc
mixin _$PaginationLocal {
  List<PaginationDetailResponse>? get data =>
      throw _privateConstructorUsedError;
  int? get page => throw _privateConstructorUsedError;
  bool? get isLoadMore => throw _privateConstructorUsedError;
  bool? get isRequiredLoadMore => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaginationLocalCopyWith<PaginationLocal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationLocalCopyWith<$Res> {
  factory $PaginationLocalCopyWith(
          PaginationLocal value, $Res Function(PaginationLocal) then) =
      _$PaginationLocalCopyWithImpl<$Res, PaginationLocal>;
  @useResult
  $Res call(
      {List<PaginationDetailResponse>? data,
      int? page,
      bool? isLoadMore,
      bool? isRequiredLoadMore});
}

/// @nodoc
class _$PaginationLocalCopyWithImpl<$Res, $Val extends PaginationLocal>
    implements $PaginationLocalCopyWith<$Res> {
  _$PaginationLocalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? page = freezed,
    Object? isLoadMore = freezed,
    Object? isRequiredLoadMore = freezed,
  }) {
    return _then(_value.copyWith(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<PaginationDetailResponse>?,
      page: freezed == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int?,
      isLoadMore: freezed == isLoadMore
          ? _value.isLoadMore
          : isLoadMore // ignore: cast_nullable_to_non_nullable
              as bool?,
      isRequiredLoadMore: freezed == isRequiredLoadMore
          ? _value.isRequiredLoadMore
          : isRequiredLoadMore // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginationLocalImplCopyWith<$Res>
    implements $PaginationLocalCopyWith<$Res> {
  factory _$$PaginationLocalImplCopyWith(_$PaginationLocalImpl value,
          $Res Function(_$PaginationLocalImpl) then) =
      __$$PaginationLocalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<PaginationDetailResponse>? data,
      int? page,
      bool? isLoadMore,
      bool? isRequiredLoadMore});
}

/// @nodoc
class __$$PaginationLocalImplCopyWithImpl<$Res>
    extends _$PaginationLocalCopyWithImpl<$Res, _$PaginationLocalImpl>
    implements _$$PaginationLocalImplCopyWith<$Res> {
  __$$PaginationLocalImplCopyWithImpl(
      _$PaginationLocalImpl _value, $Res Function(_$PaginationLocalImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? page = freezed,
    Object? isLoadMore = freezed,
    Object? isRequiredLoadMore = freezed,
  }) {
    return _then(_$PaginationLocalImpl(
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<PaginationDetailResponse>?,
      page: freezed == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int?,
      isLoadMore: freezed == isLoadMore
          ? _value.isLoadMore
          : isLoadMore // ignore: cast_nullable_to_non_nullable
              as bool?,
      isRequiredLoadMore: freezed == isRequiredLoadMore
          ? _value.isRequiredLoadMore
          : isRequiredLoadMore // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginationLocalImpl
    with DiagnosticableTreeMixin
    implements _PaginationLocal {
  const _$PaginationLocalImpl(
      {final List<PaginationDetailResponse>? data,
      this.page,
      this.isLoadMore,
      this.isRequiredLoadMore})
      : _data = data;

  factory _$PaginationLocalImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginationLocalImplFromJson(json);

  final List<PaginationDetailResponse>? _data;
  @override
  List<PaginationDetailResponse>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? page;
  @override
  final bool? isLoadMore;
  @override
  final bool? isRequiredLoadMore;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PaginationLocal(data: $data, page: $page, isLoadMore: $isLoadMore, isRequiredLoadMore: $isRequiredLoadMore)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PaginationLocal'))
      ..add(DiagnosticsProperty('data', data))
      ..add(DiagnosticsProperty('page', page))
      ..add(DiagnosticsProperty('isLoadMore', isLoadMore))
      ..add(DiagnosticsProperty('isRequiredLoadMore', isRequiredLoadMore));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationLocalImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.isLoadMore, isLoadMore) ||
                other.isLoadMore == isLoadMore) &&
            (identical(other.isRequiredLoadMore, isRequiredLoadMore) ||
                other.isRequiredLoadMore == isRequiredLoadMore));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_data),
      page,
      isLoadMore,
      isRequiredLoadMore);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationLocalImplCopyWith<_$PaginationLocalImpl> get copyWith =>
      __$$PaginationLocalImplCopyWithImpl<_$PaginationLocalImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginationLocalImplToJson(
      this,
    );
  }
}

abstract class _PaginationLocal implements PaginationLocal {
  const factory _PaginationLocal(
      {final List<PaginationDetailResponse>? data,
      final int? page,
      final bool? isLoadMore,
      final bool? isRequiredLoadMore}) = _$PaginationLocalImpl;

  factory _PaginationLocal.fromJson(Map<String, dynamic> json) =
      _$PaginationLocalImpl.fromJson;

  @override
  List<PaginationDetailResponse>? get data;
  @override
  int? get page;
  @override
  bool? get isLoadMore;
  @override
  bool? get isRequiredLoadMore;
  @override
  @JsonKey(ignore: true)
  _$$PaginationLocalImplCopyWith<_$PaginationLocalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
