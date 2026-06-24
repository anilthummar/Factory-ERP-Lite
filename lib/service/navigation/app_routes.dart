import '../../utils/exports.dart';

/// A router configuration class for managing application routes.
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => <AutoRoute>[
        CustomRoute<void>(
          page: ForceUpdateUnderMaintenanceRoute.page,
          path: AppPaths.maintenance,
          opaque: false,
          fullscreenDialog: true,
          reverseDurationInMilliseconds: 0,
          transitionsBuilder: TransitionsBuilders.noTransition,
          durationInMilliseconds: 0,
        ),
        AutoRoute(
          path: AppPaths.splash,
          page: SplashRoute.page,
          guards: <AutoRouteGuard>[MaintenanceMiddleware()],
          initial: true,
        ),
        CustomRoute<void>(
          page: LoginRoute.page,
          maintainState: false,
          guards: <AutoRouteGuard>[AuthenticationMiddleWare()],
          path: AppPaths.login,
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute<void>(
          page: MainNavigationRoute.page,
          path: AppPaths.dashboard,
          guards: <AutoRouteGuard>[AuthGuard()],
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute<void>(
          page: PersonRoute.page,
          path: AppPaths.personManagement,
          guards: <AutoRouteGuard>[AuthGuard()],
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute<void>(
          page: LaborRoute.page,
          path: AppPaths.laborManagement,
          guards: <AutoRouteGuard>[AuthGuard()],
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute<void>(
          page: MaterialPurchaseRoute.page,
          path: AppPaths.materialPurchases,
          guards: <AutoRouteGuard>[AuthGuard()],
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute<void>(
          page: TruckExpensesRoute.page,
          path: AppPaths.truckExpenses,
          guards: <AutoRouteGuard>[AuthGuard()],
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute<void>(
          page: MaintenanceExpensesRoute.page,
          path: AppPaths.maintenanceExpenses,
          guards: <AutoRouteGuard>[AuthGuard()],
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute<void>(
          page: ElectricityExpensesRoute.page,
          path: AppPaths.electricityExpenses,
          guards: <AutoRouteGuard>[AuthGuard()],
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute<void>(
          page: MiscellaneousExpensesRoute.page,
          path: AppPaths.miscellaneousExpenses,
          guards: <AutoRouteGuard>[AuthGuard()],
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute<void>(
          page: RecurringExpensesRoute.page,
          path: AppPaths.recurringExpenses,
          guards: <AutoRouteGuard>[AuthGuard()],
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute<void>(path: '*', page: RouteNotFound.page),
      ];
}
