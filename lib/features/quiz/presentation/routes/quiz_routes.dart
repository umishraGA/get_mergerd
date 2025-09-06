import 'package:flutter/material.dart';
import 'route_widget.dart';

class QuizRoutes {
  static const String main = '/quiz';
  static const String category = '/quiz/category';
  static const String subCategory = '/quiz/subCategory';
  static const String categoryLevels = '/quiz/category/levels';
  static const String gameRules = '/quiz/game-rules';
  static const String countdown = '/quiz/countdown';
  static const String multipleChoice = '/quiz/multiple-choice';
  static const String enhancedQuiz = '/quiz/enhanced';
  static const String quizQuestionAll = '/quiz/question/all';
  static const String funLearn = '/quiz/fun-learn';
  static const String trueFalse = '/quiz/true-false';
  static const String guessWord = '/quiz/guess-word';
  static const String leaderboard = '/quiz/leaderboard';
  static const String coinHistory = '/quiz/coin-history';
  static const String coinManagement = '/quiz/coin-management';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case main:
        return MaterialPageRoute(builder: (_) => const QuizHome());
      case category:
        return MaterialPageRoute(builder: (_) => const AllGameCategoryScreen());
      case subCategory:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => GameSubCategoryScreen(
              type: args['type'] as String,
              categoryId:  args['categoryId'] as String,
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => GameSubCategoryScreen(
            type: "zone",
            categoryId:  "",
          ),
        );
      case categoryLevels:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => GameCategoryLevelScreen(
              type: args['type'] as String, controller: args['gameLevelController'] as GameCategoryLevelController,
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => GameCategoryLevelScreen(
            controller: GameCategoryLevelController(),
              type: 'General'
          ),
        );
      case gameRules:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => GameRulesScreen(
              rules: args['rules'] as String,
              onContinue: args['onContinue'] as VoidCallback,
              level: args['level'] as int,
              type: args['type'] as String,
              levelId: args['levelId'] as String,
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => GameRulesScreen(
            rules: "",
            onContinue: () {}, level: 1, type: '', levelId: '',
          ),
        );
      case countdown:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => CountdownScreen(
              type: args['type'] as String,
              level: args['level'] as int,
              onCountdownComplete: args['onCountdownComplete'] as VoidCallback,
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => CountdownScreen(
            type: 'zone',
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
              quizType: args['quizType'] as QuizType? ?? QuizType.multipleChoice,
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const EnhancedQuizScreen(
            categoryName: 'General',
            level: 1,
          ),
        );
        case quizQuestionAll:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => QuizQuestionScreen(
              type: args['type'] as String,
              level: args['level'] as int,
              levelId: args['levelId'] as String,
              quizType: decodeQuizType(args['type'] as String),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const QuizQuestionScreen(
            type: "zone",
            level: 1,
            levelId: "",
            quizType: QuizType.multipleChoice,
          ),
        );
      case funLearn:
        return MaterialPageRoute(builder: (_) => const FunCategoriesScreen());
        // return MaterialPageRoute(builder: (_) => const FunLearnScreen());
      case trueFalse:
        return MaterialPageRoute(builder: (_) => const TrueFalseGameScreen());
        // return MaterialPageRoute(builder: (_) => const TrueFalseScreen());
      case guessWord:
        return MaterialPageRoute(builder: (_) => const WordGameScreen());
        // return MaterialPageRoute(builder: (_) => const GuessWordScreen());
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

QuizType decodeQuizType(String name) {
  switch (name) {
    case "zone":
      return QuizType.multipleChoice;
    case "true":
      return QuizType.trueFalse;
    case "guess":
      return QuizType.wordGuess;
    default:
      return QuizType.multipleChoice; // fallback
  }
}
