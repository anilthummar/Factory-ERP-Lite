import '../../../utils/exports.dart';

/// A class that defines the application's theme configuration.
///
/// This class manages all theme-related settings including colors, text styles,
/// component themes, and overall Material Design configuration.
class MyAppTheme {
  /// Singleton instance of [MyAppTheme]
  static MyAppTheme instance = getIt<MyAppTheme>();

  /// The application's color scheme that defines the color palette
  /// used throughout the application.
  ///
  /// This includes primary, secondary, surface, and other semantic colors
  /// following Material Design guidelines.
  final ColorScheme appColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.instance.primary,
    primaryContainer: AppColors.instance.primaryContainer,
    onPrimaryContainer: AppColors.instance.onPrimaryContainer,
    onPrimary: AppColors.instance.onPrimary,
    secondary: AppColors.instance.secondary,
    onSecondary: AppColors.instance.onSecondary,
    onSecondaryContainer: AppColors.instance.onSecondaryContainer,
    secondaryContainer: AppColors.instance.secondaryContainer,
    tertiary: AppColors.instance.lightGrayBGColor,
    error: AppColors.instance.redColor,
    onError: AppColors.instance.redColor,
    errorContainer: AppColors.instance.errorContainer,
    onErrorContainer: AppColors.instance.redColor,
    surface: AppColors.instance.surface,
    onSurface: AppColors.instance.onSurface,
    outline: AppColors.figmaGrayE0,
    outlineVariant: AppColors.figmaGrayE6,
    surfaceContainerHighest: AppColors.figmaGrayEE,
    shadow: AppColors.instance.blackBGColor,
  );

  /// Returns the main theme configuration for the application.
  ///
  /// This getter provides a complete [ThemeData] object that defines
  /// the visual properties for the entire application.
  ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: getAppBarTheme(),
      primaryTextTheme: AppStyles.instance.textTheme,
      colorScheme: appColorScheme,
      splashColor: appColorScheme.onPrimary.withValues(alpha: Dimens.opacity014),
      iconTheme: IconThemeData(color: appColorScheme.onSurface),
      scaffoldBackgroundColor: appColorScheme.surface,
      buttonTheme: getButtonTheme(),
      textButtonTheme: getTextButtonThemeData(),
      elevatedButtonTheme: getElevatedButtonThemeData(),
      outlinedButtonTheme: getOutlinedButtonThemeData(),
      floatingActionButtonTheme: getFloatingActionButtonThemeData(),
      textTheme: AppStyles.instance.textTheme,
      inputDecorationTheme: getInputDecorationTheme(),
      cardTheme: getCardTheme(),
      dialogTheme: getDialogTheme(),
      bottomSheetTheme: getBottomSheetThemeData(),
      bottomNavigationBarTheme: getBottomNavigationBarThemeData(),
      dividerColor: appColorScheme.outline,
      drawerTheme: getDrawerThemeData(),
      tabBarTheme: getTabBarTheme(),
      switchTheme: getSwitchThemeData(),
      snackBarTheme: getSnackBarThemeData(),
      radioTheme: getRadioThemeData(),
      progressIndicatorTheme: getProgressIndicatorThemeData(),
      popupMenuTheme: getPopupMenuThemeData(),
      useMaterial3: true,
      extensions: const <ThemeExtension<dynamic>>[
        AppThemeColors.light,
      ],
    );
  }

  /// Returns the theme configuration for app bars.
  ///
  /// Defines visual properties like color, elevation, text styles,
  /// and icon themes for application bars.
  AppBarTheme getAppBarTheme() {
    return AppBarTheme(
      backgroundColor: appColorScheme.primary,
      centerTitle: true,
      actionsIconTheme:
          IconThemeData(color: appColorScheme.onPrimary, size: Dimens.size25),
      shadowColor: AppColors.instance.lightGrayBGColor,
      shape: Border(
        bottom: BorderSide(
          color: AppColors.instance.lightGrayBGColor,
        ),
      ),
      iconTheme: IconThemeData(color: appColorScheme.onPrimary),
      titleTextStyle: AppStyles.instance.textTheme.titleLarge?.copyWith(
          fontSize: Dimens.fontSize20, color: appColorScheme.primary),
      systemOverlayStyle: systemOverlay(),
    );
  }

  /// Returns the system overlay style configuration.
  ///
  /// Configures the appearance of system UI overlays like the status bar
  /// and navigation bar to match the app's theme.
  SystemUiOverlayStyle systemOverlay() {
    return SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarColor: appColorScheme.primary,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: appColorScheme.primary,
      systemNavigationBarDividerColor: appColorScheme.surface,
      systemNavigationBarIconBrightness: Brightness.light,
    );
  }

  /// Returns the theme configuration for buttons.
  ///
  /// Defines common button properties like colors, padding, and shape
  /// for all button types.
  ButtonThemeData getButtonTheme() {
    return ButtonThemeData(
        buttonColor: appColorScheme.primary,
        disabledColor: appColorScheme.outline,
        padding: const EdgeInsets.symmetric(
            vertical: Dimens.padding10, horizontal: Dimens.padding20),
        colorScheme: appColorScheme,
        textTheme: ButtonTextTheme.primary,
        splashColor: appColorScheme.onPrimary.withValues(alpha:Dimens.opacity014),
        shape: RoundedRectangleBorder(
          borderRadius: Dimens.radius10.borderRadius,
          side: Dimens.borderWidth3.borderSide(
            color: appColorScheme.primary,
            style: BorderStyle.solid,
          ),
        ));
  }

  /// Returns the theme configuration for text buttons.
  ///
  /// Customizes the appearance of text buttons including text style,
  /// colors, and interaction states.
  TextButtonThemeData getTextButtonThemeData() {
    return TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return appColorScheme.primary.withValues(alpha:Dimens.opacity014);
            }
            return null;
          },
        ),
        foregroundColor:
            WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return appColorScheme.tertiary;
          }
          return appColorScheme.surface;
        }),
        textStyle: WidgetStatePropertyAll<TextStyle?>(
          AppStyles.instance.textTheme.titleLarge?.copyWith(
              fontSize: Dimens.fontSize20, color: appColorScheme.surface),
        ),
        shape: WidgetStatePropertyAll<OutlinedBorder?>(
          RoundedRectangleBorder(
            borderRadius: Dimens.radius6.borderRadius,
          ),
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return appColorScheme.outline;
            }
            return null;
          },
        ),
      ),
    );
  }

  /// Returns the theme configuration for elevated buttons.
  ///
  /// Defines the appearance of elevated buttons including elevation,
  /// colors, text styles, and interaction states.
  ElevatedButtonThemeData getElevatedButtonThemeData() {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return appColorScheme.onPrimary.withValues(alpha:Dimens.opacity014);
            }
            return null;
          },
        ),
        shadowColor: WidgetStatePropertyAll<Color?>(
          appColorScheme.shadow,
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return appColorScheme.tertiary;
            }
            return null;
          },
        ),
        foregroundColor:
            WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return appColorScheme.tertiary;
          }
          return appColorScheme.surface;
        }),
        textStyle: WidgetStatePropertyAll<TextStyle?>(
          AppStyles.instance.textTheme.titleLarge?.copyWith(
              fontSize: Dimens.fontSize20, color: appColorScheme.surface),
        ),
        padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
          EdgeInsets.only(
              left: Dimens.padding36,
              right: Dimens.padding36,
              top: Dimens.padding18,
              bottom: Dimens.padding18),
        ),
        side: WidgetStatePropertyAll<BorderSide?>(
          Dimens.borderWidth05.borderSide(
            color: AppColors.instance.lightGrayBGColor,
            style: BorderStyle.solid,
            strokeAlign: Dimens.borderWidth1,
          ),
        ),
        shape: WidgetStatePropertyAll<OutlinedBorder?>(
          RoundedRectangleBorder(
            borderRadius: Dimens.radius6.borderRadius,
          ),
        ),
      ),
    );
  }

  /// Returns the theme configuration for outlined buttons.
  ///
  /// Customizes the appearance of outlined buttons including border,
  /// colors, text styles, and interaction states.
  OutlinedButtonThemeData getOutlinedButtonThemeData() {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return appColorScheme.primary.withValues(alpha:Dimens.opacity014);
            }
            return null;
          },
        ),
        backgroundColor: WidgetStatePropertyAll<Color?>(
          appColorScheme.surface,
        ),
        foregroundColor:
            WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return appColorScheme.tertiary;
          }
          return appColorScheme.surface;
        }),
        textStyle: WidgetStatePropertyAll<TextStyle?>(
          AppStyles.instance.textTheme.titleLarge?.copyWith(
              fontSize: Dimens.fontSize20, color: appColorScheme.surface),
        ),
        padding: const WidgetStatePropertyAll<EdgeInsetsGeometry?>(
            EdgeInsets.symmetric(
                horizontal: Dimens.padding30, vertical: Dimens.padding10)),
        side: WidgetStatePropertyAll<BorderSide?>(
          Dimens.borderWidth1.borderSide(
            color: appColorScheme.surface,
            style: BorderStyle.solid,
            strokeAlign: Dimens.borderWidth1,
          ),
        ),
        shape: WidgetStatePropertyAll<OutlinedBorder?>(
          RoundedRectangleBorder(
            borderRadius: Dimens.radius27.borderRadius,
          ),
        ),
      ),
    );
  }

  /// Returns the theme configuration for floating action buttons.
  ///
  /// Defines the appearance of floating action buttons including
  /// elevation, colors, and shape.
  FloatingActionButtonThemeData getFloatingActionButtonThemeData() {
    return FloatingActionButtonThemeData(
      elevation: Dimens.space4,
      backgroundColor: appColorScheme.primary,
      shape: RoundedRectangleBorder(borderRadius: Dimens.radius20.borderRadius),
      disabledElevation: Dimens.zero,
      extendedIconLabelSpacing: Dimens.space20,
      splashColor: appColorScheme.primary.withValues(alpha:Dimens.opacity014),
    );
  }

  /// Returns the theme configuration for input decorations.
  ///
  /// Customizes the appearance of input fields including borders,
  /// labels, hints, and error styles.
  InputDecorationTheme getInputDecorationTheme() {
    return InputDecorationTheme(
      isCollapsed: true,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: Dimens.padding10),
      hintStyle: AppStyles.instance.textTheme.labelSmall
          ?.copyWith(color: AppColors.instance.lightGrayTextColor),
      labelStyle: AppStyles.instance.textTheme.bodyMedium,
      hoverColor: Colors.transparent,
      errorStyle:
          AppStyles.instance.errorStyle.copyWith(fontSize: Dimens.fontSize12),
      alignLabelWithHint: true,
      errorMaxLines: Dimens.maxLines03,
      border: Dimens.radius4.outlineInputBorder(
        borderSide:
            Dimens.borderWidth1.borderSide(color: appColorScheme.outline),
      ),
      focusedBorder: Dimens.radius4.outlineInputBorder(
        borderSide:
            Dimens.borderWidth1.borderSide(color: appColorScheme.tertiary),
      ),
      errorBorder: Dimens.radius4.outlineInputBorder(
        borderSide: Dimens.borderWidth1.borderSide(color: appColorScheme.error),
      ),
      focusedErrorBorder: Dimens.radius4.outlineInputBorder(
        borderSide: Dimens.borderWidth1.borderSide(color: appColorScheme.error),
      ),
      disabledBorder: Dimens.radius4.outlineInputBorder(
        borderSide: Dimens.borderWidth1
            .borderSide(color: appColorScheme.outline.withValues(alpha:0.5)),
      ),
    );
  }

  /// Returns the theme configuration for cards.
  ///
  /// Defines the appearance of cards including color, shape,
  /// shadow, and elevation.
  CardThemeData getCardTheme() {
    return CardThemeData(
      color: AppColors.instance.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: Dimens.radius10.borderRadius,
      ),
      shadowColor: AppColors.instance.transparent,
      elevation: Dimens.space4,
    );
  }

  /// Returns the theme configuration for dialogs.
  ///
  /// Customizes the appearance of dialogs including background,
  /// shape, elevation, and text styles.
  DialogThemeData getDialogTheme() {
    return DialogThemeData(
      backgroundColor: appColorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: Dimens.radius20.borderRadius,
      ),
      elevation: Dimens.space4,
      titleTextStyle: AppStyles.instance.textTheme.titleLarge
          ?.copyWith(color: appColorScheme.onSurface),
      contentTextStyle: AppStyles.instance.textTheme.bodyMedium?.copyWith(
        color: appColorScheme.onSurface,
      ),
    );
  }

  /// Returns the theme configuration for bottom sheets.
  ///
  /// Defines the appearance of bottom sheets including background,
  /// shape, and elevation.
  BottomSheetThemeData getBottomSheetThemeData() {
    return BottomSheetThemeData(
      backgroundColor: appColorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Dimens.radius24.circularRadius,
          topRight: Dimens.radius24.circularRadius,
        ),
      ),
      modalBackgroundColor: appColorScheme.surface,
      elevation: Dimens.space4,
      modalElevation: Dimens.space4,
    );
  }

  /// Returns the theme configuration for bottom navigation bars.
  ///
  /// Customizes the appearance of bottom navigation bars including
  /// colors, icons, and labels.
  BottomNavigationBarThemeData getBottomNavigationBarThemeData() {
    return BottomNavigationBarThemeData(
      elevation: Dimens.space4,
      backgroundColor: appColorScheme.surface,
      selectedIconTheme:
          IconThemeData(color: appColorScheme.surface, size: Dimens.size28),
      selectedItemColor: appColorScheme.surface,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      unselectedIconTheme: IconThemeData(color: appColorScheme.tertiary),
      unselectedItemColor: appColorScheme.tertiary,
      selectedLabelStyle: AppStyles.instance.textTheme.bodyMedium
          ?.copyWith(fontSize: Dimens.fontSize12),
      unselectedLabelStyle: AppStyles.instance.textTheme.bodyMedium
          ?.copyWith(fontSize: Dimens.fontSize12),
    );
  }

  /// Returns the theme configuration for drawers.
  ///
  /// Defines the appearance of navigation drawers.
  DrawerThemeData getDrawerThemeData() {
    return DrawerThemeData(
      backgroundColor: appColorScheme.surface,
    );
  }

  /// Returns the theme configuration for tab bars.
  ///
  /// Customizes the appearance of tab bars including colors,
  /// indicators, and text styles.
  TabBarThemeData getTabBarTheme() {
    return TabBarThemeData(
      overlayColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return appColorScheme.surface.withValues(alpha: Dimens.opacity014);
          }
        return null;
      }),
    );
  }

  /// Returns the theme configuration for switches.
  ///
  /// Defines the appearance of switch widgets including colors
  /// and interaction states.
  SwitchThemeData getSwitchThemeData() {
    return SwitchThemeData(
      thumbColor: WidgetStatePropertyAll<Color?>(appColorScheme.surface),
      trackColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected) ||
              states.contains(WidgetState.pressed)) {
            return appColorScheme.surface;
          }
          return appColorScheme.tertiary;
        },
      ),
      overlayColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return appColorScheme.surface.withValues(alpha:Dimens.opacity014);
          }
          return null;
        },
      ),
      splashRadius: Dimens.radius10,
    );
  }

  /// Returns the theme configuration for snack bars.
  ///
  /// Customizes the appearance of snack bars including colors,
  /// shape, and text styles.
  SnackBarThemeData getSnackBarThemeData() {
    return SnackBarThemeData(
      shape: RoundedRectangleBorder(borderRadius: Dimens.radius6.borderRadius),
      backgroundColor: appColorScheme.onSurface,
      actionTextColor: appColorScheme.surface,
      contentTextStyle: AppStyles.instance.textTheme.bodyMedium
          ?.copyWith(color: appColorScheme.surface),
    );
  }

  /// Returns the theme configuration for radio buttons.
  ///
  /// Defines the appearance of radio buttons including colors
  /// and interaction states.
  RadioThemeData getRadioThemeData() {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        return appColorScheme.primary;
      }),
      splashRadius: Dimens.radius10,
    );
  }

  /// Returns the theme configuration for progress indicators.
  ///
  /// Customizes the appearance of progress indicators including
  /// colors and dimensions.
  ProgressIndicatorThemeData getProgressIndicatorThemeData() {
    return ProgressIndicatorThemeData(
      circularTrackColor: Colors.transparent,
      color: appColorScheme.tertiary,
      linearMinHeight: Dimens.space2,
      linearTrackColor: Colors.transparent,
    );
  }

  /// Returns the theme configuration for popup menus.
  ///
  /// Defines the appearance of popup menus including colors,
  /// elevation, shape, and text styles.
  PopupMenuThemeData getPopupMenuThemeData() {
    return PopupMenuThemeData(
        color: appColorScheme.surface,
        elevation: Dimens.space4,
        shape:
            RoundedRectangleBorder(borderRadius: Dimens.radius10.borderRadius),
        textStyle: AppStyles.instance.textTheme.bodySmall);
  }
}
