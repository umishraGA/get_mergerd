import 'package:flutter/material.dart';
import 'package:myapp/features/common/widgets/BannerCorousal.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/common/widgets/TopAppBarCustom.dart';
import 'package:myapp/features/listings/views/EducationListingsPage.dart';

import '../models/Category.dart';
import '../models/sample_data.dart';
import '../widgets/CategoryCard.dart';
import '../widgets/RequestQuoteForm.dart';

class ListingsPage extends StatefulWidget {
  const ListingsPage({super.key});

  @override
  State<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  late List<Category> _categories;

  @override
  void initState() {
    super.initState();
    _categories = ListingsSampleData.getSampleCategories();
  }

  @override
  Widget build(BuildContext context) {
    // Get trending categories
    final trendingCategories =
        _categories.where((cat) => cat.isTrending).toList();

    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section with location and profile
            const TopAppBarCustom(),

            // Banner section
            Bannercorousal(
              height: isTablet ? 280 : 160,
            ),

            // All Categories section
            _buildCategoriesGrid('All Categories', _categories, isTablet),

            const CommonDivider(),
            // Trending Categories section
            const SizedBox(
              height: 10,
            ),
            _buildCategoriesGrid(
                'Trending Categories', trendingCategories, isTablet),

            const CommonDivider(),
            // Request quote form
            const RequestQuoteForm(),

            const CommonDivider(),
            // Business promotion banner
            _buildBusinessPromotionBanner(),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid(
      String title, List<Category> categories, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: isTablet ? 0.59 : 0.6,
            crossAxisSpacing: isTablet ? 20 : 10,
            mainAxisSpacing: isTablet ? 20 : 0,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return CategoryCard(
              category: categories[index],
              onTap: () => _onCategorySelected(categories[index]),
            );
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  void _onCategorySelected(Category category) {
    // Navigate to category details page when implemented
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EducationListingsPage(),
      ),
    );
  }

  Widget _buildBusinessPromotionBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Image.asset(
        'assets/images/listings/banner/chatbot_banner.png',
        width: double.infinity,
        fit: BoxFit.fill,
      ),
    );
  }
}
