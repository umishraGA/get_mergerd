import 'package:flutter/material.dart';

import '../screens/all_categories_screen.dart';
import '../screens/category_levels_screen.dart';
import '../screens/coin_history_screen.dart';
import '../screens/coin_management_screen.dart';
import '../screens/countdown_screen.dart';
import '../screens/enhanced_quiz_screen.dart';
import '../screens/fun_learn_screen.dart';
import '../screens/game_rules_screen.dart';
import '../screens/guess_word_screen.dart';
import '../screens/leaderboard_screen.dart';
import '../screens/multiple_choice_quiz_screen.dart';
import '../screens/quiz_screen.dart';
import '../screens/true_false_screen.dart';

class QuizRoutes {
  static const String main = '/quiz';
  static const String category = '/quiz/category';
  static const String categoryLevels = '/quiz/category/levels';
  static const String gameRules = '/quiz/game-rules';
  static const String countdown = '/quiz/countdown';
  static const String multipleChoice = '/quiz/multiple-choice';
  static const String enhancedQuiz = '/quiz/enhanced';
  static const String funLearn = '/quiz/fun-learn';
  static const String trueFalse = '/quiz/true-false';
  static const String guessWord = '/quiz/guess-word';
  static const String leaderboard = '/quiz/leaderboard';
  static const String coinHistory = '/quiz/coin-history';
  static const String coinManagement = '/quiz/coin-management';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case main:
        return MaterialPageRoute(builder: (_) => const QuizScreen());
      case category:
        return MaterialPageRoute(builder: (_) => const AllCategoriesScreen());
      case categoryLevels:
        if (settings.arguments is String) {
          return MaterialPageRoute(
            builder: (_) => CategoryLevelsScreen(
              categoryName: settings.arguments as String,
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const CategoryLevelsScreen(categoryName: 'General'),
        );
      case gameRules:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => GameRulesScreen(
              categoryName: args['categoryName'] as String,
              level: args['level'] as int,
              onContinue: args['onContinue'] as VoidCallback,
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => GameRulesScreen(
            categoryName: 'General',
            level: 1,
            onContinue: () {},
          ),
        );
      case countdown:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => CountdownScreen(
              categoryName: args['categoryName'] as String,
              level: args['level'] as int,
              onCountdownComplete: args['onCountdownComplete'] as VoidCallback,
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => CountdownScreen(
            categoryName: 'General',
            level: 1,
            onCountdownComplete: () {},
          ),
        );
      case multipleChoice:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => MultipleChoiceQuizScreen(
              categoryName: args['categoryName'] as String,
              level: args['level'] as int,
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const MultipleChoiceQuizScreen(
            categoryName: 'General',
            level: 1,
          ),
        );
      case enhancedQuiz:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => EnhancedQuizScreen(
              categoryName: args['categoryName'] as String,
              level: args['level'] as int,
              quizType:
                  args['quizType'] as QuizType? ?? QuizType.multipleChoice,
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const EnhancedQuizScreen(
            categoryName: 'General',
            level: 1,
          ),
        );
      case funLearn:
        return MaterialPageRoute(builder: (_) => const FunLearnScreen());
      case trueFalse:
        return MaterialPageRoute(builder: (_) => const TrueFalseScreen());
      case guessWord:
        return MaterialPageRoute(builder: (_) => const GuessWordScreen());
      case leaderboard:
        return MaterialPageRoute(builder: (_) => const LeaderboardScreen());
      case coinHistory:
        return MaterialPageRoute(builder: (_) => const CoinHistoryScreen());
      case coinManagement:
        return MaterialPageRoute(builder: (_) => const CoinManagementScreen());
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
