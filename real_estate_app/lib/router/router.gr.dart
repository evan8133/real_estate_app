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
import 'package:auto_route/auto_route.dart' as _i22;
import 'package:flutter/material.dart' as _i23;

import '../screens/admin/home/admin_nav_home.dart' as _i4;
import '../screens/admin/main/admin_main_screen.dart' as _i19;
import '../screens/admin/manage_agents/page/manage_agent.dart' as _i8;
import '../screens/admin/manage_property/page/manage_property.dart' as _i9;
import '../screens/admin/manage_users/page/manage_user.dart' as _i7;
import '../screens/admin/manager/page/managment_screen.dart' as _i21;
import '../screens/admin/setting/admin_setting_screen.dart' as _i20;
import '../screens/agent/agent_properties/agent_add_properte.dart' as _i11;
import '../screens/agent/agent_properties/agent_properte_detial_screen.dart'
    as _i10;
import '../screens/agent/agent_properties/agent_properties_screen.dart' as _i14;
import '../screens/agent/home/agent_nav_home.dart' as _i2;
import '../screens/agent/main/agent_home_screen.dart' as _i12;
import '../screens/agent/settings/agent_settings_screen.dart' as _i13;
import '../screens/login/page/login_screen.dart' as _i5;
import '../screens/login/page/sign_up_screen.dart' as _i6;
import '../screens/splash/splash_screen.dart' as _i1;
import '../screens/users/home/home_screen.dart' as _i3;
import '../screens/users/main/page/main_screen.dart' as _i15;
import '../screens/users/map/map_screen.dart' as _i16;
import '../screens/users/search/search_screen.dart' as _i18;
import '../screens/users/setting/setting_screen.dart' as _i17;
import 'router_guards.dart' as _i24;

class AppRouter extends _i22.RootStackRouter {
  AppRouter({
    _i23.GlobalKey<_i23.NavigatorState>? navigatorKey,
    required this.userGuard,
  }) : super(navigatorKey);

  final _i24.UserGuard userGuard;

  @override
  final Map<String, _i22.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i1.SplashScreen(),
      );
    },
    AgentNavRoute.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.AgentNavScreen(),
      );
    },
    UserNavigation.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.HomeNavigationScreen(),
      );
    },
    AdminNavigation.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.AdminNavScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i5.LoginScreen(),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i6.SignUpScreen(),
      );
    },
    ManageUsersRoute.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i7.ManageUsersScreen(),
      );
    },
    ManageAgentsRoute.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i8.ManageAgentsScreen(),
      );
    },
    ManagePropertiesRoute.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i9.ManagePropertiesScreen(),
      );
    },
    PropertydetailRoute.name: (routeData) {
      final args = routeData.argsAs<PropertydetailRouteArgs>();
      return _i22.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i10.AgentProperteDetailScreen(
          key: args.key,
          properteId: args.properteId,
        ),
      );
    },
    AddpropertyRoute.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i11.AgentAddPropertyScreen(),
      );
    },
    Agenthome.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i12.AgentHomeScreen(),
      );
    },
    Agentsetting.name: (routeData) {
      final args = routeData.argsAs<AgentsettingArgs>(
          orElse: () => const AgentsettingArgs());
      return _i22.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i13.AgentSettingScreen(key: args.key),
      );
    },
    Agentproperties.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i14.AgentPropertiesScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      final args =
          routeData.argsAs<HomeRouteArgs>(orElse: () => const HomeRouteArgs());
      return _i22.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i15.MainScreen(key: args.key),
      );
    },
    MapRoute.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i16.MapScreen(),
      );
    },
    SettingsRoute.name: (routeData) {
      final args = routeData.argsAs<SettingsRouteArgs>(
          orElse: () => const SettingsRouteArgs());
      return _i22.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i17.SettingScreen(key: args.key),
      );
    },
    SearchRoute.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i18.SearchScreen(),
      );
    },
    Adminhome.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i19.AdminMainScreen(),
      );
    },
    Adminsetting.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i20.AdminSettingScreen(),
      );
    },
    Managment.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i21.ManagmentScreen(),
      );
    },
  };

  @override
  List<_i22.RouteConfig> get routes => [
        _i22.RouteConfig(
          SplashRoute.name,
          path: '/',
        ),
        _i22.RouteConfig(
          AgentNavRoute.name,
          path: '/agenthome',
          guards: [userGuard],
          children: [
            _i22.RouteConfig(
              Agenthome.name,
              path: 'agenthome',
              parent: AgentNavRoute.name,
              guards: [userGuard],
            ),
            _i22.RouteConfig(
              Agentsetting.name,
              path: 'agentsetting',
              parent: AgentNavRoute.name,
              guards: [userGuard],
            ),
            _i22.RouteConfig(
              Agentproperties.name,
              path: 'agentproperties',
              parent: AgentNavRoute.name,
              guards: [userGuard],
            ),
          ],
        ),
        _i22.RouteConfig(
          UserNavigation.name,
          path: '/home',
          guards: [userGuard],
          children: [
            _i22.RouteConfig(
              HomeRoute.name,
              path: 'home',
              parent: UserNavigation.name,
              guards: [userGuard],
            ),
            _i22.RouteConfig(
              MapRoute.name,
              path: 'map',
              parent: UserNavigation.name,
              guards: [userGuard],
            ),
            _i22.RouteConfig(
              SettingsRoute.name,
              path: 'settings',
              parent: UserNavigation.name,
              guards: [userGuard],
            ),
            _i22.RouteConfig(
              SearchRoute.name,
              path: 'search',
              parent: UserNavigation.name,
              guards: [userGuard],
            ),
          ],
        ),
        _i22.RouteConfig(
          AdminNavigation.name,
          path: '/adminhome',
          guards: [userGuard],
          children: [
            _i22.RouteConfig(
              Adminhome.name,
              path: 'adminhome',
              parent: AdminNavigation.name,
              guards: [userGuard],
            ),
            _i22.RouteConfig(
              Adminsetting.name,
              path: 'adminsetting',
              parent: AdminNavigation.name,
              guards: [userGuard],
            ),
            _i22.RouteConfig(
              Managment.name,
              path: 'managment',
              parent: AdminNavigation.name,
              guards: [userGuard],
            ),
          ],
        ),
        _i22.RouteConfig(
          LoginRoute.name,
          path: '/login',
        ),
        _i22.RouteConfig(
          SignUpRoute.name,
          path: '/signup',
        ),
        _i22.RouteConfig(
          ManageUsersRoute.name,
          path: '/manageusers',
          guards: [userGuard],
        ),
        _i22.RouteConfig(
          ManageAgentsRoute.name,
          path: '/manageagents',
          guards: [userGuard],
        ),
        _i22.RouteConfig(
          ManagePropertiesRoute.name,
          path: '/manageproperties',
          guards: [userGuard],
        ),
        _i22.RouteConfig(
          PropertydetailRoute.name,
          path: '/propertydetail:id',
          guards: [userGuard],
        ),
        _i22.RouteConfig(
          AddpropertyRoute.name,
          path: '/addproperty',
          guards: [userGuard],
        ),
      ];
}

