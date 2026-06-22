import '../../../utils/exports.dart';

/// A middleware for handling maintenance mode during navigation.
///
/// This middleware checks if the application is in maintenance mode and redirects accordingly.
class MaintenanceMiddleware extends AutoRouteGuard {
  @override
  Future<void> onNavigation(
      NavigationResolver resolver, StackRouter router) async {
   final ForceUpdateUnderMaintenanceBloc forceUpdate =
        getIt<ForceUpdateUnderMaintenanceBloc>();
   final UpdateMaintenanceType type = forceUpdate
        .getUpdateOrMaintenanceType(await forceUpdate.readRemoteConfig());
    if (type == UpdateMaintenanceType.none) {
      resolver.next();
    } else {
      unawaited(router.pushNamed(AppPaths.maintenance));
    }
  }
}
