import '../../../../../utils/exports.dart';

/// A widget to display a global or shared app bar.
///
/// This widget is used to show an app bar at the app level, typically in the MyApp widget.
class MainAppBarWidget extends StatelessWidget {
  /// The background color of the app bar.
  final Color? backgroundColor;

  /// The title to display in the app bar.
  final String? title;

  /// Creates a main app bar widget.
  const MainAppBarWidget({super.key, this.backgroundColor, this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // This automaticallyImplyLeading flag will not show default Android-OS back button if not set at Flutter end.
      automaticallyImplyLeading: false,
      toolbarHeight: Dimens.appBarHeight,
      leadingWidth: Dimens.zero,
      elevation: Dimens.elevation0,
      titleSpacing: Dimens.zero,
      backgroundColor: backgroundColor,
      title: MainAppBarTitleWidget(
        title: title,
      ),
    );
  }
}
