import 'package:flutter/material.dart';
import 'package:myapp/features/common/widgets/BannerCorousal.dart';
import 'package:myapp/features/common/widgets/TopAppBarCustom.dart';

import '../models/UtsavCategory.dart';
import '../utils/UtsavSetup.dart';
import '../widgets/UtsavCategoryCard.dart';
import 'UtsavCategoryPage.dart';

class UtsavPage extends StatefulWidget {
  const UtsavPage({super.key});

  @override
  State<UtsavPage> createState() => _UtsavPageState();
}

class _UtsavPageState extends State<UtsavPage> {
  // Controller for banner page view
  late final PageController _bannerController;
  // Active banner index for dots indicator
  final int _activeBannerIndex = 0;
  // Flag to track if assets were checked
  bool _assetsChecked = false;

  // Sample categories - you'll replace the image paths later
  final List<UtsavCategory> categories = [
    const UtsavCategory(
      id: '1',
      name: 'Apparel & Fashion',
      imagePath: 'assets/images/utsav/categories/apparel.png',
    ),
    const UtsavCategory(
      id: '2',
      name: 'Ayuvedic & Medicines',
      imagePath: 'assets/images/utsav/categories/ayurvedic.png',
    ),
    const UtsavCategory(
      id: '3',
      name: 'Food & Beverages',
      imagePath: 'assets/images/utsav/categories/food.png',
    ),
    const UtsavCategory(
      id: '4',
      name: 'Apparel & Fashion',
      imagePath: 'assets/images/utsav/categories/apparel.png',
    ),
    const UtsavCategory(
      id: '5',
      name: 'Ayuvedic & Medicines',
      imagePath: 'assets/images/utsav/categories/ayurvedic.png',
    ),
    const UtsavCategory(
      id: '6',
      name: 'Food & Beverages',
      imagePath: 'assets/images/utsav/categories/food.png',
    ),
    const UtsavCategory(
      id: '7',
      name: 'Apparel & Fashion',
      imagePath: 'assets/images/utsav/categories/apparel.png',
    ),
    const UtsavCategory(
      id: '8',
      name: 'Food & Beverages',
      imagePath: 'assets/images/utsav/categories/food.png',
    ),
  ];

  // Sample offer banners - you'll replace the image paths later

  @override
  void initState() {
    super.initState();
    // Initialize banner controller with viewport fraction
    _bannerController = PageController(
      viewportFraction:
          0.8, // Smaller value to show more of adjacent banners on both sides
      initialPage: 1000, // Start at a large number for infinite effect
    );
    // Run asset check after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUtsavAssets();
    });
  }

  void _checkUtsavAssets() {
    if (!_assetsChecked) {
      UtsavSetup.ensureUtsavSetup();
      setState(() {
        _assetsChecked = true;
      });
    }
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      appBar: null,
      body: RefreshIndicator(
        onRefresh: () async {
          // Pull-to-refresh implementation would go here
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom header with search
              const TopAppBarCustom(
                color: Color(0xFFFFCA28),
                textColor: Colors.black,
                subTitleColor: Colors.black,
              ),

              // Banner carousel
              // _buildBannerCarousel(),

              Bannercorousal(
                height: isTablet ? 280 : 160,
              ),

              // Popular categories
              _buildPopularCategories(),

              // Categories grid
              _buildCategoriesGrid(),

              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopularCategories() {
    return const Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 10.0,
      ),
      child: Text(
        'All Utsav Categories',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return UtsavCategoryCard(
            category: categories[index],
            onTap: () {
              // Navigate to category detail page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UtsavCategoryPage(
                    category: categories[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
