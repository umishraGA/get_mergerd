import 'package:flutter/material.dart';
import 'package:myapp/common/navigation/route_manager.dart';

class TopAppBarQuiz extends StatelessWidget {
  const TopAppBarQuiz({
    super.key,
    this.onBack,
    this.coins = "370",
    this.title,
    this.useDarkTheme = false,
  });

  final VoidCallback? onBack;
  final String coins;
  final String? title;
  final bool useDarkTheme;

  @override
  Widget build(BuildContext context) {
    final Color textColor = useDarkTheme ? Colors.white : Colors.black;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16 +
            MediaQuery.of(context).padding.top, // Add status bar height padding
        bottom: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button and title
          Expanded(
            child: Row(
              children: [
                GestureDetector(
                  onTap: onBack ?? () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: textColor,
                    size: 24, // Slightly smaller
                  ),
                ),
                const SizedBox(width: 8), // Reduced spacing

                // Title with overflow handling
                Expanded(
                  child: Text(
                    title ?? "Quiz",
                    style: TextStyle(
                      fontSize:
                          screenWidth < 360 ? 20 : 22, // Adaptive font size
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                    overflow:
                        TextOverflow.ellipsis, // Handle overflow with ellipsis
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 4), // Small spacing between sections

          // Coin display and profile
          Row(
            mainAxisSize: MainAxisSize.min, // Only take needed space
            children: [
              // Coin counter - Now clickable
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/quiz/coin-management');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ), // Slightly smaller padding
                  decoration: BoxDecoration(
                    color: const Color(0xFF8F7AE8),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize:
                        MainAxisSize.min, // Important for proper sizing
                    children: [
                      // Gold coin icon
                      Container(
                        width: 20,
                        height: 20, // Slightly smaller
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFD700),
                        ),
                        child: const Icon(
                          Icons.star,
                          color: Colors.orangeAccent,
                          size: 14, // Smaller icon
                        ),
                      ),
                      const SizedBox(width: 4), // Less spacing
                      // Coin count
                      Text(
                        coins,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14, // Smaller text
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8), // Less spacing

              // Profile image
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RouteManager.profilePage);
                },
                child: const CircleAvatar(
                  radius: 18, // Slightly smaller
                  backgroundImage: AssetImage('assets/images/profile_pic.png'),
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
