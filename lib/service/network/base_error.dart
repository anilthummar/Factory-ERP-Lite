import '../../utils/exports.dart';

/// A class representing an error result from a network request.
///
/// This class contains information about the error, such as the message,
/// type, status code, and whether a retry is possible.
class ErrorResult {
  /// The error message.
  String errorMessage;

  /// The type of the error.
  DioExceptionType type;

  /// The status code of the error, if available.
  int? statusCode = -1;

  /// Indicates whether a retry is possible.
  bool isRetry;

  /// Creates an error result with the specified properties.
  ErrorResult({
    required this.errorMessage,
    required this.type,
    this.isRetry = false,
    this.statusCode,
  });

  /// Factory method for creating an error result from a Dio exception.
  factory ErrorResult.getErrorResult(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.cancel:
        return ErrorResult(
          errorMessage: AppString.of(MainConfig.context).cancelKey,
          type: DioExceptionType.cancel,
        );

      case DioExceptionType.connectionTimeout:
        return ErrorResult(
          errorMessage: AppString.of(MainConfig.context).somethingWentWrongKey,
          type: DioExceptionType.connectionTimeout,
        );
      case DioExceptionType.sendTimeout:
        return ErrorResult(
          errorMessage: AppString.of(MainConfig.context).somethingWentWrongKey,
          type: DioExceptionType.sendTimeout,
        );
      case DioExceptionType.receiveTimeout:
        return ErrorResult(
          errorMessage: AppString.of(MainConfig.context).somethingWentWrongKey,
          type: DioExceptionType.receiveTimeout,
        );
      case DioExceptionType.badResponse:
        return ErrorResult(
          errorMessage: AppString.of(MainConfig.context).problemWithRequestKey,
          type: DioExceptionType.badResponse,
        );

      case DioExceptionType.unknown:
        return ErrorResult(
          errorMessage: AppString.of(MainConfig.context).somethingWentWrongKey,
          type: DioExceptionType.connectionError,
        );
      default:
        return ErrorResult(
            errorMessage: exception.message ??
                AppString.of(MainConfig.context).somethingWentWrongKey,
            type: DioExceptionType.unknown);
    }
  }
}
