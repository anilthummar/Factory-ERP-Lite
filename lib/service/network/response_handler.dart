import '../../utils/exports.dart';

/// This class is used to handle success and failure of the APIs.
sealed class ResponseHandler<T> {
  /// Returns an instance of [OnSuccessResponse] if the response is successful.
  OnSuccessResponse<T>? getSuccessInstance();

  /// Returns an instance of [OnFailureResponse] if the response is a failure.
  OnFailureResponse<T>? getFailureInstance();

  /// Checks if the response is successful.
  bool isSuccess();
  // bool isLoading();
  /// Checks if the response is a failure.
  bool isFailure();
}

/// This class is used to represent Success Response.
///
/// Response is handled using generics.
class OnSuccessResponse<T> extends ResponseHandler<T> {
  /// The successful response data.
  final T response;

  /// Creates an instance of [OnSuccessResponse].
  ///
  /// [response] is the successful response data.
  OnSuccessResponse({required this.response});

  /// Returns null as this is a success instance.
  @override
  OnFailureResponse<T>? getFailureInstance() => null;

  /// Returns this instance as it is a success instance.
  @override
  OnSuccessResponse<T>? getSuccessInstance() => this;

  /// Returns false as this is a success instance.
  @override
  bool isFailure() => false;

  /// Returns true as this is a success instance.
  @override
  bool isSuccess() => true;
}

/// This class is used to represent Failure Response.
///
/// Response is handled using generics.
class OnFailureResponse<T> extends ResponseHandler<T> {
  /// The HTTP status code of the failure.
  final int? statusCode;
  /// The error details of the failure.
  final ErrorResult? error;

  /// Creates an instance of [OnFailureResponse].
  ///
  /// [statusCode] is the HTTP status code of the failure.
  /// [error] is the error details of the failure.
  OnFailureResponse({this.statusCode, this.error});

  /// Returns this instance as it is a failure instance.
  @override
  OnFailureResponse<T>? getFailureInstance() => this;

  /// Returns null as this is a failure instance.
  @override
  OnSuccessResponse<T>? getSuccessInstance() => null;

  /// Returns true as this is a failure instance.
  @override
  bool isFailure() => true;

  /// Returns false as this is a failure instance.
  @override
  bool isSuccess() => false;
}

// class OnLoading extends ResponseHandler {}