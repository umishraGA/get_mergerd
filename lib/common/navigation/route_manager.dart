import 'package:flutter/material.dart';
import 'package:myapp/features/mainPage/MainPage.dart';
import 'package:myapp/features/postDetail/PostDetailPageWithZoom.dart';
import 'package:myapp/features/profile/screens/member_information_screen.dart';
import 'package:myapp/features/profile/screens/profile_page.dart';
import 'package:myapp/features/quiz/presentation/routes/quiz_routes.dart';
import 'package:myapp/features/spiritual/presentation/routes/spiritual_routes.dart';

class RouteManager {
  static const String mainPage = '/main';
  static const String postDetailPage = '/post_detail';
  static const String profilePage = '/profile';
  static const String memberInformationPage = '/member-information';
  // Add spiritual routes
  static const String spiritual = '/spiritual';
  static const String hinduism = '/spiritual/hinduism';
  // Add quiz routes
  static const String quiz = '/quiz';
  static const String quizCategory = '/quiz/category';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // First check if it's a spiritual route
    if (settings.name?.startsWith('/spiritual') == true) {
      return SpiritualRoutes.generateRoute(settings);
    }

    // Check if it's a quiz route
    if (settings.name?.startsWith('/quiz') == true) {
      return QuizRoutes.generateRoute(settings);
    }

    // Handle other app routes
    switch (settings.name) {
      case mainPage:
        return MaterialPageRoute(
          builder: (_) => const MainPage(),
        );

      case profilePage:
        return MaterialPageRoute(
          builder: (_) => const ProfilePage(),
        );

      case memberInformationPage:
        return MaterialPageRoute(
          builder: (_) => const MemberInformationScreen(),
        );

      case postDetailPage:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => PostDetailPageWithZoom(
              username: args['username'] as String,
              followers: args['followers'] as String,
              postImage: args['postImage'] as String,
              profileImage: args['profileImage'] as String,
              description: args['description'] as String,
              location: args['location'] as String,
              onBack: args['onBack'] as VoidCallback,
            ),
          );
        }
        // Fallback if arguments are not provided correctly
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Invalid arguments for route ${settings.name}'),
            ),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
