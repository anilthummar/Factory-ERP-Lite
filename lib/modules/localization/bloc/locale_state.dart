import '../../../utils/exports.dart';

/// Represents the state of the application's locale.
///
/// This state includes the current locale and its status.
class ChangeLocaleState {
  /// The current status of the locale state.
  final BaseStateStatus status;

  /// The current locale of the application.
  final Locale locale;

  /// Creates a new instance of [ChangeLocaleState].
  ///
  /// [status] is the current status of the locale state.
  /// [locale] is the current locale of the application.
  ChangeLocaleState(
    this.status, {
    required this.locale,
  });
}
