import 'package:flutter/material.dart';

class QuizZoneItem extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String description;
  final Color backgroundColor;
  final Widget iconWidget;

  const QuizZoneItem({
    super.key,
    required this.onTap,
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.iconWidget,
  });

  /// Factory method to create a standard quiz zone item
  /// with consistent styling but custom navigation logic
  static QuizZoneItem standard({
    required String title,
    required String description,
    required VoidCallback onTap,
    required IconData icon,
    Color backgroundColor = const Color(0xFF8F7AE8),
    Color iconColor = Colors.white,
  }) {
    return QuizZoneItem(
      title: title,
      description: description,
      onTap: onTap,
      backgroundColor: backgroundColor,
      iconWidget: Icon(
        icon,
        size: 36,
        color: iconColor,
      ),
    );
  }

  /// Factory method to create a quiz zone item with an image
  static QuizZoneItem withImage({
    required String title,
    required String description,
    required VoidCallback onTap,
    required String imagePath,
    Color backgroundColor = const Color(0xFF8F7AE8),
    double imageSize = 120,
  }) {
    return QuizZoneItem(
      title: title,
      description: description,
      onTap: onTap,
      backgroundColor: backgroundColor,
      iconWidget: Image.asset(
        imagePath,
        width: imageSize,
        height: imageSize,
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(child: iconWidget),
              ),
              const SizedBox(height: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
Example usage:

// Example 1: Using the standard factory with icons
GridView.count(
  crossAxisCount: 2,
  children: [
    QuizZoneItem.standard(
      title: 'General Knowledge',
      description: 'Test your general knowledge',
      icon: Icons.lightbulb,
      onTap: () {
        // Custom navigation logic
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EnhancedQuizScreen(
              categoryName: 'General Knowledge',
              level: 1,
            ),
          ),
        );
      },
    ),
    QuizZoneItem.standard(
      title: 'Math',
      description: 'Challenge your math skills',
      icon: Icons.calculate,
      backgroundColor: Colors.blue,
      onTap: () {
        // Different navigation logic
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => QuizLevelScreen(category: 'Math'),
          ),
        );
      },
    ),
  ],
),

// Example 2: Using the image factory
QuizZoneItem.withImage(
  title: 'Sports Quiz',
  description: 'Test your sports knowledge',
  imagePath: 'assets/images/sports_icon.png',
  backgroundColor: Colors.green,
  onTap: () {
    // Show dialog before starting quiz
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ready for Sports Quiz?'),
        content: Text('This quiz contains 10 questions about sports.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EnhancedQuizScreen(
                    categoryName: 'Sports',
                    level: 1,
                  ),
                ),
              );
            },
            child: Text('Start'),
          ),
        ],
      ),
    );
  },
),
*/
