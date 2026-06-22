import '../../../../utils/exports.dart';

/// A custom widget to display a text label with optional styling.
///
/// This widget provides options for text style, overflow handling, maximum lines, and text alignment.
class CustomTextLabelWidget extends StatelessWidget {
  /// The text label to display.
  final String label;

  /// The style to use for the text label.
  final TextStyle? style;

  /// How visual overflow should be handled.
  final TextOverflow? overflow;

  /// The maximum number of lines for the text label.
  final int? maxLines;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// Creates a custom text label widget.
  const CustomTextLabelWidget({
    super.key,
    this.label = "",
    this.style,
    this.overflow,
    this.maxLines,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: style ?? context.textTheme.bodyMedium,
      overflow: overflow,
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}
