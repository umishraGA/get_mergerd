import 'package:flutter/material.dart';

import '../routes/quiz_routes.dart';
import '../screens/enhanced_quiz_screen.dart';
import '../widgets/TopAppBarQuiz.dart';
import '../widgets/quiz_dialog.dart';

class CategoryLevelsScreen extends StatelessWidget {
  final String categoryName;

  const CategoryLevelsScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF8F7AE8), // Purple background from screenshot
      body: Column(
        children: [
          // Custom app bar with category name
          TopAppBarQuiz(
            coins: "370",
            onBack: () => Navigator.of(context).pop(),
          ),

          // Scrollable list of levels
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Level 1 - Unlocked
                _buildLevelCard(
                  context: context,
                  level: 1,
                  questionCount: 5,
                  isLocked: false,
                  onTap: () {
                    // Navigate to game rules, then to the actual quiz
                    Navigator.pushNamed(
                      context,
                      QuizRoutes.gameRules,
                      arguments: {
                        'categoryName': categoryName,
                        'level': 1,
                        'onContinue': () {
                          // When Continue is pressed, show countdown screen
                          Navigator.pop(context); // Close the rules screen

                          // Navigate to countdown screen
                          Navigator.pushNamed(
                            context,
                            QuizRoutes.countdown,
                            arguments: {
                              'categoryName': categoryName,
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
                                    'categoryName': categoryName,
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

                const SizedBox(height: 16),

                // Level 2 - Locked
                _buildLevelCard(
                  context: context,
                  level: 2,
                  questionCount: 5,
                  isLocked: true,
                  onTap: () {
                    // Already handled in _buildLevelCard
                  },
                ),

                const SizedBox(height: 16),

                // Level 3 - Locked
                _buildLevelCard(
                  context: context,
                  level: 3,
                  questionCount: 5,
                  isLocked: true,
                  onTap: () {
                    // Already handled in _buildLevelCard
                  },
                ),

                const SizedBox(height: 16),

                // Level 4 - Locked
                _buildLevelCard(
                  context: context,
                  level: 4,
                  questionCount: 5,
                  isLocked: true,
                  onTap: () {
                    // Already handled in _buildLevelCard
                  },
                ),

                const SizedBox(height: 16),

                // Level 5 - Locked
                _buildLevelCard(
                  context: context,
                  level: 5,
                  questionCount: 5,
                  isLocked: true,
                  onTap: () {
                    // Already handled in _buildLevelCard
                  },
                ),

                const SizedBox(height: 16),

                // Level 6 - Locked
                _buildLevelCard(
                  context: context,
                  level: 6,
                  questionCount: 5,
                  isLocked: true,
                  onTap: () {
                    // Already handled in _buildLevelCard
                  },
                ),

                // Add some bottom padding
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard({
    required BuildContext context,
    required int level,
    required int questionCount,
    required bool isLocked,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isLocked
          ? () async {
              // Show level locked dialog
              final willUnlock = await QuizDialogs.showLevelLockedDialog(
                context,
                coinsToUnlock: 100,
              );

              if (willUnlock) {
                // Handle unlocking level with coins
                debugPrint('User chose to unlock Level $level with coins');
                // TODO: Implement actual coin-based unlocking
              }
            }
          : onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Level info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Level $level',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$questionCount Questions',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),

            // Lock icon for locked levels
            if (isLocked)
              Column(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'locked',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