/// generated route for
/// [_i1.SplashScreen]
class SplashRoute extends _i22.PageRouteInfo<void> {
  const SplashRoute()
      : super(
          SplashRoute.name,
          path: '/',
        );

  static const String name = 'SplashRoute';
}

/// generated route for
/// [_i2.AgentNavScreen]
class AgentNavRoute extends _i22.PageRouteInfo<void> {
  const AgentNavRoute({List<_i22.PageRouteInfo>? children})
      : super(
          AgentNavRoute.name,
          path: '/agenthome',
          initialChildren: children,
        );

  static const String name = 'AgentNavRoute';
}

/// generated route for
/// [_i3.HomeNavigationScreen]
class UserNavigation extends _i22.PageRouteInfo<void> {
  const UserNavigation({List<_i22.PageRouteInfo>? children})
      : super(
          UserNavigation.name,
          path: '/home',
          initialChildren: children,
        );

  static const String name = 'UserNavigation';
}

/// generated route for
/// [_i4.AdminNavScreen]
class AdminNavigation extends _i22.PageRouteInfo<void> {
  const AdminNavigation({List<_i22.PageRouteInfo>? children})
      : super(
          AdminNavigation.name,
          path: '/adminhome',
          initialChildren: children,
        );

  static const String name = 'AdminNavigation';
}

/// generated route for
/// [_i5.LoginScreen]
class LoginRoute extends _i22.PageRouteInfo<void> {
  const LoginRoute()
      : super(
          LoginRoute.name,
          path: '/login',
        );

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i6.SignUpScreen]
class SignUpRoute extends _i22.PageRouteInfo<void> {
  const SignUpRoute()
      : super(
          SignUpRoute.name,
          path: '/signup',
        );

  static const String name = 'SignUpRoute';
}

/// generated route for
/// [_i7.ManageUsersScreen]
class ManageUsersRoute extends _i22.PageRouteInfo<void> {
  const ManageUsersRoute()
      : super(
          ManageUsersRoute.name,
          path: '/manageusers',
        );

  static const String name = 'ManageUsersRoute';
}

/// generated route for
/// [_i8.ManageAgentsScreen]
class ManageAgentsRoute extends _i22.PageRouteInfo<void> {
  const ManageAgentsRoute()
      : super(
          ManageAgentsRoute.name,
          path: '/manageagents',
        );

  static const String name = 'ManageAgentsRoute';
}

