import '../../../../utils/exports.dart';

/// A widget that displays a text label with an underline.
///
/// This widget allows you to display a text label with an underline,
/// which can be customized in terms of color and thickness. It also
/// supports a tap gesture.
class CustomUnderlineTextWidget extends StatelessWidget {
  /// The text label to display.
  final String title;

  /// The callback function to execute when the text is tapped.
  final Function onTap;

  /// The style to use for the text label.
  final TextStyle? titleTextStyle;

  /// The default color of the text.
  final Color? textDefaultColor;

  /// The color of the underline.
  final Color? underlineColor;

  /// The thickness of the underline.
  final double? underLineThickness;

  /// The width of the widget.
  final double? width;

  /// Creates a custom underline text widget.
  ///
  /// The [title] and [onTap] parameters are required.
  ///
  /// Example:
  /// ```dart
  /// CustomUnderlineTextWidget(
  ///   title: 'Click Me',
  ///   onTap: () => print('Text tapped!'),
  ///   underlineColor: Colors.blue,
  ///   underLineThickness: 2.0,
  /// )
  /// ```
  const CustomUnderlineTextWidget({
    super.key,
    required this.title,
    required this.onTap,
    this.titleTextStyle,
    this.textDefaultColor,
    this.underlineColor,
    this.underLineThickness = Dimens.thick205,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap as void Function()?,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        alignment: Alignment.center,
      ).copyWith(
          overlayColor: WidgetStateProperty.all(
        Colors.transparent,
      )),
      child: CustomTextLabelWidget(
        label: title,
        style: titleTextStyle ??
            context.textTheme.bodyMedium?.copyWith(
                  decoration: TextDecoration.underline,
                  decorationThickness: underLineThickness,
                  decorationColor:
                      underlineColor ?? AppColors.instance.mediumGrayBGColor,
                ),
      ),
    );
  }
}
