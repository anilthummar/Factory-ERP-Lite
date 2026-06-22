import '../../../../../utils/exports.dart';

/// A widget that displays a shimmer effect for loading content.
///
/// This widget is used to show a shimmer effect while the content is loading.
class CustomShimmerListWidget extends StatelessWidget {
  /// The child widget to be displayed.
  final Widget child;

  /// The constructor for [CustomShimmerListWidget].
  const CustomShimmerListWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: child,
    );
  }
}
