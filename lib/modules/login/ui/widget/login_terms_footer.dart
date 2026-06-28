import '../../../../utils/exports.dart';

/// Terms of service and privacy policy footer.
class LoginTermsFooter extends StatelessWidget {
  /// Creates [LoginTermsFooter].
  const LoginTermsFooter({
    required this.prefix,
    required this.termsLabel,
    required this.andLabel,
    required this.privacyLabel,
    this.onTermsPressed,
    this.onPrivacyPressed,
    super.key,
  });

  /// Text before the first link.
  final String prefix;

  /// Terms of service link label.
  final String termsLabel;

  /// Text between links.
  final String andLabel;

  /// Privacy policy link label.
  final String privacyLabel;

  /// Terms link tap callback.
  final VoidCallback? onTermsPressed;

  /// Privacy link tap callback.
  final VoidCallback? onPrivacyPressed;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appThemeColors;
    final TextStyle baseStyle = AppStyles.instance.textTheme.labelSmall!.copyWith(
      fontSize: Dimens.fontSize12,
      fontWeight: FontWeight.w400,
      color: colors.termsText,
      height: 1.5,
    );
    final TextStyle linkStyle = baseStyle.copyWith(
      fontWeight: FontWeight.w700,
      color: colors.linkText,
    );

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        CustomTextLabelWidget(
          label: prefix,
          style: baseStyle,
        ),
        GestureDetector(
          onTap: onTermsPressed,
          child: CustomTextLabelWidget(
            label: termsLabel,
            style: linkStyle,
          ),
        ),
        CustomTextLabelWidget(
          label: andLabel,
          style: baseStyle,
        ),
        GestureDetector(
          onTap: onPrivacyPressed,
          child: CustomTextLabelWidget(
            label: privacyLabel,
            style: linkStyle,
          ),
        ),
      ],
    );
  }
}
