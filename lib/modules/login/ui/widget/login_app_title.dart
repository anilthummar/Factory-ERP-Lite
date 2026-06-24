import '../../../../utils/exports.dart';

/// Large app name title on the login screen.
class LoginAppTitle extends StatelessWidget {
  /// Creates [LoginAppTitle].
  const LoginAppTitle({
    required this.title,
    super.key,
  });

  /// App name text.
  final String title;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appThemeColors;

    return CustomTextLabelWidget(
      label: title,
      textAlign: TextAlign.start,
      style: AppStyles.instance.textTheme.titleLarge?.copyWith(
        fontSize: Dimens.space32,
        fontWeight: FontWeight.w700,
        color: colors.primaryText,
        height: 1.2,
        letterSpacing: -0.5,
      ),
    );
  }
}
