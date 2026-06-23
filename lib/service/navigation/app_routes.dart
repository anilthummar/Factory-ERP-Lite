import '../../utils/exports.dart';

/// A router configuration class for managing application routes.
///
/// This class defines the routes and their configurations for the application.
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => <AutoRoute>[
    /// routes go here
    CustomRoute<void>(
      page: ForceUpdateUnderMaintenanceRoute.page,
      path: AppPaths.maintenance,
      opaque: false,
      fullscreenDialog: true,
      reverseDurationInMilliseconds: 0,
      transitionsBuilder: TransitionsBuilders.noTransition,
      durationInMilliseconds: 0,
    ),
    CustomRoute<void>(
      page: LoginRoute.page,
      maintainState: false,
      guards: <AutoRouteGuard>[AuthenticationMiddleWare()],
      path: AppPaths.login,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute<void>(
      page: DashboardRoute.page,
      path: AppPaths.dashboard,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      children: <AutoRoute>[
        AutoRoute(
          page: TabOne.page,
          path: AppPaths.nestedTabView,
          children: <AutoRoute>[
            AutoRoute(page: TabOneRoute.page, path: AppPaths.tabOne),
            CustomRoute<void>(
              page: TabOneDetailRoute.page,
              path: AppPaths.tabOneDetail,
              maintainState: false,
              durationInMilliseconds: 0,
              reverseDurationInMilliseconds: 0,
            ),
          ],
        ),
        AutoRoute(
          page: TabTwoRoute.page,
          path: AppPaths.tabTwo,
          maintainState: false,
        ),
        AutoRoute(
          page: CustomPaginationRoute.page,
          path: AppPaths.customPagination,
          maintainState: false,
        ),
      ],
    ),
    AutoRoute(path: AppPaths.tabTwoDetail, page: TabTwoDetailRoute.page),
    AutoRoute(
      path: AppPaths.splash,
      page: SplashRoute.page,
      guards: <AutoRouteGuard>[MaintenanceMiddleware()],
      initial: true,
    ),
    CustomRoute<void>(path: '*', page: RouteNotFound.page),
  ];
}

/// A route page for Tab One.
@RoutePage(name: 'TabOne')
class BottomBarTabOnePage extends AutoRouter {
  /// Creates a bottom bar tab one page.
  const BottomBarTabOnePage({super.key});
}
