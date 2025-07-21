import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:myapp/common/locale/locale_provider.dart';
import 'package:myapp/common/navigation/route_manager.dart';
import 'package:myapp/common/responsive/responsive_app.dart';
import 'package:myapp/common/theme/theme_provider.dart';
import 'package:myapp/common/theme/themes.dart';
import 'package:myapp/core/services/audio_service.dart';
import 'package:myapp/features/auth/screens/sign_in_screen.dart';
import 'package:myapp/features/mainPage/MainPage.dart';
import 'package:myapp/features/profile/screens/member_information_screen.dart';
import 'package:myapp/features/profile/screens/profile_page.dart';
import 'package:myapp/features/splash/splash_screen.dart';
import 'package:myapp/features/utsav/providers/UtsavVoucherProvider.dart';
import 'package:myapp/features/utsav/providers/search_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/auth/screens/interest_selection_screen.dart';

// Define a custom Scaffold that respects the bottom navigation bar
class CustomScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool extendBody;

  const CustomScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.extendBody = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: extendBody,
      appBar: appBar,
      body: body,
      bottomNavigationBar: bottomNavigationBar != null
          ? Padding(
              // Add bottom padding to avoid system navigation bar
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              child: bottomNavigationBar,
            )
          : null,
      backgroundColor: backgroundColor,
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;

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
      ],
      child: MyApp(showHome: showHome),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool showHome;

  const MyApp({
    super.key,
    required this.showHome,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LocaleProvider>(
      builder: (context, themeProvider, localeProvider, child) {
        return ResponsiveApp(
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
            // Show MainPage if user is signed in, otherwise show SplashScreen
            home: SplashScreen(
              onComplete: () {
                print('onComplete');
                // Navigate to SignInScreen after splash if not signed in
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //       builder: (context) =>
                //           showHome ? const MainPage() : const SignInScreen()),
                // );
              },
            ),
            routes: {
              RouteManager.mainPage: (context) =>
                  showHome ? const MainPage() : const SignInScreen(),
              RouteManager.profilePage: (context) => const ProfilePage(),
              RouteManager.memberInformationPage: (context) =>
                  const MemberInformationScreen(),
              // showHome ? const QuizScreen() : const SignInScreen(),
            },
            onGenerateRoute: RouteManager.generateRoute,
          ),
        );
      },
    );
  }
}
