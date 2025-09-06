import 'package:myapp/features/auth/screens/sign_up_screen.dart';

import 'main_widget.dart';

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
    // AuthHelper.clearAuthData();
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
              home: const SplashScreen(),
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
            ),
          ),
        );
      },
    );
  }
}
