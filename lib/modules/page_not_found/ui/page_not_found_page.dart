import '../../../../utils/exports.dart';

/// A page that displays a 'Page Not Found' message.
///
/// This page is shown when a user navigates to a non-existent route.
@RoutePage()
class PageNotFound extends BaseResponsiveView {
  /// The constructor for [PageNotFound].
  const PageNotFound({super.key});

  /// Builds the view for the 'Page Not Found' page.
  ///
  /// [context] is the build context.
  Widget _buildViews(BuildContext context) {
    return Center(
        child: CustomTextLabelWidget(label: context.appString.pageNotFoundKey));
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
