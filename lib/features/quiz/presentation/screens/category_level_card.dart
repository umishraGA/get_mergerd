import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../widgets/quiz_dialog.dart';

class CategoryLevelCard extends StatelessWidget {
  final int level;
  final int questionCount;
  final int? purchaseCoin;
  final bool isLocked;
  final VoidCallback onTap;
  const CategoryLevelCard({super.key, required this.level, required this.questionCount, required this.isLocked, required this.onTap, this.purchaseCoin});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLocked
          ? onTap : () async {
        // Show level locked dialog
        final willUnlock = await QuizDialogs.showLevelLockedDialog(
          context,
          coinsToUnlock: purchaseCoin ?? 100,
        );

        if (willUnlock) {
          // Handle unlocking level with coins
          debugPrint('User chose to unlock Level $level with coins');
          // TODO: Implement actual coin-based unlocking
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 10),
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
            if (!isLocked)
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

class CategoryLevelCardShimmer extends StatelessWidget {
  const CategoryLevelCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Shimmer for level info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 22,
                  color: Colors.grey,
                ),
                const SizedBox(height: 6),
                Container(
                  width: 80,
                  height: 16,
                  color: Colors.grey,
                ),
              ],
            ),
            // Shimmer for lock icon
            Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 40,
                  height: 14,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



