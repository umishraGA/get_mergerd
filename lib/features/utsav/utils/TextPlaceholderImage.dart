import 'package:flutter/material.dart';

/// A simple widget that displays a placeholder with text
/// Can be used as a temporary solution until real images are available
class TextPlaceholderImage extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  const TextPlaceholderImage({
    super.key,
    required this.width,
    required this.height,
    required this.text,
    this.backgroundColor = Colors.grey,
    this.textColor = Colors.white,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 48,
                color: textColor,
              ),
            if (icon != null) const SizedBox(height: 16),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Create a placeholder for the generic placeholder.png
  static Widget createGenericPlaceholder({
    double width = 300,
    double height = 300,
  }) {
    return TextPlaceholderImage(
      width: width,
      height: height,
      text: 'Placeholder Image',
      backgroundColor: Colors.grey.shade300,
      textColor: Colors.grey.shade700,
      icon: Icons.image,
    );
  }

  /// Create a banner placeholder
  static Widget createBannerPlaceholder({
    required double width,
    String text = 'Utsav Offer Banner',
  }) {
    return TextPlaceholderImage(
      width: width,
      height: width * 9 / 16, // 16:9 aspect ratio
      text: text,
      backgroundColor: Colors.orange.shade300,
      textColor: Colors.white,
      icon: Icons.local_offer,
    );
  }

  /// Create a category placeholder
  static Widget createCategoryPlaceholder({
    required double width,
    required double height,
    required String categoryName,
  }) {
    // Determine color and icon based on category name
    IconData categoryIcon = Icons.category;
    Color categoryColor = Colors.teal;

    final lowerCaseName = categoryName.toLowerCase();

    if (lowerCaseName.contains('apparel') ||
        lowerCaseName.contains('fashion')) {
      categoryIcon = Icons.shopping_bag;
      categoryColor = Colors.blue.shade700;
    } else if (lowerCaseName.contains('ayurvedic') ||
        lowerCaseName.contains('medicine')) {
      categoryIcon = Icons.healing;
      categoryColor = Colors.green.shade700;
    } else if (lowerCaseName.contains('food') ||
        lowerCaseName.contains('beverage')) {
      categoryIcon = Icons.restaurant;
      categoryColor = Colors.orange.shade700;
    }

    return TextPlaceholderImage(
      width: width,
      height: height,
      text: categoryName,
      backgroundColor: categoryColor,
      textColor: Colors.white,
      icon: categoryIcon,
    );
  }
}
