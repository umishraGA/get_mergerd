import 'package:flutter/material.dart';

import '../models/Category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final Function()? onTap;
  final bool isVertical;
  final double? itemWidth;

  const CategoryCard({
    super.key,
    required this.category,
    this.onTap,
    this.isVertical = false,
    this.itemWidth,
  });

  @override
  Widget build(BuildContext context) {
    // Default container size if itemWidth not provided
    final double containerSize = itemWidth != null ? itemWidth! * 0.85 : 90;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: isTablet ? 0.7 : 0.8,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFFEE7AA), // Light golden background
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  category.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade100,
                      child: Icon(
                        Icons.image_not_supported_rounded,
                        color: Colors.grey.shade300,
                        size: 32,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            // width: containerSize,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              category.name,
              style: TextStyle(
                fontSize: isTablet ? 18 : 13,
                fontWeight: FontWeight.w500,
                fontFamily: 'FacebookSans',
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
