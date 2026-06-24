import '../../../../utils/exports.dart';

/// Primary black continue button on the login screen.
class LoginContinueButton extends StatelessWidget {
  /// Creates [LoginContinueButton].
  const LoginContinueButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  /// Button label.
  final String label;

  /// Tap callback.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appThemeColors;

    return SizedBox(
      height: Dimens.space48,
      child: CustomButtonWidget(
        text: label,
        isDisable: onPressed == null,
        backgroundColor: colors.primaryButton,
        onClick: onPressed,
        textStyle: AppStyles.instance.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: colors.onPrimaryButton,
        ),
      ),
    );
  }
}
