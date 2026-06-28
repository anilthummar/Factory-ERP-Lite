import '../../../../utils/exports.dart';

/// Section heading and subtitle on the login screen.
class LoginHeaderSection extends StatelessWidget {
  /// Creates [LoginHeaderSection].
  const LoginHeaderSection({
    required this.title,
    required this.subtitle,
    super.key,
  });

  /// Section title.
  final String title;

  /// Section subtitle.
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appThemeColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomTextLabelWidget(
          label: title,
          textAlign: TextAlign.start,
          style: AppStyles.instance.textTheme.headlineSmall?.copyWith(
            color: colors.primaryText,
            height: 1.25,
          ),
        ),
        const SizedBox(height: Dimens.space8),
        CustomTextLabelWidget(
          label: subtitle,
          textAlign: TextAlign.start,
          style: AppStyles.instance.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w400,
            color: colors.secondaryText,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
