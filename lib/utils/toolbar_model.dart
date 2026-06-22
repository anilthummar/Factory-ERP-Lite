import 'exports.dart';

/// Model for configuring the toolbar options.
///
/// [isToolBarVisible] determines if the toolbar is visible.
/// [isLogoVisible] determines if the logo is visible.
/// [isMenuVisible] determines if the menu is visible.
/// [isSafeAreaVisible] determines if the safe area is visible.
/// [appBarColor] sets the color of the app bar.
/// [onMenuClick] is the callback for menu click events.
/// [onLogoutClick] is the callback for logout click events.
class ToolBarModel {
  /// The flag to check if the toolbar is visible.
  bool isToolBarVisible, isLogoVisible, isMenuVisible, isSafeAreaVisible;
  /// The color of the app bar.
  Color? appBarColor;

  // BaseGetxController? currentController;
  /// The callback for menu click events.
  Function()? onMenuClick;
  /// The callback for logout click events.
  Function()? onLogoutClick;

  /// Creates a [ToolBarModel] instance with the given parameters.
  ///
  /// [isToolBarVisible] determines if the toolbar is visible.
  /// [isSafeAreaVisible] determines if the safe area is visible.
  /// [isMenuVisible] determines if the menu is visible.
  /// [appBarColor] sets the color of the app bar.
  /// [isLogoVisible] determines if the logo is visible.
  /// [onLogoutClick] is the callback for logout click events.
  ToolBarModel(
      {this.isToolBarVisible = false,
      this.isSafeAreaVisible = true,
      this.isMenuVisible = false,
      Color? appBarColor,
      this.isLogoVisible = false,
      // this.currentController,
      this.onLogoutClick})
      : appBarColor = appBarColor ?? AppColors.instance.blueBGColor;
}
