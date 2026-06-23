// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagination_detail_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaginationDetailResponse _$PaginationDetailResponseFromJson(
  Map<String, dynamic> json,
) {
  return _PaginationDetailResponse.fromJson(json);
}

/// @nodoc
mixin _$PaginationDetailResponse {
  int? get userId => throw _privateConstructorUsedError;
  int? get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get body => throw _privateConstructorUsedError;

  /// Serializes this PaginationDetailResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginationDetailResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginationDetailResponseCopyWith<PaginationDetailResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationDetailResponseCopyWith<$Res> {
  factory $PaginationDetailResponseCopyWith(
    PaginationDetailResponse value,
    $Res Function(PaginationDetailResponse) then,
  ) = _$PaginationDetailResponseCopyWithImpl<$Res, PaginationDetailResponse>;
  @useResult
  $Res call({int? userId, int? id, String? title, String? body});
}

/// @nodoc
class _$PaginationDetailResponseCopyWithImpl<
  $Res,
  $Val extends PaginationDetailResponse
>
    implements $PaginationDetailResponseCopyWith<$Res> {
  _$PaginationDetailResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginationDetailResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? id = freezed,
    Object? title = freezed,
    Object? body = freezed,
  }) {
    return _then(
      _value.copyWith(
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as int?,
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            body: freezed == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaginationDetailResponseImplCopyWith<$Res>
    implements $PaginationDetailResponseCopyWith<$Res> {
  factory _$$PaginationDetailResponseImplCopyWith(
    _$PaginationDetailResponseImpl value,
    $Res Function(_$PaginationDetailResponseImpl) then,
  ) = __$$PaginationDetailResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? userId, int? id, String? title, String? body});
}

/// @nodoc
class __$$PaginationDetailResponseImplCopyWithImpl<$Res>
    extends
        _$PaginationDetailResponseCopyWithImpl<
          $Res,
          _$PaginationDetailResponseImpl
        >
    implements _$$PaginationDetailResponseImplCopyWith<$Res> {
  __$$PaginationDetailResponseImplCopyWithImpl(
    _$PaginationDetailResponseImpl _value,
    $Res Function(_$PaginationDetailResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaginationDetailResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? id = freezed,
    Object? title = freezed,
    Object? body = freezed,
  }) {
    return _then(
      _$PaginationDetailResponseImpl(
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as int?,
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        body: freezed == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginationDetailResponseImpl
    with DiagnosticableTreeMixin
    implements _PaginationDetailResponse {
  const _$PaginationDetailResponseImpl({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  factory _$PaginationDetailResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginationDetailResponseImplFromJson(json);

  @override
  final int? userId;
  @override
  final int? id;
  @override
  final String? title;
  @override
  final String? body;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PaginationDetailResponse(userId: $userId, id: $id, title: $title, body: $body)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PaginationDetailResponse'))
      ..add(DiagnosticsProperty('userId', userId))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('body', body));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationDetailResponseImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, id, title, body);

  /// Create a copy of PaginationDetailResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationDetailResponseImplCopyWith<_$PaginationDetailResponseImpl>
  get copyWith =>
      __$$PaginationDetailResponseImplCopyWithImpl<
        _$PaginationDetailResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginationDetailResponseImplToJson(this);
  }
}

abstract class _PaginationDetailResponse implements PaginationDetailResponse {
  const factory _PaginationDetailResponse({
    final int? userId,
    final int? id,
    final String? title,
    final String? body,
  }) = _$PaginationDetailResponseImpl;

  factory _PaginationDetailResponse.fromJson(Map<String, dynamic> json) =
      _$PaginationDetailResponseImpl.fromJson;

  @override
  int? get userId;
  @override
  int? get id;
  @override
  String? get title;
  @override
  String? get body;

  /// Create a copy of PaginationDetailResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginationDetailResponseImplCopyWith<_$PaginationDetailResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
