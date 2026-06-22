import 'exports.dart';

// extension AppLocalizationsExtension on BuildContext {
//   AppLocalizations get l10n => AppLocalizations.of(this);
// }

/// Extension methods for [BuildContext] to provide easy access to common properties.
extension CustomExtension on BuildContext {
  /// Provides access to the current [ThemeData].
  ThemeData get theme => Theme.of(this);

  /// Provides access to the current [TextTheme].
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Provides access to the current [AppString].
  AppString get appString => AppString.of(this);

  /// Provides access to the current [ScaffoldMessengerState].
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  /// Provides the width of the screen.
  double get width => MediaQuery.of(this).size.width;

  /// Provides the height of the screen.
  double get height => MediaQuery.of(this).size.height;

  /// Provides an instance of the specified type [T].
  T instance<T>() => read<T>();

  /// Moves focus to the next focus node.
  void nextFocus() => FocusScope.of(this).nextFocus();

  /// Hides the keyboard by unfocusing the primary focus.
  void hideKeyboard() =>
      FocusManager.instance.primaryFocus?.unfocus();

  /// Whether the current view is mobile (width < [AppConstant.mobilePixelWidth]).
  bool get isMobileView => width < AppConstant.mobilePixelWidth;

  /// Whether the current view is tablet (between mobile and web breakpoints).
  bool get isTabletView =>
      width >= AppConstant.mobilePixelWidth &&
      width < AppConstant.webPixelWidth;

  /// Whether the current view is web/desktop (width >= [AppConstant.webPixelWidth]).
  bool get isWebView => width >= AppConstant.webPixelWidth;
}
