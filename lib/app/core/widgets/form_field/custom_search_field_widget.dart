import '../../../../utils/exports.dart';

/// Search input with leading icon and standard list-screen padding.
class CustomSearchFieldWidget extends StatelessWidget {
  /// Creates [CustomSearchFieldWidget].
  const CustomSearchFieldWidget({
    required this.controller,
    required this.hint,
    this.onChanged,
    this.compact = true,
    this.padding = const EdgeInsets.fromLTRB(
      Dimens.padding16,
      Dimens.padding8,
      Dimens.padding16,
      Dimens.padding12,
    ),
    super.key,
  });

  /// Search text controller.
  final TextEditingController controller;

  /// Hint text.
  final String hint;

  /// Text change callback.
  final ValueChanged<String>? onChanged;

  /// Outer padding around the field.
  final EdgeInsetsGeometry padding;

  /// Uses a shorter field height when true (list screens).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final double maxWidth = width < 600 ? width - 32 : 560;

    return Padding(
      padding: padding,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: CustomTextFormFieldWidget(
            controller: controller,
            hint: hint,
            isEditable: true,
            onChange: onChanged,
            contentPadding: compact
                ? const EdgeInsets.symmetric(
                    horizontal: Dimens.padding12,
                    vertical: Dimens.padding12,
                  )
                : null,
            prefix: const Padding(
              padding: EdgeInsets.only(
                left: Dimens.padding12,
                right: Dimens.padding8,
              ),
              child: Icon(
                Icons.search,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
