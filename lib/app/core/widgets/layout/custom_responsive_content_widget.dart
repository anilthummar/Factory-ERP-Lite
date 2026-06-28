import '../../../../utils/exports.dart';

/// Centers content and constrains max width on tablet/desktop.
class CustomResponsiveContent extends StatelessWidget {
  /// Creates [CustomResponsiveContent].
  const CustomResponsiveContent({
    required this.child,
    this.tabletMaxWidth = Dimens.space400,
    this.webMaxWidth = Dimens.space400,
    super.key,
  });

  /// Child content.
  final Widget child;

  /// Max width on tablet layouts.
  final double tabletMaxWidth;

  /// Max width on desktop/web layouts.
  final double webMaxWidth;

  @override
  Widget build(BuildContext context) {
    double maxWidth = double.infinity;
    if (context.isTabletView) {
      maxWidth = tabletMaxWidth;
    } else if (context.isWebView) {
      maxWidth = webMaxWidth;
    }

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
