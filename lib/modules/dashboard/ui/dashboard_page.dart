import '../../../../utils/exports.dart';

/// A page that displays the dashboard with tabs.
///
/// This page uses [AutoTabsRouter] to manage tab navigation and displays
/// a [BottomNavigationBar] for switching between tabs.
@RoutePage()
class DashboardPage extends BaseResponsiveView {
  /// The constructor for [DashboardPage].
  const DashboardPage({super.key});

  /// Builds the view for the dashboard page.
  ///
  /// [context] is the build context.
  Widget _buildView(BuildContext context) {
    return AutoTabsRouter(
      builder: (BuildContext context, Widget child) {
        final TabsRouter tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.book_outlined,
                  color: AppColors.instance.orangeBGColor,
                ),
                activeIcon: Icon(
                  Icons.book,
                  color: AppColors.instance.orangeBGColor,
                ),
                label: context.appString.tab1Key,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.book_outlined,
                  color: AppColors.instance.orangeBGColor,
                ),
                activeIcon:
                    Icon(Icons.book, color: AppColors.instance.orangeBGColor),
                label: context.appString.tab2Key,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.pageview_outlined,
                  color: AppColors.instance.orangeBGColor,
                ),
                activeIcon: Icon(Icons.pageview,
                    color: AppColors.instance.orangeBGColor),
                label: context.appString.tab3Key,
              )
            ],
            currentIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
          ),
        );
      },
    );
  }

  @override
  Widget buildDesktopWidget(BuildContext context) {
    return _buildView(context);
  }

  @override
  Widget buildMobileWidget(BuildContext context) {
    return _buildView(context);
  }

  @override
  Widget buildTabletWidget(BuildContext context) {
    return _buildView(context);
  }
}
