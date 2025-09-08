// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Project-specific imports — adjust paths as needed in your project:
import 'main_widget.dart'; // (should export ResponsiveApp, AppThemes, RouteManager, SplashScreen, etc.)
import 'package:myapp/features/auth/screens/sign_up_screen.dart';
// If AuthHelper, AudioService, ThemeProvider, LocaleProvider, UtsavVoucherProvider,
// SearchProvider, ReactionController are in other files, ensure those files are imported
// or exported by main_widget.dart.

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize AuthHelper (await to ensure it's ready before using its flags)
  try {
    await AuthHelper.init();
  } catch (e) {
    // If initialization fails, log it — don't crash the app silently.
    debugPrint('AuthHelper.init() failed: $e');
  }

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configure system UI overlays
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  // Initialize audio service safely (with try/catch)
  try {
    await AudioService().initialize();
  } catch (e) {
    debugPrint('AudioService initialization failed: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) {
          final provider = UtsavVoucherProvider();
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
          title: 'Happening Bazar',
          // Use your app theme provider
          theme: AppThemes.lightThemes[themeProvider.colorTheme],
          themeMode: ThemeMode.light,
          locale: localeProvider.locale,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
          ],

          // Wrap all screens in SafeArea (top: false to allow status bar color handling)
          builder: (context, child) {
            return SafeArea(
              top: false,
              left: true,
              right: true,
              bottom: true,
              child: Theme(data: Theme.of(context), child: child ?? const SizedBox()),
            );
          },

          // Start with splash screen
          home: const SplashScreen(),

          // Routes: the mainPage route returns the appropriate page based on AuthHelper flags
          routes: {
            RouteManager.mainPage: (context) {
              if (AuthHelper.isFullyOnboarded) {
                if (AuthHelper.getProfileCompleted) {
                  return const MainPage();
                } else {
                  return const SignUpScreen();
                }
              } else {
                return const SignInScreen();
              }
            },
            RouteManager.profilePage: (context) => const ProfilePage(),
            RouteManager.memberInformationPage: (context) => const MemberInformationScreen(),
          },

          onGenerateRoute: RouteManager.generateRoute,
        );
      },
    );
  }
}
