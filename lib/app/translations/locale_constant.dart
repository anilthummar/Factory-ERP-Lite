import '../../utils/exports.dart';

/// Sets the locale for the application.
///
/// [languageCode] - The language code to set as the current locale.
/// Returns a [Locale] object representing the new locale.
Future<Locale> setLocale(String languageCode) async {
  await SharedPref.instance.setValue(SharedPref.currentLocaleKey, languageCode);
  return _locale(languageCode);
}

/// Retrieves the current locale of the application.
///
/// Returns a [Locale] object representing the current locale.
Locale getLocale() {
  String languageCode = SharedPref.instance
      .getString(SharedPref.currentLocaleKey, AppConstant.en);
  return _locale(languageCode);
}

/// Returns a [Locale] object based on the provided language code.
///
/// [languageCode] - The language code to convert to a [Locale] object.
/// If the language code is empty, defaults to English.
Locale _locale(String languageCode) {
  return languageCode.isNotEmpty
      ? Locale(languageCode, '')
      : const Locale(AppConstant.en, '');
}
