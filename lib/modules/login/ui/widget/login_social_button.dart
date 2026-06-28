import '../../../../utils/exports.dart';

/// Light grey social sign-in button with leading icon.
class LoginSocialButton extends StatelessWidget {
  /// Creates [LoginSocialButton].
  const LoginSocialButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  /// Button label.
  final String label;

  /// SVG icon for the leading asset.
  final SvgGenImage icon;

  /// Tap callback.
  final VoidCallback? onPressed;

  /// Shows a loading indicator when true.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appThemeColors;

    return SizedBox(
      width: double.infinity,
      height: Dimens.space48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.socialSurface,
          foregroundColor: colors.primaryText,
          disabledBackgroundColor: colors.socialSurface,
          disabledForegroundColor: colors.primaryText.withValues(alpha: 0.4),
          elevation: Dimens.elevation0,
          padding: const EdgeInsets.symmetric(horizontal: Dimens.padding16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.radius8),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: Dimens.size18,
                height: Dimens.size18,
                child: CircularProgressIndicator(
                  strokeWidth: Dimens.thick1,
                  color: colors.primaryText,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  icon.svg(
                    width: Dimens.size18,
                    height: Dimens.size18,
                  ),
                  const SizedBox(width: Dimens.space12),
                  CustomTextLabelWidget(
                    label: label,
                    style: AppStyles.instance.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colors.primaryText,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
