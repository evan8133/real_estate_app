import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:real_estate_app/services/firebase_auth_methods.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final FirebsaeAuthMethods authMethods =
        FirebsaeAuthMethods(FirebaseAuth.instance);
    if (authMethods.user != null && authMethods.user!.uid.isNotEmpty) {
      resolver.next(true);
    } else {
      //router.push(const LoginRoute()).then((_) => resolver.next(false));
    }
  }
}