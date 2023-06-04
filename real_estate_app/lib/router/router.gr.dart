// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i12;
import 'package:flutter/material.dart' as _i13;

import '../screens/admin/home/admin_nav_home.dart' as _i3;
import '../screens/admin/main/admin_main_screen.dart' as _i10;
import '../screens/admin/setting/admin_setting_screen.dart' as _i11;
import '../screens/login/page/login_screen.dart' as _i4;
import '../screens/login/page/sign_up_screen.dart' as _i5;
import '../screens/splash/splash_screen.dart' as _i1;
import '../screens/users/home/home_screen.dart' as _i2;
import '../screens/users/main/page/main_screen.dart' as _i6;
import '../screens/users/profile/profile_screen.dart' as _i7;
import '../screens/users/search/search_screen.dart' as _i9;
import '../screens/users/setting/setting_screen.dart' as _i8;
import 'router_guards.dart' as _i14;

class AppRouter extends _i12.RootStackRouter {
  AppRouter({
    _i13.GlobalKey<_i13.NavigatorState>? navigatorKey,
    required this.userGuard,
  }) : super(navigatorKey);

  final _i14.UserGuard userGuard;

  @override
  final Map<String, _i12.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i1.SplashScreen(),
      );
    },
    UserNavigation.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.HomeNavigationScreen(),
      );
    },
    AdminNavigation.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.AdminNavScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.LoginScreen(),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i5.SignUpScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child:  _i6.MainScreen(),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i7.ProfileScreen(),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child:  _i8.SettingScreen(),
      );
    },
    SearchRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i9.SearchScreen(),
      );
    },
    Adminhome.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i10.AdminMainScreen(),
      );
    },
    Adminsetting.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child:  _i11.AdminSettingScreen(),
      );
    },
  };

  @override
  List<_i12.RouteConfig> get routes => [
        _i12.RouteConfig(
          SplashRoute.name,
          path: '/',
        ),
        _i12.RouteConfig(
          UserNavigation.name,
          path: '/home',
          guards: [userGuard],
          children: [
            _i12.RouteConfig(
              HomeRoute.name,
              path: 'home',
              parent: UserNavigation.name,
              guards: [userGuard],
            ),
            _i12.RouteConfig(
              ProfileRoute.name,
              path: 'profile',
              parent: UserNavigation.name,
              guards: [userGuard],
            ),
            _i12.RouteConfig(
              SettingsRoute.name,
              path: 'settings',
              parent: UserNavigation.name,
              guards: [userGuard],
            ),
            _i12.RouteConfig(
              SearchRoute.name,
              path: 'search',
              parent: UserNavigation.name,
              guards: [userGuard],
            ),
          ],
        ),
        _i12.RouteConfig(
          AdminNavigation.name,
          path: '/adminhome',
          guards: [userGuard],
          children: [
            _i12.RouteConfig(
              Adminhome.name,
              path: 'adminhome',
              parent: AdminNavigation.name,
              guards: [userGuard],
            ),
            _i12.RouteConfig(
              Adminsetting.name,
              path: 'adminsetting',
              parent: AdminNavigation.name,
              guards: [userGuard],
            ),
          ],
        ),
        _i12.RouteConfig(
          LoginRoute.name,
          path: '/login',
        ),
        _i12.RouteConfig(
          SignUpRoute.name,
          path: '/signup',
        ),
      ];
}

/// generated route for
/// [_i1.SplashScreen]
class SplashRoute extends _i12.PageRouteInfo<void> {
  const SplashRoute()
      : super(
          SplashRoute.name,
          path: '/',
        );

  static const String name = 'SplashRoute';
}

/// generated route for
/// [_i2.HomeNavigationScreen]
class UserNavigation extends _i12.PageRouteInfo<void> {
  const UserNavigation({List<_i12.PageRouteInfo>? children})
      : super(
          UserNavigation.name,
          path: '/home',
          initialChildren: children,
        );

  static const String name = 'UserNavigation';
}

/// generated route for
/// [_i3.AdminNavScreen]
class AdminNavigation extends _i12.PageRouteInfo<void> {
  const AdminNavigation({List<_i12.PageRouteInfo>? children})
      : super(
          AdminNavigation.name,
          path: '/adminhome',
          initialChildren: children,
        );

  static const String name = 'AdminNavigation';
}

/// generated route for
/// [_i4.LoginScreen]
class LoginRoute extends _i12.PageRouteInfo<void> {
  const LoginRoute()
      : super(
          LoginRoute.name,
          path: '/login',
        );

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i5.SignUpScreen]
class SignUpRoute extends _i12.PageRouteInfo<void> {
  const SignUpRoute()
      : super(
          SignUpRoute.name,
          path: '/signup',
        );

  static const String name = 'SignUpRoute';
}

/// generated route for
/// [_i6.MainScreen]
class HomeRoute extends _i12.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: 'home',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i7.ProfileScreen]
class ProfileRoute extends _i12.PageRouteInfo<void> {
  const ProfileRoute()
      : super(
          ProfileRoute.name,
          path: 'profile',
        );

  static const String name = 'ProfileRoute';
}

/// generated route for
/// [_i8.SettingScreen]
class SettingsRoute extends _i12.PageRouteInfo<void> {
  const SettingsRoute()
      : super(
          SettingsRoute.name,
          path: 'settings',
        );

  static const String name = 'SettingsRoute';
}

/// generated route for
/// [_i9.SearchScreen]
class SearchRoute extends _i12.PageRouteInfo<void> {
  const SearchRoute()
      : super(
          SearchRoute.name,
          path: 'search',
        );

  static const String name = 'SearchRoute';
}

/// generated route for
/// [_i10.AdminMainScreen]
class Adminhome extends _i12.PageRouteInfo<void> {
  const Adminhome()
      : super(
          Adminhome.name,
          path: 'adminhome',
        );

  static const String name = 'Adminhome';
}

/// generated route for
/// [_i11.AdminSettingScreen]
class Adminsetting extends _i12.PageRouteInfo<void> {
  const Adminsetting()
      : super(
          Adminsetting.name,
          path: 'adminsetting',
        );

  static const String name = 'Adminsetting';
}
