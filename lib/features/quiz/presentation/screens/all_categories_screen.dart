import 'package:flutter/material.dart';
import 'package:myapp/features/quiz/presentation/widgets/TopAppBarQuiz.dart';

import '../routes/quiz_routes.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Pre-load quiz images to ensure they're available
    _preloadImages(context);

    return Scaffold(
      backgroundColor:
          const Color(0xFFF2C94C), // Yellow background from screenshot
      body: Column(children: [
        const TopAppBarQuiz(),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(16),
            childAspectRatio: 0.8,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildCategoryCard(
                title: 'Construction',
                image: 'assets/images/quiz/quiz_zone.png',
                color: const Color(0xFFFFFAE5), // Light yellow
              ),
              _buildCategoryCard(
                title: 'Agriculture',
                image: 'assets/images/quiz/quiz_zone.png',
                color: const Color(0xFFFEEBDF), // Light orange
              ),
              _buildCategoryCard(
                title: 'Furniture',
                image: 'assets/images/quiz/quiz_zone.png',
                color: const Color(0xFFF2F0FF), // Light purple
              ),
              _buildCategoryCard(
                title: 'Electronics',
                image: 'assets/images/quiz/quiz_zone.png',
                color: const Color(0xFFE0F5E6), // Light green
              ),
              _buildCategoryCard(
                title: 'Automobile',
                image: 'assets/images/quiz/quiz_zone.png',
                color: const Color(0xFFE0F2FF), // Light blue
              ),
              _buildCategoryCard(
                title: 'Fashion',
                image: 'assets/images/quiz/quiz_zone.png',
                color: const Color(0xFFFEE5E5), // Light pink
              ),
              _buildCategoryCard(
                title: 'Social Science',
                image: 'assets/images/quiz/quiz_zone.png',
                color: const Color(0xFFE0F2FF), // Light blue
              ),
              _buildCategoryCard(
                title: 'Physics',
                image: 'assets/images/quiz/quiz_zone.png',
                color: const Color(0xFFFFF4E4), // Light cream
              ),
            ],
          ),
        )
      ]),
    );
  }

  // Pre-load images to ensure they're properly cached
  void _preloadImages(BuildContext context) {
    // This forces Flutter to load the image into memory
    precacheImage(
        const AssetImage('assets/images/quiz/quiz_zone.png'), context);
  }

  Widget _buildCategoryCard({
    required String title,
    required String image,
    required Color color,
  }) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            QuizRoutes.categoryLevels,
            arguments: title,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              // Background image
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading image: $error');
                      // Fallback icon if image not found
                      return Center(
                        child: Icon(
                          _getCategoryIcon(title),
                          size: 80,
                          color: Colors.black54,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Category name
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'construction':
        return Icons.domain;
      case 'agriculture':
        return Icons.agriculture;
      case 'furniture':
        return Icons.chair;
      case 'electronics':
        return Icons.devices;
      case 'automobile':
        return Icons.directions_car;
      case 'fashion':
        return Icons.shopping_bag;
      case 'social science':
        return Icons.people;
      case 'physics':
        return Icons.science;
      default:
        return Icons.category;
    }
  }
}
