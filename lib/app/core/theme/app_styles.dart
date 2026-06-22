import '../../../utils/exports.dart';

/// A class that defines the text styles used throughout the application.
///
/// This class provides a set of predefined text styles for different text elements
/// in the application, such as headlines, titles, and body text.
class AppStyles {
  /// The instance of the [AppStyles].
  static AppStyles instance = getIt<AppStyles>();
  //-----------------------------Light------------------------

  /// Light style with font size 96
  final TextStyle _displayLarge = _textStyle.copyWith(
      fontSize: Dimens.fontSize96, fontWeight: FontWeight.w300);

  /// Extra-light style with font size 60
  final TextStyle _displayMedium = _textStyle.copyWith(
      fontSize: Dimens.fontSize60, fontWeight: FontWeight.w200);

  /// Thin style with font size 48
  final TextStyle _displaySmall = _textStyle.copyWith(
      fontSize: Dimens.fontSize48, fontWeight: FontWeight.w100);

  //------------------------------Semi-Bold--------------------

  /// Semi-bold style with font size 18
  final TextStyle _headlineMedium = _textStyle.copyWith(
      fontSize: Dimens.fontSize18, fontWeight: FontWeight.w600);

  /// Semi-bold style with font size 16
  final TextStyle _headlineSmall = _textStyle.copyWith(
      fontSize: Dimens.fontSize16, fontWeight: FontWeight.w600);

  //-----------------------Title------------------------------

  /// Bold style with font size 18
  final TextStyle _titleSmall = _textStyle.copyWith(
      fontSize: Dimens.fontSize18, fontWeight: FontWeight.w700);

  /// Semi-bold style with font size 20
  final TextStyle _titleMedium = _textStyle.copyWith(
      fontSize: Dimens.fontSize20, fontWeight: FontWeight.w600);

  /// Bold style with font size 24
  final TextStyle _titleLarge = _textStyle.copyWith(
    fontSize: Dimens.fontSize24,
    fontWeight: FontWeight.w700,
  );

  //---------------------------body--------------------------
  /// Regular style with font size 16 and light color
  final TextStyle _bodySmall = _textStyle.copyWith(
      fontSize: Dimens.fontSize16,
      color: AppColors.instance.lightGrayTextColor);

  /// Medium style with font size 16
  final TextStyle _bodyMedium = _textStyle.copyWith(
      fontSize: Dimens.fontSize16, fontWeight: FontWeight.w500);

  /// Regular style with font size 16
  final TextStyle _bodyLarge = _textStyle.copyWith(
    fontSize: Dimens.fontSize16,
  );

  //---------------------------Medium--------------------------
  /// Regular style with font size 16 and black color
  final TextStyle _labelLarge = _textStyle.copyWith(
      fontSize: Dimens.fontSize16, color: AppColors.instance.blackTextColor);

  /// Medium style with font size 16 and black color
  final TextStyle _labelMedium = _textStyle.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: Dimens.fontSize16,
      color: AppColors.instance.blackTextColor);

  /// Regular style with font size 14 and medium gray color
  final TextStyle _labelSmall = _textStyle.copyWith(
      fontSize: Dimens.fontSize14,
      color: AppColors.instance.mediumGrayTextColor);

  /// Regular style with font size 14 and black color
  static final TextStyle _textStyle = GoogleFonts.roboto(
    fontWeight: FontWeight.w400,
    color: AppColors.instance.blackTextColor,
    fontSize: Dimens.fontSize14,
  );

  /// Style for error messages
  TextStyle get errorStyle => _bodyMedium.copyWith(
        color: AppColors.instance.redTextColor,
      );

  /// Style for hint text
  TextStyle get hintStyle => _textStyle.copyWith(
        color: AppColors.instance.lightGrayTextColor,
      );

  /// Returns the text theme for the application
  TextTheme get textTheme => TextTheme(
        bodyLarge: _bodyLarge,
        bodyMedium: _bodyMedium,
        bodySmall: _bodySmall,
        displayLarge: _displayLarge,
        displayMedium: _displayMedium,
        displaySmall: _displaySmall,
        headlineMedium: _headlineMedium,
        headlineSmall: _headlineSmall,
        titleLarge: _titleLarge,
        titleMedium: _titleMedium,
        titleSmall: _titleSmall,
        labelLarge: _labelLarge,
        labelMedium: _labelMedium,
        labelSmall: _labelSmall,
      );
}
