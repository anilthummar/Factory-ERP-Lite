import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Semantic theme colors sourced from the Figma selection palette.
///
/// Registered as a [ThemeExtension] so screens resolve colors dynamically via
/// [Theme.of] and future light/dark variants can be swapped in one place.
@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  /// Creates [AppThemeColors].
  const AppThemeColors({
    required this.primaryText,
    required this.secondaryText,
    required this.surface,
    required this.onPrimaryButton,
    required this.primaryButton,
    required this.border,
    required this.borderLight,
    required this.socialSurface,
    required this.divider,
    required this.termsText,
    required this.linkText,
    required this.googleBlue,
    required this.googleGreen,
    required this.googleRed,
    required this.googleYellow,
  });

  /// #000000 — primary text, links, primary buttons.
  final Color primaryText;

  /// #828282 — secondary text, hints, legal copy.
  final Color secondaryText;

  /// #FFFFFF — screen and input backgrounds.
  final Color surface;

  /// #000000 — filled primary button background.
  final Color primaryButton;

  /// #FFFFFF — text on primary button.
  final Color onPrimaryButton;

  /// #E0E0E0 — input borders and dividers.
  final Color border;

  /// #E6E6E6 — subtle borders and separators.
  final Color borderLight;

  /// #EEEEEE — social sign-in button background.
  final Color socialSurface;

  /// #E0E0E0 — horizontal divider lines.
  final Color divider;

  /// #828282 — terms footer body text.
  final Color termsText;

  /// #000000 — terms and privacy link text.
  final Color linkText;

  /// #4285F4 — Google brand blue.
  final Color googleBlue;

  /// #34A853 — Google brand green.
  final Color googleGreen;

  /// #EB4335 — Google brand red.
  final Color googleRed;

  /// #FBBC05 — Google brand yellow.
  final Color googleYellow;

  /// Default light theme mapped to the Figma login screen palette.
  static const AppThemeColors light = AppThemeColors(
    primaryText: AppColors.figmaBlack,
    secondaryText: AppColors.figmaGray828,
    surface: AppColors.figmaWhite,
    primaryButton: AppColors.figmaBlack,
    onPrimaryButton: AppColors.figmaWhite,
    border: AppColors.figmaGrayE0,
    borderLight: AppColors.figmaGrayE6,
    socialSurface: AppColors.figmaGrayEE,
    divider: AppColors.figmaGrayE0,
    termsText: AppColors.figmaGray828,
    linkText: AppColors.figmaBlack,
    googleBlue: AppColors.googleBlue,
    googleGreen: AppColors.googleGreen,
    googleRed: AppColors.googleRed,
    googleYellow: AppColors.googleYellow,
  );

  @override
  AppThemeColors copyWith({
    Color? primaryText,
    Color? secondaryText,
    Color? surface,
    Color? primaryButton,
    Color? onPrimaryButton,
    Color? border,
    Color? borderLight,
    Color? socialSurface,
    Color? divider,
    Color? termsText,
    Color? linkText,
    Color? googleBlue,
    Color? googleGreen,
    Color? googleRed,
    Color? googleYellow,
  }) {
    return AppThemeColors(
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      surface: surface ?? this.surface,
      primaryButton: primaryButton ?? this.primaryButton,
      onPrimaryButton: onPrimaryButton ?? this.onPrimaryButton,
      border: border ?? this.border,
      borderLight: borderLight ?? this.borderLight,
      socialSurface: socialSurface ?? this.socialSurface,
      divider: divider ?? this.divider,
      termsText: termsText ?? this.termsText,
      linkText: linkText ?? this.linkText,
      googleBlue: googleBlue ?? this.googleBlue,
      googleGreen: googleGreen ?? this.googleGreen,
      googleRed: googleRed ?? this.googleRed,
      googleYellow: googleYellow ?? this.googleYellow,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) {
      return this;
    }

    return AppThemeColors(
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      primaryButton: Color.lerp(primaryButton, other.primaryButton, t)!,
      onPrimaryButton: Color.lerp(onPrimaryButton, other.onPrimaryButton, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderLight: Color.lerp(borderLight, other.borderLight, t)!,
      socialSurface: Color.lerp(socialSurface, other.socialSurface, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      termsText: Color.lerp(termsText, other.termsText, t)!,
      linkText: Color.lerp(linkText, other.linkText, t)!,
      googleBlue: Color.lerp(googleBlue, other.googleBlue, t)!,
      googleGreen: Color.lerp(googleGreen, other.googleGreen, t)!,
      googleRed: Color.lerp(googleRed, other.googleRed, t)!,
      googleYellow: Color.lerp(googleYellow, other.googleYellow, t)!,
    );
  }
}

/// Resolves [AppThemeColors] from the active [ThemeData].
extension AppThemeColorsContext on BuildContext {
  /// Semantic Figma palette for the current theme.
  AppThemeColors get appThemeColors =>
      Theme.of(this).extension<AppThemeColors>() ?? AppThemeColors.light;
}
