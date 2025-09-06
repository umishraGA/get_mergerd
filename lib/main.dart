import 'main.dart';

export 'package:flutter/material.dart';
export 'package:flutter/services.dart';
export 'package:flutter_localizations/flutter_localizations.dart';
export 'package:get/get.dart';
export 'package:myapp/common/locale/locale_provider.dart';
export 'package:myapp/common/navigation/route_manager.dart';
export 'package:myapp/common/responsive/responsive_app.dart';
export 'package:myapp/common/theme/theme_provider.dart';
export 'package:myapp/common/theme/themes.dart';
export 'package:myapp/core/services/audio_service.dart';
export 'package:myapp/features/auth/screens/sign_in_screen.dart';
export 'package:myapp/features/mainPage/MainPage.dart';
export 'package:myapp/features/posts/controller/reaction_controller.dart';
export 'package:myapp/features/profile/screens/member_information_screen.dart';
export 'package:myapp/features/profile/screens/profile_page.dart';
export 'package:myapp/features/splash/splash_screen.dart';
export 'package:myapp/features/utsav/providers/UtsavVoucherProvider.dart';
export 'package:myapp/features/utsav/providers/search_provider.dart';
export 'package:myapp/utils/dio/auth_helper.dart';
export 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize shared preferences
  AuthHelper.init();
  // Set preferred orientations to portrait only by default
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // IMPORTANT: Set proper system UI settings
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );

  // Configure system UI overlay
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  // Initialize audio service
  await AudioService().initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) {
          final provider = UtsavVoucherProvider();
          // Initialize with sample data for testing
          provider.initSampleData();
          return provider;
        }),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => ReactionController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LocaleProvider>(
      builder: (context, themeProvider, localeProvider, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: ResponsiveApp(
            materialApp: MaterialApp(
              title: 'Happening Bazar',
              theme: AppThemes.lightThemes[themeProvider.colorTheme],
              themeMode: ThemeMode.light,
              locale: localeProvider.locale,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', ''), // English
              ],
              // Add a builder to wrap all screens in a SafeArea
              builder: (context, child) {
                return SafeArea(
                  // Only apply SafeArea to the bottom
                  top: false,
                  left: false,
                  right: false,
                  bottom: true,
                  // Maintain theme background color
                  child: Theme(
                    data: Theme.of(context),
                    child: child!,
                  ),
                );
              },
              // Show MainPage if user is authenticated, otherwise show SplashScreen
              home:  SplashScreen(isAuthenticated:  AuthHelper.isFullyOnboarded ,),
              routes: {
                RouteManager.mainPage: (context) =>
                AuthHelper.isFullyOnboarded ? const MainPage() : const SignInScreen(),
                RouteManager.profilePage: (context) => const ProfilePage(),
                RouteManager.memberInformationPage: (context) =>
                const MemberInformationScreen(),
              },
              onGenerateRoute: RouteManager.generateRoute,
            ),
          ),
        );
      },
    );
  }
}
