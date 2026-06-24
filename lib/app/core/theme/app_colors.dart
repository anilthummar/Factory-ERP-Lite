import '../../../utils/exports.dart';

/// A class that defines the color palette for the application.
///
/// This class contains all the colors used throughout the application,
/// including theme colors, text colors, and background colors.
class AppColors {
  /// Singleton instance of [AppColors]
  static AppColors instance = getIt<AppColors>();

  // Figma selection palette
  /// #000000
  static const Color figmaBlack = Color(0xFF000000);

  /// #828282
  static const Color figmaGray828 = Color(0xFF828282);

  /// #FFFFFF
  static const Color figmaWhite = Color(0xFFFFFFFF);

  /// #E6E6E6
  static const Color figmaGrayE6 = Color(0xFFE6E6E6);

  /// #EEEEEE
  static const Color figmaGrayEE = Color(0xFFEEEEEE);

  /// #E0E0E0
  static const Color figmaGrayE0 = Color(0xFFE0E0E0);

  /// #4285F4
  static const Color googleBlue = Color(0xFF4285F4);

  /// #34A853
  static const Color googleGreen = Color(0xFF34A853);

  /// #EB4335
  static const Color googleRed = Color(0xFFEB4335);

  /// #FBBC05
  static const Color googleYellow = Color(0xFFFBBC05);

  // Base Colors
  /// Pure white color
  static const Color whiteColor = figmaWhite;

  /// Standard black color for text and icons
  static const Color blackColor = figmaBlack;

  /// Deep blue color for primary elements
  static const Color darkBlueColor = Color(0xFF1F1C57);

  /// Light grey for subtle UI elements
  static const Color lightGreyColor = Color(0xFFD3D3D3);

  /// Medium grey for secondary text
  static const Color normalGreyColor = figmaGray828;

  /// Very light grey for backgrounds
  static const Color extraLightGreyColor = figmaGrayEE;

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
  Color primary = figmaBlack;

  /// Color for content on primary color
  Color onPrimary = figmaWhite;

  /// Container with primary color
  Color primaryContainer = figmaBlack;

  /// Color for content on primary container
  Color onPrimaryContainer = figmaWhite;

  /// Secondary brand color
  Color secondary = orangeColor;

  /// Color for content on secondary color
  Color onSecondary = whiteColor;

  /// Color for content on secondary container
  Color onSecondaryContainer = orangeColor;

  /// Background color for secondary containers
  Color secondaryContainer = figmaGrayEE;

  /// Main background color
  Color background = figmaWhite;

  /// Color for content on background
  Color onBackground = figmaBlack;

  /// Surface color for cards and elevated elements
  Color surface = figmaWhite;

  /// Color for content on surface
  Color onSurface = figmaBlack;

  /// Alert color for error states and warnings
  Color redColor = normalRedColor;

  // Text Colors
  /// Color for text on white backgrounds
  Color whiteTextColor = whiteColor;

  /// Color for primary text
  Color blackTextColor = blackColor;

  /// Color for subtle/disabled text
  Color lightGrayTextColor = figmaGrayE0;

  /// Color for secondary text
  Color mediumGrayTextColor = figmaGray828;

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
  Color lightGrayBGColor = figmaGrayE0;

  /// Very light grey background for subtle containers
  Color extraLightGreyBGColor = figmaGrayEE;

  /// Light red background for warnings
  Color lightRedBGColor = lightRedColor;
}
