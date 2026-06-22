import '../../../../utils/exports.dart';

/// A custom text form field widget that provides additional styling and functionality.
///
/// This widget is a wrapper around the [TextFormField] widget, offering
/// customization options for labels, icons, validation, and more.
class CustomTextFormFieldWidget extends StatelessWidget {
  /// The label to display in the text field.
  final String? label;

  /// The validator function for the form field.
  final FormFieldValidator? validator;

  /// The focus node for the text field.
  final FocusNode? focusNode;

  /// Whether the text field should autofocus when visible.
  final bool autoFocus;

  /// The controller for the text field.
  final TextEditingController? controller;

  /// The callback function for when the text changes.
  final ValueChanged<String>? onChange;

  /// The type of text input for the text field.
  final TextInputType? textInputType;

  /// A custom widget to display as a prefix.
  final Widget? prefix;

  /// An SVG image to display as a prefix icon.
  final SvgGenImage? prefixIcon;

  /// The maximum length of the text.
  final int? maxLength;

  /// The maximum number of lines for the text.
  final int? maxLines;

  /// The callback function for when the suffix is clicked.
  final Function()? suffixOnClick;

  /// The hint text for the text field.
  final String? hint;

  /// The style for the hint text.
  final TextStyle? hintStyle;

  /// The input action for the text field.
  final TextInputAction? input;

  /// Whether the text should be obscured (e.g., for passwords).
  final bool? obscureText;

  /// The size of the prefix icon.
  final Size? prefixIconSize;

  /// The size of the suffix icon.
  final Size? suffixIconSize;

  /// The box constraints for the prefix icon.
  final BoxConstraints? prefixIconConstraints;

  /// The box constraints for the suffix icon.
  final BoxConstraints? suffixIconConstraints;

  /// A custom widget to display as a suffix.
  final Widget? suffix;

  /// The input formatters for the text field.
  final List<TextInputFormatter>? inputFormatters;

  /// The style for the text in the text field.
  final TextStyle? style;

  /// An SVG image to display as a suffix icon.
  final SvgGenImage? suffixIcon;

  /// Whether the text field is editable.
  final bool? isEditable;

  /// The border color for the text field.
  final Color? borderColor;

  /// Whether the text field is validated.
  final bool isValidate;

  /// The color for the prefix icon.
  final Color? prefixIconColor;

  /// The color for the suffix icon.
  final Color? suffixIconColor;

  /// The style for error messages.
  final TextStyle? errorStyle;

  /// The style for the floating label.
  final TextStyle? floatingStyle;

  /// The callback function for when text is submitted.
  final Function(String)? onTextSubmit;

  /// The color for the cursor.
  final Color? cursorColor;

  /// The callback function for when the text field is tapped.
  final GestureTapCallback? onTap;

  /// Whether the text field is read-only.
  final bool? readOnly;

  /// Whether the hint should be aligned with the label.
  final bool alignLabelWithHint;

  /// Creates a custom text form field widget.
  const CustomTextFormFieldWidget({
    super.key,
    this.controller,
    this.focusNode,
    this.suffixIconColor,
    this.maxLength,
    this.label,
    this.errorStyle,
    this.validator,
    this.hintStyle,
    this.prefixIconColor = Colors.transparent,
    this.autoFocus = false,
    this.onChange,
    this.textInputType = TextInputType.text,
    this.prefix,
    this.readOnly = false,
    this.cursorColor,
    this.input,
    this.isEditable,
    this.onTap,
    this.prefixIcon,
    this.obscureText = false,
    this.hint,
    this.suffix,
    this.style,
    this.suffixIcon,
    this.floatingStyle,
    this.borderColor,
    this.inputFormatters,
    this.maxLines = 1,
    this.onTextSubmit,
    this.prefixIconConstraints = const BoxConstraints(
        minWidth: Dimens.size25,
        minHeight: Dimens.size25,
        maxWidth: Dimens.size50,
        maxHeight: Dimens.size50),
    this.suffixIconConstraints = const BoxConstraints(
        minWidth: Dimens.size25,
        minHeight: Dimens.size25,
        maxWidth: Dimens.size50,
        maxHeight: Dimens.size50),
    this.prefixIconSize = const Size(Dimens.size16, Dimens.size16),
    this.suffixIconSize,
    this.suffixOnClick,
    this.isValidate = false,
    bool? alignLabelWithHint,
  }) : alignLabelWithHint = alignLabelWithHint ?? true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        enableInteractiveSelection: false,
        maxLength: maxLength,
        controller: controller,
        validator: validator,
        onTap: onTap,
        keyboardType: textInputType,
        textInputAction: input,
        onChanged: onChange,
        readOnly: readOnly!,
        focusNode: focusNode,
        autofocus: autoFocus,
        onFieldSubmitted: (String submit) => onTextSubmit != null
            ? onTextSubmit?.call(submit)
            : (input == TextInputAction.next ? context.nextFocus() : null),
        inputFormatters: inputFormatters ?? (<TextInputFormatter>[]),
        maxLines: maxLines,
        enabled: isEditable,
        cursorColor: AppColors.instance.lightGrayBGColor,
        obscureText: obscureText!,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
                vertical: Dimens.padding22, horizontal: Dimens.padding10),
            alignLabelWithHint: alignLabelWithHint,
            suffixIconConstraints: suffixIconConstraints,
            prefixIconConstraints: prefixIconConstraints,
            prefix: prefix,
            labelText: label,
            hintText: hint,
            prefixIcon: Visibility(
              visible: prefixIcon != null,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: Dimens.padding14, right: Dimens.padding8),
                child: prefixIcon?.svg(
                  height: prefixIconSize?.height,
                  width: prefixIconSize?.width,
                  colorFilter: ColorFilter.mode(
                    prefixIconColor ?? AppColors.instance.transparent,
                    BlendMode.srcATop,
                  ),
                ),
              ),
            ),
            suffix: suffix,
            suffixIcon: Visibility(
              visible: suffixIcon != null,
              child: GestureDetector(
                onTap: suffixOnClick,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: Dimens.padding14,
                    left: Dimens.padding8,
                  ),
                  child: suffixIcon?.svg(
                    height: suffixIconSize?.height,
                    width: suffixIconSize?.width,
                    colorFilter: ColorFilter.mode(
                      suffixIconColor ?? AppColors.instance.transparent,
                      BlendMode.srcATop,
                    ),
                  ),
                ),
              ),
            )));
  }
}
