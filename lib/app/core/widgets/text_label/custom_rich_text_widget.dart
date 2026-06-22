import '../../../../utils/exports.dart';

/// A custom rich text widget that allows displaying a combination of
/// primary, optional strikethrough, and secondary labels with independent
/// styles and optional tap callbacks.
class CustomRichTextLabel extends StatelessWidget {
  /// The primary text to be displayed.
  final String primaryLabel;

  /// Optional strikethrough label shown immediately after the primary label.
  final String? strikeLabel;

  /// The secondary text to be displayed after the primary (and optional strike) label.
  final String secondaryLabel;

  /// Optional style for the primary label.
  final TextStyle? primaryStyle;

  /// Optional style for the strikethrough label.
  final TextStyle? strikeLabelStyle;

  /// Optional style for the secondary label.
  final TextStyle? secondaryStyle;

  /// Callback triggered when the primary label is tapped.
  final VoidCallback? onTapPrimaryLabel;

  /// Callback triggered when the secondary label is tapped.
  final VoidCallback? onTapSecondaryLabel;

  /// Maximum number of lines for the rich text.
  final int maxLines;

  /// Whether to include spacing between the strike and secondary label.
  final bool? isSpaceNeeded;

  /// Creates a [CustomRichTextLabel] widget.
  const CustomRichTextLabel({
    super.key,
    this.maxLines = 2,
    this.primaryLabel = "",
    this.secondaryLabel = "",
    this.primaryStyle,
    this.onTapPrimaryLabel,
    this.onTapSecondaryLabel,
    this.secondaryStyle,
    this.isSpaceNeeded,
    this.strikeLabel,
    this.strikeLabelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        // Primary text span with tap gesture
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            onTapPrimaryLabel?.call();
          },
        text: primaryLabel,
        style: primaryStyle ??
            context.textTheme.titleMedium?.copyWith(
                color: AppColors.instance.whiteTextColor),
        children: <InlineSpan>[
          // Optional strikethrough label
          if (strikeLabel != null)
            TextSpan(text: strikeLabel, style: strikeLabelStyle),

          // Optional spacing between labels
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: SizedBox(
              height: Dimens.size16,
              width: (isSpaceNeeded ?? true) ? Dimens.padding4 : 0,
            ),
          ),

          // Secondary label with tap gesture
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                onTapSecondaryLabel?.call();
              },
            text: secondaryLabel,
            style: secondaryStyle ??
                context.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
