import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_app/firebase_options.dart';
import 'package:real_estate_app/router/router.gr.dart';
import 'package:real_estate_app/router/router_guards.dart';
import 'package:real_estate_app/services/firebase_auth_methods.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter(userGuard: UserGuard(),);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
         Provider<FirebsaeAuthMethods>(
          create: (_) => FirebsaeAuthMethods(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<FirebsaeAuthMethods>().authState,
          initialData: null,
        ),
        // Provider<FirestoreMethods>(
        //   create: (_) => FirestoreMethods(FirebaseFirestore.instance),
        // ),
        // Provider<StorageMethods>(
        //   create: (_) => StorageMethods(FirebaseStorage.instance),
        // ),
      ],
      child: MaterialApp.router(
        title: 'Real Estate App',
        debugShowCheckedModeBanner: false,
        theme: FlexThemeData.light(
          colors: const FlexSchemeColor(
            primary: Color(0xff1145a4),
            primaryContainer: Color(0xffacc7f6),
            secondary: Color(0xffb61d1d),
            secondaryContainer: Color(0xffec9f9f),
            tertiary: Color(0xff376bca),
            tertiaryContainer: Color(0xffcfdbf2),
            appBarColor: Color(0xffcfdbf2),
            error: Color(0xffb00020),
          ),
          surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
          blendLevel: 7,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 10,
            blendOnColors: false,
            useM2StyleDividerInM3: true,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          swapLegacyOnMaterial3: true,
          fontFamily: GoogleFonts.notoSans().fontFamily,
        ),
        darkTheme: FlexThemeData.dark(
          colors: const FlexSchemeColor(
            primary: Color(0xffc4d7f8),
            primaryContainer: Color(0xff577cbf),
            secondary: Color(0xfff1bbbb),
            secondaryContainer: Color(0xffcb6060),
            tertiary: Color(0xffdde5f5),
            tertiaryContainer: Color(0xff7297d9),
            appBarColor: Color(0xffdde5f5),
            error: null,
          ),
          surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        ),
        routerDelegate: _appRouter.delegate(),
        routeInformationParser: _appRouter.defaultRouteParser(),
        builder: (context, router) {
          // initialize screen util here
          ScreenUtil.init(
            context,
            designSize: const Size(360, 690),
          );
          return router!;
        },
      ),
    );
  }
}
