import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:real_estate_app/services/firestore_properties_methods.dart';
import 'package:real_estate_app/services/firestore_user_methods.dart';
import 'package:real_estate_app/utils/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter(
    userGuard: UserGuard(),
  );

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeMode = themeProvider.themeMode;
    return MultiProvider(
      providers: [
        Provider<FirebsaeAuthMethods>(
          create: (_) => FirebsaeAuthMethods(FirebaseAuth.instance),
        ),
        Provider<PropertyService>(
          create: (_) => PropertyService(),
        ),
        StreamProvider(
          create: (context) => context.read<FirebsaeAuthMethods>().authState,
          initialData: null,
        ),
        Provider<FirestoreMethodsUsers>(
          create: (_) => FirestoreMethodsUsers(FirebaseFirestore.instance),
        ),
        // Provider<StorageMethods>(
        //   create: (_) => StorageMethods(FirebaseStorage.instance),
        // ),
      ],
      child: MaterialApp.router(
        title: 'Real Estate App',
        debugShowCheckedModeBanner: false,
        theme: FlexThemeData.light(
          colors: const FlexSchemeColor(
            primary: Color(0xff065808),
            primaryContainer: Color(0xff9ee29f),
            secondary: Color(0xff365b37),
            secondaryContainer: Color(0xffaebdaf),
            tertiary: Color(0xff2c7e2e),
            tertiaryContainer: Color(0xffb8e6b9),
            appBarColor: Color(0xffb8e6b9),
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
          // To use the playground font, add GoogleFonts package and uncomment
          // fontFamily: GoogleFonts.notoSans().fontFamily,
        ),
        darkTheme: FlexThemeData.dark(
          colors: const FlexSchemeColor(
            primary: Color(0xff629f80),
            primaryContainer: Color(0xff274033),
            secondary: Color(0xff81b39a),
            secondaryContainer: Color(0xff4d6b5c),
            tertiary: Color(0xff88c5a6),
            tertiaryContainer: Color(0xff356c50),
            appBarColor: Color(0xff356c50),
            error: Color(0xffcf6679),
          ),
          surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
          blendLevel: 13,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 20,
            blendTextTheme: true,
            useM2StyleDividerInM3: true,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          swapLegacyOnMaterial3: true,
          // To use the Playground font, add GoogleFonts package and uncomment
          // fontFamily: GoogleFonts.notoSans().fontFamily,
        ),
        themeMode:
            themeMode == ThemeModeType.light ? ThemeMode.light : ThemeMode.dark,
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
