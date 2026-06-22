import '../../../utils/exports.dart';

/// A custom divider widget that can be used to separate content.
///
/// This widget provides a customizable divider with options for height,
/// color, width, and child alignment.
class CustomDivider extends StatelessWidget {
  /// The height of the divider.
  final double? height;

  /// The color of the divider.
  final Color? color;

  /// The width of the divider.
  final double? width;

  /// An optional child widget to display within the divider.
  final Widget? child;

  /// The alignment of the child widget within the divider.
  final AlignmentGeometry? alignment;

  /// The decoration to apply to the divider.
  final Decoration? decoration;

  /// Creates a custom divider widget.
  const CustomDivider({
    super.key,
    this.height,
    this.color,
    this.width,
    this.child,
    this.decoration,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      height: height,
      color: color,
      width: width,
      decoration: decoration,
      child: child,
    );
  }
}
