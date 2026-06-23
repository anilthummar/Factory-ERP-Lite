import '../../../utils/exports.dart';

/// Redirects unauthenticated users to the login screen.
class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (getIt<AuthRepository>().isLoggedIn) {
      resolver.next();
    } else {
      unawaited(router.replaceNamed(AppPaths.login));
    }
  }
}
