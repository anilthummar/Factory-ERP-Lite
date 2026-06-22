import '../../../../utils/exports.dart';

/// A widget for displaying the details of Tab Two.
///
/// This widget provides a responsive view for mobile, tablet, and desktop layouts.
class TabTwoDetailWidget extends BaseResponsiveView {
  /// Creates a tab two detail widget.
  const TabTwoDetailWidget({super.key});

  /// Builds the views for the widget.
  Widget _buildViews(BuildContext context) {
    return GestureDetector(
        onTap: () {
          unawaited(context.router.maybePop());
        },
        child: Center(
            child: CustomTextLabelWidget(
                label: context.appString.clickHereToGoBackKey)));
  }

  @override
  Widget buildDesktopWidget(BuildContext context) {
    return _buildViews(context);
  }

  @override
  Widget buildMobileWidget(BuildContext context) {
    return _buildViews(context);
  }

  @override
  Widget buildTabletWidget(BuildContext context) {
    return _buildViews(context);
  }
}
