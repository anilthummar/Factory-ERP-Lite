import '../../../../utils/exports.dart';

/// Horizontal divider with centered "or" label.
class LoginOrDivider extends StatelessWidget {
  /// Creates [LoginOrDivider].
  const LoginOrDivider({
    required this.label,
    super.key,
  });

  /// Divider label.
  final String label;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appThemeColors;

    return Row(
      children: <Widget>[
        Expanded(
          child: Divider(
            color: colors.divider,
            thickness: Dimens.thick1,
            height: Dimens.thick1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.padding12),
          child: CustomTextLabelWidget(
            label: label,
            style: AppStyles.instance.textTheme.labelSmall?.copyWith(
              fontSize: Dimens.fontSize12,
              fontWeight: FontWeight.w400,
              color: colors.secondaryText,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: colors.divider,
            thickness: Dimens.thick1,
            height: Dimens.thick1,
          ),
        ),
      ],
    );
  }
}
