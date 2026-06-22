import '../utils/exports.dart';

/// An abstract class for creating responsive views.
///
/// This class provides methods for building different widgets based on the device type,
/// such as mobile, tablet, or desktop.
abstract class BaseResponsiveView extends StatelessWidget {
  /// Creates a base responsive view.
  const BaseResponsiveView({super.key});

  /// Builds the widget for mobile devices.
  Widget buildMobileWidget(BuildContext context);

  /// Builds the widget for tablet devices.
  Widget buildTabletWidget(BuildContext context);

  /// Builds the widget for desktop devices.
  Widget buildDesktopWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        if (context.isMobileView) {
          return buildMobileWidget(context);
        } else if (context.isTabletView) {
          return buildTabletWidget(context);
        } else if (context.isWebView) {
          return buildDesktopWidget(context);
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}
