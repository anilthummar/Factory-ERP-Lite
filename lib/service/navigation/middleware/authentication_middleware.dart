import '../../../utils/exports.dart';

/// A middleware for handling authentication during navigation.
///
/// This middleware checks if the user is logged in and redirects to the dashboard if true.
class AuthenticationMiddleWare extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    bool isLogin = SharedPref.instance.getBool(SharedPref.isLoggedInKey, false);
    if (isLogin) {
      unawaited(router.pushNamed(AppPaths.dashboard));
    } else {
      resolver.next();
    }
  }
}
