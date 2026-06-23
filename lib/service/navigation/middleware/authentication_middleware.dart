import '../../../utils/exports.dart';

/// Redirects authenticated users away from the login screen.
class AuthenticationMiddleWare extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (getIt<AuthRepository>().isLoggedIn) {
      unawaited(router.replaceNamed(AppPaths.dashboard));
    } else {
      resolver.next();
    }
  }
}
