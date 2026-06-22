import '../../../../utils/exports.dart';

/// A custom text form field widget with a label.
///
/// This widget combines a text label with a text form field, providing
/// additional customization options for labels, icons, and validation.
class CustomTextFormFieldWithLabelWidget extends StatelessWidget {
  /// The title to display above the text form field.
  final String title;

  /// The style to use for the title text.
  final TextStyle? style;

  /// How visual overflow should be handled for the title text.
  final TextOverflow? overflow;

  /// How the title text should be aligned horizontally.
  final TextAlign? textAlign;

  /// The label to display in the text field.
  final String? label;

  /// The hint text for the text field.
  final String? hint;

  /// The controller for the text field.
  final TextEditingController controller;

  /// An SVG image to display as a suffix icon.
  final SvgGenImage? suffixIcon;

  /// An SVG image to display as a prefix icon.
  final SvgGenImage? prefixIcon;

  /// The maximum number of lines for the text.
  final int? maxLines;

  /// The callback function for when the suffix is clicked.
  final Function()? suffixOnClick;

  /// The color for the prefix icon.
  final Color? prefixIconColor;

  /// The color for the suffix icon.
  final Color? suffixIconColor;

  /// Whether the text field is read-only.
  final bool? readOnly;

  /// The box constraints for the prefix icon.
  final BoxConstraints? prefixIconConstraints;

  /// The box constraints for the suffix icon.
  final BoxConstraints? suffixIconConstraints;

  /// The validator function for the form field.
  final FormFieldValidator? validator;

  /// The callback function for when the text changes.
  final ValueChanged<String>? onChange;

  /// The callback function for when text is submitted.
  final Function(String)? onTextSubmit;

  /// Creates a custom text form field widget with a label.
  const CustomTextFormFieldWithLabelWidget({
    super.key,
    required this.title,
    required this.controller,
    this.label,
    this.style,
    this.hint,
    this.overflow,
    this.maxLines = 1,
    this.onTextSubmit,
    this.textAlign,
    this.suffixIcon,
    this.prefixIcon,
    this.suffixOnClick,
    this.prefixIconColor,
    this.suffixIconColor,
    this.readOnly = false,
    this.prefixIconConstraints,
    this.suffixIconConstraints,
    this.validator,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomTextLabelWidget(
          label: title,
          style: style ?? context.textTheme.labelSmall,
          overflow: overflow,
          maxLines: maxLines,
          textAlign: textAlign,
        ),
        const SizedBox(
          height: Dimens.space10,
        ),
        CustomTextFormFieldWidget(
          label: label ?? "",
          hint: hint,
          controller: controller,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          suffixOnClick: suffixOnClick,
          maxLines: maxLines,
          prefixIconColor: prefixIconColor,
          suffixIconColor: suffixIconColor,
          readOnly: readOnly,
          prefixIconConstraints: prefixIconConstraints,
          suffixIconConstraints: suffixIconConstraints,
          onChange: onChange,
          onTextSubmit: onTextSubmit,
          validator: validator,
        ),
      ],
    );
  }
}
