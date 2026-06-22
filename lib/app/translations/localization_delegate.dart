import '../../utils/exports.dart';

/// A delegate for loading localized resources.
///
/// This delegate is responsible for loading the appropriate localized resources
/// based on the current locale of the application.
class AppLocalizationsDelegate extends LocalizationsDelegate<AppString> {
  @override
  bool isSupported(Locale locale) =>
      <String>[AppConstant.en, AppConstant.hi].contains(locale.languageCode);

  @override
  Future<AppString> load(Locale locale) async {
    switch (locale.languageCode) {
      case AppConstant.en:
        return EnUS();
      case AppConstant.hi:
        return HiIN();
      default:
        return EnUS();
    }
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppString> old) => false;
}
