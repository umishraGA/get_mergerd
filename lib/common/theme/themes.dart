import 'package:flutter/material.dart';

class AppThemes {
  static const List<Color> themeColors = [
    Color(0xFF6750A4), // Purple
    Color(0xFF006C51), // Green
    Color(0xFF0061A4), // Blue
    Color(0xFFEF3340), // Red - 
    Color(0xFF006874), // Teal
    Color(0xFFFFC0CB), // Pink
  ];

  static const List<String> themeNames = [
    'Purple',
    'Green',
    'Blue',
    'Red',
    'Teal',
    'Pink',
  ];

  static final List<ThemeData> lightThemes = [
    // Purple Theme
    ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: themeColors[0],
        brightness: Brightness.light,
      ),
      fontFamily: 'FacebookSans',
    ),
    // Green Theme
    ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: themeColors[1],
        brightness: Brightness.light,
      ),
      fontFamily: 'FacebookSans',
    ),
    // Blue Theme
    ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: themeColors[2],
        brightness: Brightness.light,
      ),
      fontFamily: 'FacebookSans',
    ),
    // Red Theme - Updated to match the social media app
    ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: const Color(0xFFEF3340), // Main red color from the app
        onPrimary: Colors.white,
        secondary: const Color(0xFF4A89DC), // Blue color from the app icons
        onSecondary: Colors.white,
        error: const Color(0xFFBA1A1A),
        onError: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black,
        surfaceContainerHighest:
            const Color(0xFFF5F5F5), // Light gray for cards
        onSurfaceVariant: Colors.black87,
        outline: Colors.grey.shade300,
        shadow: Colors.black.withOpacity(0.1),
        inverseSurface: Colors.black,
        onInverseSurface: Colors.white,
        inversePrimary: const Color(0xFFFFB4AB),
        surfaceTint: Colors.transparent,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFEF3340),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: Color(0xFFEF3340),
        unselectedLabelColor: Colors.grey,
        indicatorColor: Color(0xFFEF3340),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFFEF3340),
        unselectedItemColor: Colors.grey,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFEF3340),
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF3340)),
        ),
      ),
      fontFamily: 'FacebookSans',
    ),
    // Teal Theme
    ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: themeColors[4],
        brightness: Brightness.light,
      ),
      fontFamily: 'FacebookSans',
    ),
    // Pink Theme
    ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: themeColors[5],
        brightness: Brightness.light,
      ),
      fontFamily: 'FacebookSans',
    ),
  ];

  static final List<ThemeData> darkThemes = [
    // Purple Theme
    ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: themeColors[0],
        brightness: Brightness.dark,
      ),
      fontFamily: 'FacebookSans',
    ),
    // Green Theme
    ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: themeColors[1],
        brightness: Brightness.dark,
      ),
      fontFamily: 'FacebookSans',
    ),
    // Blue Theme
    ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: themeColors[2],
        brightness: Brightness.dark,
      ),
      fontFamily: 'FacebookSans',
    ),
    // Red Theme - Updated to match the social media app
    ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: const Color(0xFFEF3340), // Main red color from the app
        onPrimary: Colors.white,
        secondary: const Color(0xFF4A89DC), // Blue color from the app icons
        onSecondary: Colors.white,
        error: const Color(0xFFFFB4AB),
        onError: Colors.black,
        surface: const Color(0xFF2A2A2A),
        onSurface: Colors.white,
        surfaceContainerHighest: const Color(0xFF3A3A3A),
        onSurfaceVariant: Colors.white70,
        outline: Colors.grey.shade700,
        shadow: Colors.black.withOpacity(0.3),
        inverseSurface: Colors.white,
        onInverseSurface: Colors.black,
        inversePrimary: const Color(0xFFEF3340),
        surfaceTint: Colors.transparent,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFEF3340),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: Color(0xFFEF3340),
        unselectedLabelColor: Colors.grey,
        indicatorColor: Color(0xFFEF3340),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF2A2A2A),
        selectedItemColor: Color(0xFFEF3340),
        unselectedItemColor: Colors.grey,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFEF3340),
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF3A3A3A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF3340)),
        ),
      ),
      fontFamily: 'FacebookSans',
    ),
    // Teal Theme
    ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: themeColors[4],
        brightness: Brightness.dark,
      ),
      fontFamily: 'FacebookSans',
    ),
    // Pink Theme
    ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: themeColors[5],
        brightness: Brightness.dark,
      ),
      fontFamily: 'FacebookSans',
    ),
  ];
}
