# Quiz Feature for Social Media App

This directory contains the implementation of a quiz feature that can be integrated into the main social media application. The feature includes various types of quizzes such as daily quizzes, fun comprehension quizzes, true/false questions, and word guessing games.

## Directory Structure

```
/features/quiz/
├── data/
│   └── models/
│       └── quiz_question.dart
├── presentation/
│   ├── routes/
│   │   └── quiz_routes.dart
│   ├── screens/
│   │   ├── quiz_screen.dart
│   │   ├── quiz_category_screen.dart
│   │   ├── daily_quiz_screen.dart
│   │   ├── fun_learn_screen.dart
│   │   ├── true_false_screen.dart
│   │   └── guess_word_screen.dart
│   └── widgets/
│       ├── category_item.dart
│       └── quiz_zone_item.dart
└── README.md
```

## Integration Guide

To integrate this quiz feature into the main application:

1. Add the quiz routes to your app's main routing system:

```dart
import 'features/quiz/presentation/routes/quiz_routes.dart';

// In your app's route generation function
Route<dynamic> generateRoute(RouteSettings settings) {
  if (settings.name?.startsWith('/quiz') == true) {
    return QuizRoutes.generateRoute(settings);
  }
  
  // Other routes for your app...
}
```

2. Add navigation to the quiz screen from your app's main menu or navigation drawer:

```dart
// Example of adding a menu item
ListTile(
  leading: const Icon(Icons.quiz),
  title: const Text('Quiz Zone'),
  onTap: () {
    Navigator.pushNamed(context, '/quiz');
  },
),
```

3. Make sure to add any necessary assets referenced in the quiz screens:
   - Create assets/images/quiz_banner.png
   - Add category icons like healthcare.png, electronics.png, etc.

## Customization

You can customize this feature by:

1. Updating the quiz categories in quiz_category_screen.dart
2. Adding real questions to the various quiz types
3. Integrating with a backend API to fetch questions dynamically
4. Adding a leaderboard or scoring system that connects with the user's profile
5. Adding more quiz types or modifying the existing ones

## Dependencies

This feature uses only the core Flutter SDK and does not require additional external packages.

## Models

The feature includes the following models for different types of quiz questions:

- `QuizQuestion` - For multiple-choice questions
- `TrueFalseQuestion` - For true/false statements
- `WordQuestion` - For word guessing games
- `ComprehensionPassage` - For reading comprehension quizzes

You can extend these models as needed for your specific use case. 