/// generated route for
/// [_i9.ManagePropertiesScreen]
class ManagePropertiesRoute extends _i22.PageRouteInfo<void> {
  const ManagePropertiesRoute()
      : super(
          ManagePropertiesRoute.name,
          path: '/manageproperties',
        );

  static const String name = 'ManagePropertiesRoute';
}

/// generated route for
/// [_i10.AgentProperteDetailScreen]
class PropertydetailRoute extends _i22.PageRouteInfo<PropertydetailRouteArgs> {
  PropertydetailRoute({
    _i23.Key? key,
    required String properteId,
  }) : super(
          PropertydetailRoute.name,
          path: '/propertydetail:id',
          args: PropertydetailRouteArgs(
            key: key,
            properteId: properteId,
          ),
        );

  static const String name = 'PropertydetailRoute';
}

class PropertydetailRouteArgs {
  const PropertydetailRouteArgs({
    this.key,
    required this.properteId,
  });

  final _i23.Key? key;

  final String properteId;

  @override
  String toString() {
    return 'PropertydetailRouteArgs{key: $key, properteId: $properteId}';
  }
}

/// generated route for
/// [_i11.AgentAddPropertyScreen]
class AddpropertyRoute extends _i22.PageRouteInfo<void> {
  const AddpropertyRoute()
      : super(
          AddpropertyRoute.name,
          path: '/addproperty',
        );

  static const String name = 'AddpropertyRoute';
}

/// generated route for
/// [_i12.AgentHomeScreen]
class Agenthome extends _i22.PageRouteInfo<void> {
  const Agenthome()
      : super(
          Agenthome.name,
          path: 'agenthome',
        );

  static const String name = 'Agenthome';
}

/// generated route for
/// [_i13.AgentSettingScreen]
class Agentsetting extends _i22.PageRouteInfo<AgentsettingArgs> {
  Agentsetting({_i23.Key? key})
      : super(
          Agentsetting.name,
          path: 'agentsetting',
          args: AgentsettingArgs(key: key),
        );

  static const String name = 'Agentsetting';
}

class AgentsettingArgs {
  const AgentsettingArgs({this.key});

  final _i23.Key? key;

  @override
  String toString() {
    return 'AgentsettingArgs{key: $key}';
  }
}

/// generated route for
/// [_i14.AgentPropertiesScreen]
class Agentproperties extends _i22.PageRouteInfo<void> {
  const Agentproperties()
      : super(
          Agentproperties.name,
          path: 'agentproperties',
        );

  static const String name = 'Agentproperties';
}

/// generated route for
/// [_i15.MainScreen]
class HomeRoute extends _i22.PageRouteInfo<HomeRouteArgs> {
  HomeRoute({_i23.Key? key})
      : super(
          HomeRoute.name,
          path: 'home',
          args: HomeRouteArgs(key: key),
        );

  static const String name = 'HomeRoute';
}

class HomeRouteArgs {
  const HomeRouteArgs({this.key});

  final _i23.Key? key;

  @override
  String toString() {
    return 'HomeRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i16.MapScreen]
class MapRoute extends _i22.PageRouteInfo<void> {
  const MapRoute()
      : super(
          MapRoute.name,
          path: 'map',
        );

  static const String name = 'MapRoute';
}

/// generated route for
/// [_i17.SettingScreen]
class SettingsRoute extends _i22.PageRouteInfo<SettingsRouteArgs> {
  SettingsRoute({_i23.Key? key})
      : super(
          SettingsRoute.name,
          path: 'settings',
          args: SettingsRouteArgs(key: key),
        );

  static const String name = 'SettingsRoute';
}

class SettingsRouteArgs {
  const SettingsRouteArgs({this.key});

  final _i23.Key? key;

  @override
  String toString() {
    return 'SettingsRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i18.SearchScreen]
class SearchRoute extends _i22.PageRouteInfo<void> {
  const SearchRoute()
      : super(
          SearchRoute.name,
          path: 'search',
        );

  static const String name = 'SearchRoute';
}

/// generated route for
/// [_i19.AdminMainScreen]
class Adminhome extends _i22.PageRouteInfo<void> {
  const Adminhome()
      : super(
          Adminhome.name,
          path: 'adminhome',
        );

  static const String name = 'Adminhome';
}

/// generated route for
/// [_i20.AdminSettingScreen]
class Adminsetting extends _i22.PageRouteInfo<void> {
  const Adminsetting()
      : super(
          Adminsetting.name,
          path: 'adminsetting',
        );

  static const String name = 'Adminsetting';
}

/// generated route for
/// [_i21.ManagmentScreen]
class Managment extends _i22.PageRouteInfo<void> {
  const Managment()
      : super(
          Managment.name,
          path: 'managment',
        );

  static const String name = 'Managment';
}
