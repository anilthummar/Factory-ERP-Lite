import '../../../../utils/exports.dart';

/// An implementation of the Tab One repository.
///
/// This class handles API calls to fetch user details.
class TabOneRepositoryImpl extends TabOneRepository {
  @override
  Future<ResponseHandler<UserDetailResponse>> getUserDetails(
      {int id = 1}) async {
    ResponseHandler<Map<String, dynamic>?> response = await MainConfig.apiClient
        .handleApiCall<Map<String, dynamic>>("${Apis.user}/$id", ApiType.get,
            //cache the response
            needToCache: true,
            //cache for 5 minutes
            cacheDurationMnt: 5);
    return getParsedResponseHandler(
      responseHandler: response,
      parser: (Map<String, dynamic> value) => UserDetailResponse.fromJson(
        value,
      ),
    );
  }
}
