import '../utils/exports.dart';

/// A configuration class for managing device and package information.
///
/// This class provides access to device information, package information,
/// and application-wide configurations.
class MainConfig {
  /// Information about the Android device.
  late final AndroidDeviceInfo androidInfo;

  /// Information about the iOS device.
  late final IosDeviceInfo iosDeviceInfo;

  /// Information about the web browser.
  late final WebBrowserInfo webBrowserInfo;

  /// Information about the application package.
  late final PackageInfo packageInfo;

  /// Returns the API client instance.
  static ApiClient get apiClient => getIt<ApiClient>();

  /// The current build context of the application.
  static BuildContext context = getIt<AppRouter>().navigatorKey.currentContext!;

  /// Returns the text theme for the application.
  static TextTheme textTheme(BuildContext ctx) => ctx.theme.textTheme;
}
