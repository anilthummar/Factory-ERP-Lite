import '../../../../utils/exports.dart';

part 'pagination_local.freezed.dart';
part 'pagination_local.g.dart';

/// A data class representing local pagination information.
///
/// This class is used to store pagination details such as data, page number,
/// and flags for loading more data.
@freezed
class PaginationLocal with _$PaginationLocal {
  /// Creates a new instance of [PaginationLocal].
  const factory PaginationLocal({
    List<PaginationDetailResponse>? data,
    int? page,
    bool? isLoadMore,
    bool? isRequiredLoadMore,
  }) = _PaginationLocal;

  /// Creates a new instance of [PaginationLocal] from a JSON object.
  factory PaginationLocal.fromJson(Map<String, dynamic> json) =>
      _$PaginationLocalFromJson(json);
}
