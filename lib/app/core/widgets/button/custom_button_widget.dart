import '../../../../utils/exports.dart';

/// A custom button widget that provides additional styling options.
///
/// This widget is a wrapper around the [ElevatedButton] widget, allowing
/// for customization of background color, text style, and click behavior.
class CustomButtonWidget extends StatelessWidget {
  /// The background color of the button.
  final Color backgroundColor;

  /// The style to use for the button's text.
  final TextStyle? textStyle;

  /// The text to display on the button.
  final String text;

  /// The callback function to execute when the button is clicked.
  final Function()? onClick;

  /// An optional key for the button.
  final Key? key1;

  /// The width of the button.
  final double? width;

  /// Whether the button is disabled.
  final bool isDisable;

  /// Creates a custom button widget.
  ///
  /// The [backgroundColor]
  CustomButtonWidget({
    Color? backgroundColor,
    this.width = double.infinity,
    this.text = "",
    this.isDisable = false,
    this.onClick,
    this.key1,
    this.textStyle,
  })  : backgroundColor = backgroundColor ?? AppColors.instance.orangeBGColor,
        super(key: key1);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(vertical: Dimens.padding8)),
        backgroundColor: WidgetStateProperty.all<Color>(
            isDisable ? AppColors.instance.lightGrayBGColor : backgroundColor),
      ),
      onPressed: isDisable
          ? null
          : () {
              context.hideKeyboard();
              onClick?.call();
            },
      child: CustomTextLabelWidget(
        label: text,
        style: textStyle ??
            context.textTheme
                .headlineMedium
                ?.copyWith(color: AppColors.instance.whiteTextColor),
      ),
    );
  }
}
