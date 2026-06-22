import '../../../utils/exports.dart';

/// A bloc that manages the application's locale state.
///
/// This bloc handles changing the language of the application.
class LocaleBloc extends Bloc<LocaleEvent, ChangeLocaleState> {
  /// Creates a [LocaleBloc] with the default locale.
  LocaleBloc()
      : super(ChangeLocaleState(BaseStateStatus.initial, locale: const Locale(AppConstant.en))) {
    on<LocaleChangeRequested>(_onLocaleChangeRequested);
  }

  /// Changes the application's language.
  ///
  /// [languageCode] is the code of the language to switch to.
  Future<void> changeLanguage(String languageCode) async {
    add(LocaleChangeRequested(languageCode));
  }

  Future<void> _onLocaleChangeRequested(
    LocaleChangeRequested event,
    Emitter<ChangeLocaleState> emit,
  ) async {
    unawaited(setLocale(event.languageCode));
    emit(ChangeLocaleState(BaseStateStatus.success, locale: Locale(event.languageCode)));
  }
}
