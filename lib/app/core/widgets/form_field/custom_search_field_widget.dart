import '../../../../utils/exports.dart';

/// Search input with leading icon and standard list-screen padding.
class CustomSearchFieldWidget extends StatelessWidget {
  /// Creates [CustomSearchFieldWidget].
  const CustomSearchFieldWidget({
    required this.controller,
    required this.hint,
    this.onChanged,
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: CustomTextFormFieldWidget(
        controller: controller,
        hint: hint,
        isEditable: true,
        onChange: onChanged,
        prefix: const Padding(
          padding: EdgeInsets.only(
            left: Dimens.padding12,
            right: Dimens.padding8,
          ),
          child: Icon(
            Icons.search,
            size: Dimens.size25,
          ),
        ),
      ),
    );
  }
}
