import 'package:flutter/material.dart';

import '../routes/quiz_routes.dart';

class CategoryItem extends StatelessWidget {
  final String icon;
  final String name;
  final VoidCallback? onTap;

  const CategoryItem({
    super.key,
    required this.icon,
    required this.name,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return GestureDetector(
      onTap: onTap ??
          () {
            Navigator.pushNamed(
              context,
              QuizRoutes.categoryLevels,
              arguments: name,
            );
          },
      child: Container(
        width: isTablet ? 190 : 150,
        height: isTablet ? 260 : 170,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Stack(
          children: [
            // Image part (takes most of the space)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  icon,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: Icon(
                        getIconForCategory(name),
                        size: 60,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Name at the bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 15),
                alignment: Alignment.center,
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  IconData getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'healthcare':
        return Icons.health_and_safety;
      case 'electronics':
        return Icons.devices;
      case 'property':
        return Icons.home;
      default:
        return Icons.category;
    }
  }
}
