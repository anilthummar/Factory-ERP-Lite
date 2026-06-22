import '../../../../utils/exports.dart';

/// Implementation of the CustomPaginationRepository interface.
///
/// This class handles the API calls to fetch paginated data.
class CustomPaginationRepositoryImpl extends CustomPaginationRepository {
  /// Fetches a list of pagination details from the API.
  ///
  /// [page] is the page number to fetch.
  ///
  /// Returns a [ResponseHandler] containing a list of [PaginationDetailResponse].
  @override
  Future<ResponseHandler<List<PaginationDetailResponse>>> getListOfDetails(
      int page) async {
    final ResponseHandler<List<dynamic>?> responseHandler = await MainConfig
        .apiClient
        .handleApiCall<List<dynamic>>(Apis.posts, ApiType.get,
            showLoader: false,
            params: <String, dynamic>{
          ApiConst.page: "\\$page",
          ApiConst.limit: ApiConst.count14
        });
    if (responseHandler.isSuccess()) {
      List<PaginationDetailResponse>? value = responseHandler
          .getSuccessInstance()
          ?.response
          ?.map((dynamic e) => PaginationDetailResponse.fromJson(e))
          .toList();
      return OnSuccessResponse<List<PaginationDetailResponse>>(
          response: value ?? <PaginationDetailResponse>[]);
    } else {
      return OnFailureResponse<List<PaginationDetailResponse>>(
        statusCode: responseHandler.getFailureInstance()?.statusCode,
        error: responseHandler.getFailureInstance()?.error,
      );
    }
  }
}
