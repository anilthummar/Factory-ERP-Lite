import '../../../../utils/exports.dart';

/// Outlined email field matching the Figma login design.
class LoginEmailTextField extends StatelessWidget {
  /// Creates [LoginEmailTextField].
  const LoginEmailTextField({
    required this.controller,
    required this.hintText,
    super.key,
  });

  /// Email input controller.
  final TextEditingController controller;

  /// Placeholder text.
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appThemeColors;

    return SizedBox(
      height: Dimens.space48,
      child: CustomTextFormFieldWidget(
        controller: controller,
        hint: hintText,
        textInputType: TextInputType.emailAddress,
        input: TextInputAction.done,
        isEditable: true,
        style: AppStyles.instance.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w400,
          color: colors.primaryText,
        ),
        hintStyle: AppStyles.instance.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w400,
          color: colors.secondaryText,
        ),
        borderColor: colors.border,
      ),
    );
  }
}
