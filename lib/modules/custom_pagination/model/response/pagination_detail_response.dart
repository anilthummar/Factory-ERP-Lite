import '../../../../utils/exports.dart';

part 'pagination_detail_response.freezed.dart';
part 'pagination_detail_response.g.dart';

/// A data class representing the response details of a pagination item.
///
/// This class is used to store details such as user ID, item ID, title, and body.
@freezed
class PaginationDetailResponse with _$PaginationDetailResponse {
  /// Creates a new instance of [PaginationDetailResponse].
  const factory PaginationDetailResponse({
    int? userId,
    int? id,
    String? title,
    String? body,
  }) = _PaginationDetailResponse;

  /// Creates a new instance of [PaginationDetailResponse] from a JSON object.
  factory PaginationDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$PaginationDetailResponseFromJson(json);
}
