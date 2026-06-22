import '../../../../utils/exports.dart';

/// A widget that applies a shimmer effect to its child.
///
/// This widget is used to display a loading shimmer effect over a child widget.
class ShimmerEffect extends StatelessWidget {
  /// The child widget to apply the shimmer effect to.
  final Widget child;

  /// Creates a shimmer effect widget.
  const ShimmerEffect({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: AppColors.instance.lightGrayBGColor,
        highlightColor: AppColors.instance.extraLightGreyBGColor,
        child: child);
  }
}
