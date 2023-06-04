import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:real_estate_app/router/router_guards.dart';
import 'package:real_estate_app/screens/admin/home/admin_nav_home.dart';
import 'package:real_estate_app/screens/admin/main/admin_main_screen.dart';
import 'package:real_estate_app/screens/admin/setting/admin_setting_screen.dart';
import 'package:real_estate_app/screens/login/page/login_screen.dart';
import 'package:real_estate_app/screens/login/page/sign_up_screen.dart';
import 'package:real_estate_app/screens/users/main/page/main_screen.dart';

import '../screens/splash/splash_screen.dart';
import '../screens/users/home/home_screen.dart';
import '../screens/users/profile/profile_screen.dart';
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
          path: 'profile',
          name: 'profileRoute',
          page: ProfileScreen,
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
        )
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
        )
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
  ],
)
class $AppRouter {}
