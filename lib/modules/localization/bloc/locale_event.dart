import '../../../utils/exports.dart';

/// Base event for locale changes.
sealed class LocaleEvent extends Equatable {
  /// Creates locale event.
  const LocaleEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Event fired when language is changed.
class LocaleChangeRequested extends LocaleEvent {
  /// Target language code.
  final String languageCode;

  /// Creates a language change event.
  const LocaleChangeRequested(this.languageCode);

  @override
  List<Object?> get props => <Object?>[languageCode];
}
