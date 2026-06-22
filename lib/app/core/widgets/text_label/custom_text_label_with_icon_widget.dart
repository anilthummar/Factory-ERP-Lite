import '../../../../utils/exports.dart';

/// A widget that displays a text label with an optional icon.
///
/// This widget allows you to display a text label with an icon either
/// as a prefix or suffix. It supports customization of text style,
/// icon size, color, and alignment.
class CustomTextLabelWithIcon extends StatelessWidget {
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

  /// The SVG image to display as an icon.
  final SvgGenImage? image;

  /// The color to apply to the icon.
  final Color? imageColor;

  /// The size of the icon.
  final Size? size;

  /// Whether the icon should be displayed as a prefix.
  final bool isPrefix;

  /// Whether the icon should be displayed as a suffix.
  final bool isSuffix;

  /// The padding around the icon.
  final EdgeInsetsGeometry iconPadding;

  /// How the row's children should be aligned along the main axis.
  final MainAxisAlignment mainAxisAlignment;

  /// Creates a custom text label with an optional icon.
  ///
  /// The [label] parameter defaults to an empty string.
  ///
  /// Example:
  /// ```dart
  /// CustomTextLabelWithIcon(
  ///   label: 'Hello World',
  ///   image: Assets.icons.exampleIcon,
  ///   isPrefix: true,
  ///   style: TextStyle(fontSize: 16),
  /// )
  /// ```
  const CustomTextLabelWithIcon({
    super.key,
    this.label = "",
    this.style,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.isPrefix = false,
    this.isSuffix = false,
    this.overflow,
    this.iconPadding =
        const EdgeInsets.only(left: Dimens.padding8, right: Dimens.padding8),
    this.image,
    this.imageColor,
    this.maxLines,
    this.size = const Size(Dimens.size14, Dimens.size14),
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: <Widget>[
        Visibility(
          visible: image != null && isPrefix,
          child: Padding(
            padding: iconPadding,
            child: image?.svg(
              height: size?.height,
              width: size?.width,
              colorFilter: ColorFilter.mode(
                imageColor ?? AppColors.instance.transparent,
                BlendMode.srcATop,
              ),
            ),
          ),
        ),
        Expanded(
          flex: maxLines != null && maxLines! > 1 ? 1 : (image == null ? 1 : 0),
          child: CustomTextLabelWidget(
            label: label,
            style: style ??
                context.textTheme
                    .titleMedium
                    ?.copyWith(color: AppColors.instance.blackTextColor),
            overflow: overflow,
            maxLines: maxLines,
            textAlign: textAlign,
          ),
        ),
        Visibility(
          visible: image != null && isSuffix,
          child: Padding(
            padding: iconPadding,
            child: image?.svg(
              height: size?.height,
              width: size?.width,
              colorFilter: ColorFilter.mode(
                imageColor ?? AppColors.instance.transparent,
                BlendMode.srcATop,
              ),
            ),
          ),
        )
      ],
    );
  }
}
