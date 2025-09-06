import 'package:flutter/material.dart';

import '../widgets/TopAppBarQuiz.dart';
import '../widgets/category_item.dart';

class QuizCategoryScreen extends StatelessWidget {
  const QuizCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
            kToolbarHeight + MediaQuery.of(context).padding.top),
        child: const TopAppBarQuiz(coins: "370"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: 9, // Example number of categories
        itemBuilder: (context, index) {
          // Sample categories
          final categories = [
            {'name': 'Healthcare', 'icon': 'assets/images/healthcare.png'},
            {'name': 'Electronics', 'icon': 'assets/images/electronics.png'},
            {'name': 'Property', 'icon': 'assets/images/property.png'},
            {'name': 'Education', 'icon': 'assets/images/education.png'},
            {'name': 'Finance', 'icon': 'assets/images/finance.png'},
            {'name': 'Sports', 'icon': 'assets/images/sports.png'},
            {'name': 'Food', 'icon': 'assets/images/food.png'},
            {'name': 'Travel', 'icon': 'assets/images/travel.png'},
            {'name': 'Technology', 'icon': 'assets/images/technology.png'},
          ];

          if (index < categories.length) {
            return CategoryItem(
              icon: categories[index]['icon']!,
              name: categories[index]['name']!,
            );
          }

          return const CategoryItem(
            icon: 'assets/images/placeholder.png',
            name: 'Category',
          );
        },
      ),
    );
  }
}
