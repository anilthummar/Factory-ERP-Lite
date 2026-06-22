import '../../utils/exports.dart';

/// A custom navigation observer for monitoring route changes.
///
/// This observer logs route changes and tab route visits for debugging purposes.
class CustomNavigationObserver extends AutoRouterObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    DebugLog.instance.d('New route pushed: \\${route.settings.name}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    DebugLog.instance.d('did replace :\\${newRoute?.settings.name}');
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    DebugLog.instance.d('did pop :\\${route.settings.name}');
    super.didPop(route, previousRoute);
  }

  // only override to observer tab routes
  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    DebugLog.instance.d('Tab route visited: \\${route.name}');
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    DebugLog.instance.d('Tab route re-visited: \\${route.name}');
  }
}
