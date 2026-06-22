import '../../../../utils/exports.dart';

/// A custom widget that displays a child widget within a dotted border.
///
/// This widget is used to wrap a child widget with a dotted border, allowing
/// for customization of the border's stroke width.
class CustomDottedBorderWidget<T> extends StatelessWidget {
  /// The stroke width of the dotted border.
  final double width;

  /// The child widget to display within the dotted border.
  final Widget child;

  /// Creates a custom dotted border widget.
  const CustomDottedBorderWidget({
    super.key,
    this.width = Dimens.thick1,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: AppColors.instance.lightGrayBGColor,
      strokeWidth: width,
      child: child,
    );
  }
}
