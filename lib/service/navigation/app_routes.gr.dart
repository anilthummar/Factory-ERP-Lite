// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i12;
import 'package:flutter_base/modules/custom_pagination/ui/widget/custom_pagination_page.dart'
    as _i2;
import 'package:flutter_base/modules/dashboard/ui/dashboard_page.dart' as _i3;
import 'package:flutter_base/modules/force_update_under_maintenance/ui/force_update_under_maintenance_page.dart'
    as _i4;
import 'package:flutter_base/modules/login/ui/login_page.dart' as _i5;
import 'package:flutter_base/modules/page_not_found/ui/page_not_found_page.dart'
    as _i6;
import 'package:flutter_base/modules/splash/ui/splash_page.dart' as _i7;
import 'package:flutter_base/modules/tab_one/ui/tab_one_page.dart' as _i9;
import 'package:flutter_base/modules/tab_one_detail/ui/tab_one_detail_page.dart'
    as _i8;
import 'package:flutter_base/modules/tab_two/ui/tab_two_page.dart' as _i11;
import 'package:flutter_base/modules/tab_two_detail/ui/tab_two_detail_page.dart'
    as _i10;
import 'package:flutter_base/service/navigation/app_routes.dart' as _i1;

abstract class $AppRouter extends _i12.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i12.PageFactory> pagesMap = {
    TabOne.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.BottomBarTabOnePage(),
      );
    },
    CustomPaginationRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.CustomPaginationPage(),
      );
    },
    DashboardRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.DashboardPage(),
      );
    },
    ForceUpdateUnderMaintenanceRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.ForceUpdateUnderMaintenancePage(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.LoginPage(),
      );
    },
    RouteNotFound.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.PageNotFound(),
      );
    },
    SplashRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.SplashPage(),
      );
    },
    TabOneDetailRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.TabOneDetailPage(),
      );
    },
    TabOneRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.TabOnePage(),
      );
    },
    TabTwoDetailRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.TabTwoDetailPage(),
      );
    },
    TabTwoRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.TabTwoPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.BottomBarTabOnePage]
class TabOne extends _i12.PageRouteInfo<void> {
  const TabOne({List<_i12.PageRouteInfo>? children})
      : super(
          TabOne.name,
          initialChildren: children,
        );

  static const String name = 'TabOne';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i2.CustomPaginationPage]
class CustomPaginationRoute extends _i12.PageRouteInfo<void> {
  const CustomPaginationRoute({List<_i12.PageRouteInfo>? children})
      : super(
          CustomPaginationRoute.name,
          initialChildren: children,
        );

  static const String name = 'CustomPaginationRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i3.DashboardPage]
class DashboardRoute extends _i12.PageRouteInfo<void> {
  const DashboardRoute({List<_i12.PageRouteInfo>? children})
      : super(
          DashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashboardRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i4.ForceUpdateUnderMaintenancePage]
class ForceUpdateUnderMaintenanceRoute extends _i12.PageRouteInfo<void> {
  const ForceUpdateUnderMaintenanceRoute({List<_i12.PageRouteInfo>? children})
      : super(
          ForceUpdateUnderMaintenanceRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForceUpdateUnderMaintenanceRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i5.LoginPage]
class LoginRoute extends _i12.PageRouteInfo<void> {
  const LoginRoute({List<_i12.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i6.PageNotFound]
class RouteNotFound extends _i12.PageRouteInfo<void> {
  const RouteNotFound({List<_i12.PageRouteInfo>? children})
      : super(
          RouteNotFound.name,
          initialChildren: children,
        );

  static const String name = 'RouteNotFound';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i7.SplashPage]
class SplashRoute extends _i12.PageRouteInfo<void> {
  const SplashRoute({List<_i12.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i8.TabOneDetailPage]
class TabOneDetailRoute extends _i12.PageRouteInfo<void> {
  const TabOneDetailRoute({List<_i12.PageRouteInfo>? children})
      : super(
          TabOneDetailRoute.name,
          initialChildren: children,
        );

  static const String name = 'TabOneDetailRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i9.TabOnePage]
class TabOneRoute extends _i12.PageRouteInfo<void> {
  const TabOneRoute({List<_i12.PageRouteInfo>? children})
      : super(
          TabOneRoute.name,
          initialChildren: children,
        );

  static const String name = 'TabOneRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i10.TabTwoDetailPage]
class TabTwoDetailRoute extends _i12.PageRouteInfo<void> {
  const TabTwoDetailRoute({List<_i12.PageRouteInfo>? children})
      : super(
          TabTwoDetailRoute.name,
          initialChildren: children,
        );

  static const String name = 'TabTwoDetailRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i11.TabTwoPage]
class TabTwoRoute extends _i12.PageRouteInfo<void> {
  const TabTwoRoute({List<_i12.PageRouteInfo>? children})
      : super(
          TabTwoRoute.name,
          initialChildren: children,
        );

  static const String name = 'TabTwoRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}
