import 'package:sentry_flutter/sentry_flutter.dart';
import '../../utils/exports.dart';

/// Service for managing Sentry operations.
class SentryService {
  SentryService._internal();

  /// The instance of the [SentryService].
  static final SentryService instance = SentryService._internal();

  late ISentrySpan _span;
  late ISentrySpan _transaction;

  /// Initializes the Sentry service.
  Future<void> init() async {
    await SentryFlutter.init(
      (SentryFlutterOptions options) {
        options
          ..dsn = configSentryDSN
          ..tracesSampleRate = 1.0
          ..attachScreenshot = true
          ..addIntegration(LoggingIntegration());
      },
    );
  }

  /// Starts a new API transaction.
  ///
  /// [apiName] is the name of the API for the transaction.
  void startAPITransaction({required String apiName}) {
    // If there is no active transaction, start one
    _transaction = Sentry.startTransaction(
      apiName,
      'request',
      bindToScope: true,
    );
    //
    _transaction.setTag('user_id', AppConstant.sentryUserId);
    _span = _transaction.startChild(
      'dio',
      description: 'desc',
    );
  }

  /// Logs a successful API transaction.
  ///
  /// [handler] is the response handler for the API.
  Future<void> logSuccessAPITransaction<T>(ResponseHandler<T> handler) async {
    if (handler.isSuccess()) {
      _transaction.setData(
          SentryConst.response, handler.getSuccessInstance()?.response);
    } else {
      _transaction.setData(SentryConst.response,
          jsonEncode(handler.getFailureInstance()?.error));
    }

    await _transaction.finish(status: const SpanStatus.ok());
    _span.status = const SpanStatus.ok();
  }

  /// Logs an error in the API transaction.
  ///
  /// [e] is the exception to log.
  Future<void> logErrorAPITransaction(Exception e) async {
    _span
      ..throwable = e
      ..status = const SpanStatus.internalError();
  }

  /// Finishes the API transaction.
  Future<void> finishAPITransaction() async {
    await _span.finish();
    await _transaction.finish();
  }

  /// Configures the Sentry scope with user information.
  ///
  /// [sentryUserId] is the user ID for Sentry.
  /// [sentryUserEmail] is the user email for Sentry.
  Future<void> configScope(
      {String? sentryUserId, String? sentryUserEmail}) async {
    Sentry.configureScope(
      (Scope scope) async =>
          scope.setUser(SentryUser(id: sentryUserId, email: sentryUserEmail)),
    );
  }

  /// Captures an event in Sentry.
  ///
  /// [event] is the event message.
  /// [type] is the type of the event.
  /// [tagKey] is the key for the event tag.
  /// [tagValue] is the value for the event tag.
  Future<void> captureEvent(String event,
      {String? type,
      String tagKey = 'base_structure-tag',
      String tagValue = 'base_structure-event'}) async {
    await Sentry.captureEvent(
      SentryEvent(
        tags: <String, String>{tagKey: tagValue},
        message: SentryMessage(event),
        level: SentryLevel
            .info, // Set the desired level (info, warning, error, etc.)
      ),
    );
  }

  /// Adds a breadcrumb to the current Sentry scope.
  ///
  /// [crumb] is the breadcrumb to add.
  /// [hint] is an optional hint for the breadcrumb.
  Future<void> addBreadcrumb(Breadcrumb crumb, {Hint? hint}) async =>
      Sentry.addBreadcrumb(crumb, hint: hint);

  /// Captures an exception in Sentry.
  ///
  /// [exception] is the exception to capture.
  /// [stackTrace] is the stack trace of the exception.
  /// [tagKey] is the key for the exception tag.
  /// [tagValue] is the value for the exception tag.
  Future<void> captureException(dynamic exception,
      {dynamic stackTrace,
      String tagKey = 'base_structure-tag',
      String tagValue = 'base_structure-exception'}) async {
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (Scope scope) async {
        await scope.setTag(tagKey, tagValue);
        scope.level = SentryLevel.warning;
      },
    );
  }
}
