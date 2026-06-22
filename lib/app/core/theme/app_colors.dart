import '../../../utils/exports.dart';

/// A class that defines the color palette for the application.
///
/// This class contains all the colors used throughout the application,
/// including theme colors, text colors, and background colors.
class AppColors {
  /// Singleton instance of [AppColors]
  static AppColors instance = getIt<AppColors>();

  // Base Colors
  /// Pure white color
  static const Color whiteColor = Colors.white;

  /// Standard black color for text and icons
  static const Color blackColor = Color(0xFF2F2F2F);

  /// Deep blue color for primary elements
  static const Color darkBlueColor = Color(0xFF1F1C57);

  /// Light grey for subtle UI elements
  static const Color lightGreyColor = Color(0xFFD3D3D3);

  /// Medium grey for secondary text
  static const Color normalGreyColor = Color(0xFF878893);

  /// Very light grey for backgrounds
  static const Color extraLightGreyColor = Color(0xFFF5F5F5);

  /// Brand orange color
  static const Color orangeColor = Color(0xFFF56E28);

  /// Standard red for error states
  static const Color normalRedColor = Color(0xFFEA4128);

  /// Lighter red for warnings
  static const Color lightRedColor = Color(0xFFE74646);

  // Theme Colors
  /// Transparent color for overlays
  Color transparent = Colors.transparent;

  /// Light red for error containers
  Color errorContainer = Colors.redAccent.shade100;

  /// Primary brand color
  Color primary = orangeColor;

  /// Color for content on primary color
  Color onPrimary = whiteColor;

  /// Container with primary color
  Color primaryContainer = orangeColor;

  /// Color for content on primary container
  Color onPrimaryContainer = whiteColor;

  /// Secondary brand color
  Color secondary = orangeColor;

  /// Color for content on secondary color
  Color onSecondary = whiteColor;

  /// Color for content on secondary container
  Color onSecondaryContainer = orangeColor;

  /// Background color for secondary containers
  Color secondaryContainer = whiteColor;

  /// Main background color
  Color background = whiteColor;

  /// Color for content on background
  Color onBackground = whiteColor;

  /// Surface color for cards and elevated elements
  Color surface = whiteColor;

  /// Color for content on surface
  Color onSurface = blackColor;

  /// Alert color for error states and warnings
  Color redColor = normalRedColor;

  // Text Colors
  /// Color for text on white backgrounds
  Color whiteTextColor = whiteColor;

  /// Color for primary text
  Color blackTextColor = blackColor;

  /// Color for subtle/disabled text
  Color lightGrayTextColor = lightGreyColor;

  /// Color for secondary text
  Color mediumGrayTextColor = normalGreyColor;

  /// Color for emphasized blue text
  Color blueTextColor = darkBlueColor;

  /// Color for error/warning text
  Color redTextColor = lightRedColor;

  /// Color for highlighted/action text
  Color orangeTextColor = orangeColor;

  // Background Colors
  /// White background for cards and surfaces
  Color whiteBGColor = whiteColor;

  /// Dark blue background for emphasis
  Color blueBGColor = darkBlueColor;

  /// Orange background for CTAs
  Color orangeBGColor = orangeColor;

  /// Medium grey background for inactive states
  Color mediumGrayBGColor = normalGreyColor;

  /// Black background for contrast
  Color blackBGColor = blackColor;

  /// Light grey background for subtle separation
  Color lightGrayBGColor = lightGreyColor;

  /// Very light grey background for subtle containers
  Color extraLightGreyBGColor = extraLightGreyColor;

  /// Light red background for warnings
  Color lightRedBGColor = lightRedColor;
}
