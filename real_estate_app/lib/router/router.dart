import 'package:auto_route/auto_route.dart';
import 'package:real_estate_app/router/router_guards.dart';
import 'package:real_estate_app/screens/admin/home/admin_nav_home.dart';
import 'package:real_estate_app/screens/admin/main/admin_main_screen.dart';
import 'package:real_estate_app/screens/admin/manage_agents/page/manage_agent.dart';
import 'package:real_estate_app/screens/admin/manage_property/page/manage_property.dart';
import 'package:real_estate_app/screens/admin/manage_users/page/manage_user.dart';
import 'package:real_estate_app/screens/admin/manager/page/managment_screen.dart';
import 'package:real_estate_app/screens/admin/setting/admin_setting_screen.dart';
import 'package:real_estate_app/screens/agent/home/agent_nav_home.dart';
import 'package:real_estate_app/screens/login/page/login_screen.dart';
import 'package:real_estate_app/screens/login/page/sign_up_screen.dart';
import 'package:real_estate_app/screens/users/main/page/main_screen.dart';

import '../screens/agent/agent_properties/agent_add_properte.dart';
import '../screens/agent/agent_properties/agent_properte_detial_screen.dart';
import '../screens/agent/agent_properties/agent_properties_screen.dart';
import '../screens/agent/main/agent_home_screen.dart';
import '../screens/agent/settings/agent_settings_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/users/home/home_screen.dart';
import '../screens/users/map/map_screen.dart';
import '../screens/users/search/search_screen.dart';
import '../screens/users/setting/setting_screen.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: [
    MaterialRoute(
      initial: true,
      page: SplashScreen,
      path: '/',
    ),
    MaterialRoute(page: AgentNavScreen, path: '/agenthome', guards: [
      UserGuard
    ], children: [
      MaterialRoute(
        path: 'agenthome',
        name: 'agenthome',
        page: AgentHomeScreen,
        guards: [UserGuard],
      ),
      MaterialRoute(
        path: 'agentsetting',
        name: 'agentsetting',
        page: AgentSettingScreen,
        guards: [UserGuard],
      ),
      MaterialRoute(
        page: AgentPropertiesScreen,
        path: 'agentproperties',
        name: 'agentproperties',
        guards: [UserGuard],
      ),
    ]),
    MaterialRoute(
      path: '/home',
      name: 'userNavigation',
      page: HomeNavigationScreen,
      guards: [UserGuard],
      children: [
        MaterialRoute(
          path: 'home',
          name: 'homeRoute',
          page: MainScreen,
          guards: [UserGuard],
        ),
        MaterialRoute(
          path: 'map',
          name: 'mapRoute',
          page: MapScreen,
          guards: [UserGuard],
        ),
        MaterialRoute(
          path: 'settings',
          name: 'settingsRoute',
          page: SettingScreen,
          guards: [UserGuard],
        ),
        MaterialRoute(
          path: 'search',
          name: 'searchRoute',
          page: SearchScreen,
          guards: [UserGuard],
        ),
      ],
    ),
    MaterialRoute(
      path: '/adminhome',
      name: 'adminNavigation',
      page: AdminNavScreen,
      guards: [UserGuard],
      children: [
        MaterialRoute(
          path: 'adminhome',
          name: 'adminhome',
          page: AdminMainScreen,
          guards: [UserGuard],
        ),
        MaterialRoute(
          path: 'adminsetting',
          name: 'adminsetting',
          page: AdminSettingScreen,
          guards: [UserGuard],
        ),
        MaterialRoute(
          page: ManagmentScreen,
          path: 'managment',
          name: 'managment',
          guards: [UserGuard],
        ),
      ],
    ),
    MaterialRoute(
      page: LoginScreen,
      path: '/login',
    ),
    MaterialRoute(
      page: SignUpScreen,
      path: '/signup',
    ),
    MaterialRoute(
      page: ManageUsersScreen,
      path: '/manageusers',
      guards: [
        UserGuard,
      ],
    ),
    MaterialRoute(
      page: ManageAgentsScreen,
      path: '/manageagents',
      guards: [
        UserGuard,
      ],
    ),
    MaterialRoute(
      page: ManagePropertiesScreen,
      path: '/manageproperties',
      guards: [
        UserGuard,
      ],
    ),
    MaterialRoute(
      page: AgentProperteDetailScreen,
      path: '/propertydetail:id',
      name: 'propertydetailRoute',
      guards: [UserGuard],
    ),
    MaterialRoute(
      page: AgentAddPropertyScreen,
      path: '/addproperty',
      name: 'addpropertyRoute',
      guards: [UserGuard],
    ),
  ],
)
class $AppRouter {}
