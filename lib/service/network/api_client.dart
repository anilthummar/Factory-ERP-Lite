import '../../utils/exports.dart';

/// Service of [ApiClient] (DIO).
///
/// Used to provide singleton instance of [ApiClient].
class ApiClient {
  Dio? _dio;

  /// The tag for the API call.
  String tag = "API call :";
  CancelToken? _cancelToken;
  static final ApiClient _instance = ApiClient._internal();

  /// Factory constructor for creating an instance of [ApiClient].
  factory ApiClient() {
// mDio.options.headers['authorization'] = 'Bearer ';
// mDio.options.contentType = !isJson
// ? 'application/json'
// : 'application/x-www-form-urlencoded';

    return _instance;
  }

  /// Internal constructor for initializing [ApiClient].
  ApiClient._internal() {
    _dio = initApiHandlerDio(configBaseUrl);
    _dio?.interceptors.add(NetworkCacheInterceptor(
      noCacheStatusCodes: <int>[401, 403],
    ));
    _dio?.addSentry();
  }

  /// Initializes the Dio instance with base options.
  Dio initApiHandlerDio(String url) {
    _cancelToken = CancelToken();
    final BaseOptions baseOption = BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      baseUrl: url,
      contentType: 'application/json',
    );
    final Dio mDio = Dio(baseOption);
    mDio.interceptors.add(HttpHandleInterceptor());
    if (kDebugMode) {
      mDio.interceptors.add(AwesomeDioInterceptor(
        logger: (String log) => DebugLog.instance.d(log),
      ));
    }
    return mDio;
  }

  /// Cancels ongoing requests with an optional cancel token.
  void cancelRequests({CancelToken? cancelToken}) {
    cancelToken == null
        ? _cancelToken?.cancel('Cancelled')
        : cancelToken.cancel();
  }

  /// Handles API calls and returns a response handler.
  Future<ResponseHandler<T?>> handleApiCall<T>(String endUrl, ApiType apiType,
      {bool isB2cCall = false,
      Map<String, dynamic>? data,
      Map<String, dynamic>? params,
      Options? options,
      bool isMultipartFormData = false,
      CancelToken? cancelToken,
      bool showLoader = true,
      bool dismissLoader = true,
      bool needToCache = false,
      int cacheDurationMnt = 0}) async {
    late ResponseHandler<T?> handler;
    SentryService.instance.startAPITransaction(apiName: endUrl);
    try {
      await _showLoading(showLoader);
      if (apiType == ApiType.get) {
        handler = await get<T>(
          endUrl,
          params: params,
          options: options,
          cancelToken: cancelToken,
          needToCache: needToCache,
          cacheDurationMnt: cacheDurationMnt,
        );
      } else if (apiType == ApiType.post) {
        handler = await post<T>(
          endUrl,
          data: data,
          params: params,
          options: options,
          cancelToken: cancelToken,
          needToCache: needToCache,
          cacheDurationMnt: cacheDurationMnt,
          isMultipartFormData: isMultipartFormData,
        );
      } else if (apiType == ApiType.delete) {
        handler = await delete<T>(
          endUrl,
          data: data,
          params: params,
          options: options,
          cancelToken: cancelToken,
        );
      }
      await SentryService.instance.logSuccessAPITransaction(handler);
    } on FormatException {
      handler = OnFailureResponse<T?>(
        error: ErrorResult(
          errorMessage: MainConfig.context.appString.badRequestStateKey,
          type: DioExceptionType.unknown,
        ),
      );
    } on DioException catch (e) {
      await SentryService.instance.logErrorAPITransaction(e);
      handler = _responseHandler<T>(Response<T>(
          requestOptions: e.requestOptions,
          data: e.response?.data,
          statusCode: e.response?.statusCode,
          extra: <String, dynamic>{"error": e}));
    } finally {
      await SentryService.instance.finishAPITransaction();
    }
    await _dismissLoading(dismissLoader);
    return handler;
  }

  /// Performs a GET request and returns a response handler.
  FutureOr<ResponseHandler<T?>> get<T>(String endUrl,
      {Map<String, dynamic>? params,
      Options? options,
      CancelToken? cancelToken,
      bool needToCache = false,
      int? cacheDurationMnt}) async {
    return _responseHandler<T>(await _dio?.get<T>(
      endUrl,
      queryParameters: params,
      cancelToken: cancelToken ?? _cancelToken,
      options: _handleCacheOption(options,
          needToCache: needToCache, cacheDuration: cacheDurationMnt),
    ));
  }

  /// Performs a POST request and returns a response handler.
  FutureOr<ResponseHandler<T?>> post<T>(String endUrl,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? params,
      Options? options,
      CancelToken? cancelToken,
      bool isMultipartFormData = false,
      bool needToCache = false,
      int? cacheDurationMnt}) async {
    return _responseHandler<T>(await _dio?.post<T>(
      endUrl,
      data: isMultipartFormData ? FormData.fromMap(data!) : data,
      queryParameters: params,
      cancelToken: cancelToken ?? _cancelToken,
      options: _handleCacheOption(options,
          needToCache: needToCache, cacheDuration: cacheDurationMnt),
    ));
  }

  /// Performs a DELETE request and returns a response handler.
  FutureOr<ResponseHandler<T?>> delete<T>(
    String endUrl, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _responseHandler<T>(await _dio?.delete<T>(
      endUrl,
      data: data,
      queryParameters: params,
      cancelToken: cancelToken ?? _cancelToken,
      options: options,
    ));
  }

  /// Modifies the given [options] to enable caching if [needToCache] is true.
  /// Adds 'cache' and 'validate_time' to the extra field to specify cache settings.
  /// Returns updated [options] or the original [options] if caching is not needed.
  Options? _handleCacheOption(Options? options,
      {bool needToCache = false, int? cacheDuration}) {
    if (needToCache) {
      options = options ?? Options();
      return options.copyWith(extra: <String, Object?>{
        ApiConst.cacheArgument: needToCache,
        // Explicitly enable caching
        ApiConst.cacheDurationArgument: cacheDuration,
        // Cache validity time (minutes)
      });
    }
    return options;
  }

  /// Handles the response and returns a response handler.
  ResponseHandler<T?> _responseHandler<T>(Response<T>? response) {
    if (response?.statusCode == 200) {
      return OnSuccessResponse<T?>(response: response?.data);
    } else if (response?.statusCode == 401) {
      return OnFailureResponse<T?>(
        error: ErrorResult(
          errorMessage: MainConfig.context.appString.unauthorizedKey,
          type: DioExceptionType.unknown,
        ),
        statusCode: 401,
      );
    } else if (response?.statusCode == 500) {
      return OnFailureResponse<T?>(
        error: ErrorResult(
          errorMessage: MainConfig.context.appString.serverNotRespondKey,
          type: DioExceptionType.badResponse,
        ),
        statusCode: 500,
      );
    } else {
      return OnFailureResponse<T?>(
        error: ErrorResult(
          errorMessage: MainConfig.context.appString.somethingWentWrongKey,
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  // ResponseHandler<T?> _errorHandler<T>(DioException error) {
  //   if (error.type == DioExceptionType.badResponse) {
  //     return OnSuccessResponse<T?>(response: error.response?.data);
  //   }
  //   return OnFailureResponse(error: ErrorResult.getErrorResult(error));
  // }

  /// Shows a loading indicator if [showLoader] is true.
  Future<void> _showLoading(bool showLoader) async {
    if (showLoader) await EasyLoading.show();
  }

  /// Dismisses the loading indicator if [dismissLoader] is true.
  Future<void> _dismissLoading(bool dismissLoader) async {
    if (dismissLoader) await EasyLoading.dismiss();
  }

  /// Handles the refresh token process and returns a response.
  Future<Response<dynamic>?>? handleRefreshToken(
    String endUrl, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    Response<dynamic>? response = await _dio?.request(
      endUrl,
      data: data,
      queryParameters: params,
      cancelToken: cancelToken,
      options: options,
    );
    return response;
  }
}

/// Interceptor to intercept api request and response.
class HttpHandleInterceptor extends Interceptor {
  /// The flag to check if the internet dialog is visible.
  static bool isInternetDialogVisible = false;

  /// The flag to check if the 401 is in progress.
  static bool is401InProgress = false;

  /// Checks the internet connectivity status.
  FutureOr<bool> _checkInternet() async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  /// Checks internet connection and handles request accordingly.
  /// Shows a dialog if internet is not available.
  Future<void> _checkInternetConnection(
      RequestOptions options, RequestInterceptorHandler handler) async {
    bool isConnected = await _checkInternet();
    if (isInternetDialogVisible) {
      //reject current api call
      return handler.reject(DioException(
        requestOptions: options,
        error: MainConfig.context.appString.noInternetConnectionKey,
      ));
    } else {
      if (isConnected) {
        return handler.next(options);
      } else {
        await EasyLoading.dismiss();

        if (!isInternetDialogVisible) {
          ///retry dialog for not internet connection
          await showCustomDialog(
            MainConfig.context.appString.noInternetConnectionDescriptionKey,
            title: MainConfig.context.appString.noInternetConnectionKey,
            okBtnTitle: MainConfig.context.appString.retryKey,
            isDialogHideOnClick: true,
            onOkClicked: () {
              isInternetDialogVisible = false;
              unawaited(showLoader(value: true));
              unawaited(_checkInternetConnection(options, handler));
            },
            cancelBtnTitle: MainConfig.context.appString.cancelKey,
            onCancelClicked: () {
              isInternetDialogVisible = false;
              //reject current api call
              handler.reject(DioException(
                requestOptions: options,
                error: MainConfig.context.appString.noInternetConnectionKey,
              ));
            },
          );
        }
      }
    }
  }

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    await _checkInternetConnection(options, handler);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !is401InProgress) {
      is401InProgress = true;
     
      //add your api call code here
      /*return handler.resolve(
          await MainConfig.apiClient .handleRefreshToken(
            err.requestOptions.path,
            params: err.requestOptions.queryParameters,
            options: Options(method: err.requestOptions.method),
            data: err.requestOptions.data,
            cancelToken: err.requestOptions.cancelToken,
          ));*/
      await SharedPref.instance.clearData();
      MainConfig.context.router.popUntilRoot();
      is401InProgress = false;
    } else {
      return handler.next(err);
    }
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }
}
