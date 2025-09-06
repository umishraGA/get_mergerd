import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/common/enum/enum.dart';
import 'package:myapp/features/quiz/presentation/routes/route_widget.dart';

import '../../controller/game_category_level_controller.dart';
import '../../routes/quiz_routes.dart';
import '../category_level_card.dart';
import '../../widgets/TopAppBarQuiz.dart';
import '../../widgets/quiz_dialog.dart';

class GameCategoryLevelScreen extends StatelessWidget {
  final String type;
  final GameCategoryLevelController controller;
  const GameCategoryLevelScreen({super.key, required this.type, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8F7AE8),
      body: Column(
        children: [
          // Custom app bar with category name
          TopAppBarQuiz(
            coins: "370",
            onBack: () => Navigator.of(context).pop(),
          ),

          // Scrollable list of levels
          Expanded(
            child: Obx(() {
              switch (controller.status.value) {
                case ApiStatus.initial:
                case ApiStatus.loading:
                // Show shimmer
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: 10,
                    itemBuilder: (context, index) => const CategoryLevelCardShimmer(),
                  );
                case ApiStatus.success:
                // Show actual categories
                  return ListView.builder(
                    itemCount: controller.categoriesLevelData.length,
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      var data = controller.categoriesLevelData[index];
                      return CategoryLevelCard(
                        questionCount: data.questionCount ?? 0,
                        level: data.level ?? 0,
                        purchaseCoin: data.entryFee,
                        isLocked: data.levelUnlocked,
                        onTap: (){
                          if(data.levelUnlocked){
                            Navigator.pushNamed(
                              context,
                              QuizRoutes.gameRules,
                              arguments: {
                                'rules': data.terms ?? "",
                                'level': data.level ?? 1,
                                'levelId': data.id ?? "",
                                'type': type,
                                'onContinue': () {
                                  // When Continue is pressed, show countdown screen
                                  Navigator.pop(context); // Close the rules screen

                                  // Navigate to countdown screen
                                  Navigator.pushNamed(
                                    context,
                                    QuizRoutes.countdown,
                                    arguments: {
                                      'type': type,
                                      'level': data.level ?? 1,
                                      'onCountdownComplete': () {
                                        // When countdown is done, navigate to actual quiz
                                        Navigator.pop(context); // Close countdown screen

                                        // Navigate to multiple choice quiz
                                        Navigator.pushNamed(
                                          context,
                                          QuizRoutes.quizQuestionAll,
                                          arguments: {
                                            'type': type,
                                            'level': data.level ?? 1,
                                            'levelId': data.id ?? "",
                                            // 'levelId': QuizType.multipleChoice,
                                          },
                                        );
                                      },
                                    },
                                  );
                                },
                              },
                            );
                            // Get.to(()=> GameRulesScreen(rules: data.terms ?? "", levelId: data.id ?? "", type: type, level: data.level ?? 1, onContinue: (){}));
                          }
                          // Navigator.pushNamed(
                          //   context,
                          //   QuizRoutes.gameRules,
                          //   arguments: {
                          //     'categoryLevelData': controller.categoriesLevelData.value,
                          //     'onContinue': () {
                          //       // When Continue is pressed, show countdown screen
                          //       Navigator.pop(context); // Close the rules screen
                          //
                          //       // Navigate to countdown screen
                          //       Navigator.pushNamed(
                          //         context,
                          //         QuizRoutes.countdown,
                          //         arguments: {
                          //           'categoryName': "General",
                          //           'level': 1,
                          //           'onCountdownComplete': () {
                          //             // When countdown is done, navigate to actual quiz
                          //             Navigator.pop(
                          //                 context); // Close countdown screen
                          //
                          //             // Navigate to multiple choice quiz
                          //             Navigator.pushNamed(
                          //               context,
                          //               QuizRoutes.enhancedQuiz,
                          //               arguments: {
                          //                 'categoryName': "General",
                          //                 'level': 1,
                          //                 'quizType': QuizType.multipleChoice,
                          //               },
                          //             );
                          //           },
                          //         },
                          //       );
                          //     },
                          //   },
                          // );
                        },
                      );
                    },
                  );
                case ApiStatus.error:
                // Show error UI
                  return const Center(child: Text('Failed to load categories'));
              }
            }),
          ),
        ],
      ),
    );
  }
}



class CategoryLevelsScreen extends StatelessWidget {
  final String categoryName;

  const CategoryLevelsScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8F7AE8),
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
                                Navigator.pop(context); // Close countdown screen

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
