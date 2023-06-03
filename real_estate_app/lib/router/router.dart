import 'package:auto_route/auto_route.dart';
import 'package:real_estate_app/screens/login/page/login_screen.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: [
    MaterialRoute(page: LoginScreen, initial: true, path: '/login'),
  ],
)
class $AppRouter {}
