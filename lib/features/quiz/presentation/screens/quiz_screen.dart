import 'package:flutter/material.dart';
import 'package:myapp/features/common/widgets/BannerCorousal.dart';
import 'package:myapp/features/quiz/presentation/routes/quiz_routes.dart';
import 'package:myapp/features/quiz/presentation/screens/enhanced_quiz_screen.dart';
import 'package:myapp/features/quiz/presentation/widgets/bottom_bar_for_quiz.dart';

import '../widgets/TopAppBarQuiz.dart';
import '../widgets/category_item.dart';
import '../widgets/quiz_zone_item.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Image with Quiz Zone Text
            Stack(
              children: [
                Image.asset('assets/images/quiz/quiz_zone.png'),
                const TopAppBarQuiz(coins: "370")
              ],
            ),
            // Game Categories
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Game Categories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, QuizRoutes.category);
                    },
                    child: Text(
                      'See all',
                      style: TextStyle(color: theme.colorScheme.secondary),
                    ),
                  ),
                ],
              ),
            ),

            // Categories Row
            SizedBox(
              height: isTablet ? 250 : 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 0),
                children: const [
                  CategoryItem(
                    icon: 'assets/images/quiz/quiz_zone.png',
                    name: 'Healthcare',
                  ),
                  CategoryItem(
                    icon: 'assets/images/quiz/quiz_zone.png',
                    name: 'Electronics',
                  ),
                  CategoryItem(
                    icon: 'assets/images/quiz/quiz_zone.png',
                    name: 'Property',
                  ),
                ],
              ),
            ),

            // Play Different Zone
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 16, 16, 16),
              child: Text(
                'Play Different Zone',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),

            // Quiz Zone Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.0,
                padding: const EdgeInsets.all(0),
                children: [
                  QuizZoneItem.withImage(
                    title: 'Daily Quiz',
                    description: 'Daily basic new quiz game',
                    imagePath: 'assets/images/quiz/question.png',
                    backgroundColor: const Color(0xFF4CAF50),
                    imageSize: isTablet ? 200 : 120,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        QuizRoutes.gameRules,
                        arguments: {
                          'categoryName': "Daily Quiz",
                          'level': 1,
                          'onContinue': () {
                            // When Continue is pressed, show countdown screen
                            Navigator.pop(context); // Close the rules screen

                            // Navigate to countdown screen
                            Navigator.pushNamed(
                              context,
                              QuizRoutes.countdown,
                              arguments: {
                                'categoryName': "Daily Quiz",
                                'level': 1,
                                'onCountdownComplete': () {
                                  // When countdown is done, navigate to actual quiz
                                  Navigator.pop(
                                      context); // Close countdown screen

                                  // Navigate to multiple choice quiz
                                  Navigator.pushNamed(
                                    context,
                                    QuizRoutes.enhancedQuiz,
                                    arguments: {
                                      'categoryName': "Daily Quiz",
                                      'level': 1,
                                      'quizType': QuizType.multipleChoice,
                                    },
                                  );
                                },
                              },
                            );
                          },
                        },
                      );
                    },
                  ),
                  QuizZoneItem.withImage(
                    onTap: () {
                      // Navigator.pushNamed(context, '/quiz/fun-learn');
                    },
                    title: 'Fun \'N\' Learn',
                    description: 'It\'s like a comprehension game',
                    backgroundColor: const Color(0xFFF9A825),
                    imageSize: isTablet ? 200 : 120,
                    imagePath: 'assets/images/quiz/funandlearn.png',
                  ),
                  QuizZoneItem.withImage(
                    onTap: () {
                      // Navigator.pushNamed(context, '/quiz/true-false');
                    },
                    title: 'True | False',
                    description: 'True | False Question',
                    backgroundColor: theme.colorScheme.primary,
                    imageSize: isTablet ? 200 : 120,
                    imagePath: 'assets/images/quiz/truefalse.png',
                  ),
                  QuizZoneItem.withImage(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        QuizRoutes.gameRules,
                        arguments: {
                          'categoryName': 'Guess The Word',
                          'level': 1,
                          'onContinue': () {
                            // When Continue is pressed, show countdown screen
                            Navigator.pop(context); // Close the rules screen

                            // Navigate to countdown screen
                            Navigator.pushNamed(
                              context,
                              QuizRoutes.countdown,
                              arguments: {
                                'categoryName': 'Guess The Word',
                                'level': 1,
                                'onCountdownComplete': () {
                                  // When countdown is done, navigate to word guess quiz
                                  Navigator.pop(
                                      context); // Close countdown screen

                                  // Navigate to word guess quiz
                                  Navigator.pushNamed(
                                    context,
                                    QuizRoutes.enhancedQuiz,
                                    arguments: {
                                      'categoryName': 'Guess The Word',
                                      'level': 1,
                                      'quizType': QuizType.wordGuess,
                                    },
                                  );
                                },
                              },
                            );
                          },
                        },
                      );
                    },
                    title: 'Guess The Word',
                    description: 'Fun vocabulary game',
                    backgroundColor: theme.colorScheme.secondary,
                    imageSize: isTablet ? 200 : 120,
                    imagePath: 'assets/images/quiz/guess the word.png',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Banner
            Bannercorousal(
              imagePaths: const [
                'assets/images/quiz/quiz_zone.png',
                'assets/images/quiz/quiz_zone.png',
                'assets/images/quiz/quiz_zone.png',
              ],
              height: isTablet ? 280 : 160,
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: BottomBarForQuiz(
        selectedIndex: 1, // Quiz tab
        onItemTapped: (index) {
          if (index == 1) {
            // Already on Quiz tab
            return;
          } else if (index == 0) {
            // Home tab - go back to main app
            Navigator.pop(context);
          } else if (index == 2) {
            // Coins tab - show coin history
            Navigator.pushNamed(context, '/quiz/coin-history');
          } else if (index == 3) {
            // Leaderboard
            Navigator.pushNamed(context, '/quiz/leaderboard');
          }
          // Handle other tabs as needed
        },
        hideAnimationController: null,
      ),
      extendBody: true,
    );
  }
}
