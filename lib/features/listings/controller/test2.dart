import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/features/common/widgets/BannerCorousal.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/common/widgets/TopAppBarCustom.dart';

import '../controller/all_category_controller.dart';
import '../controller/test1.dart'; // Your updated controller
import '../widgets/RequestQuoteForm.dart';

class ListingsPageTest extends StatefulWidget {
  const ListingsPageTest({super.key});

  @override
  State<ListingsPageTest> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPageTest> {
  final CategoryController categoryController = Get.put(CategoryController());
  final CategoryControllerTest controller = Get.put(CategoryControllerTest());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

            // Main Categories section
            Obx(() {
              if (controller.isLoading.value) {
                return Container(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (controller.currentCategories.isEmpty) {
                return Container(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.category, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No categories available'),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => controller.fetchCategories(),
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Show main categories in grid view
              return _buildMainCategoriesGrid();
            }),

            const SizedBox(height: 10),
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

  Widget _buildMainCategoriesGrid() {
    // Calculate height based on number of items
    int crossAxisCount = 3;
    int rowCount = (controller.currentCategories.length / crossAxisCount).ceil();
    double itemHeight = (MediaQuery.of(context).size.width - 56) / crossAxisCount / 0.8;
    double gridHeight = (rowCount * itemHeight) + (rowCount - 1) * 12 + 32;

    return Container(
      height: gridHeight,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.8,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: controller.currentCategories.length,
        itemBuilder: (context, index) {
          final category = controller.currentCategories[index];
          return InkWell(
            onTap: () => controller.navigateToSubcategoryPage(context, category),
            borderRadius: BorderRadius.circular(12),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: _buildCategoryImage(category.bannerImage),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            category.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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

  Widget _buildCategoryImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: Icon(
              Icons.image_not_supported,
              size: 40,
              color: Colors.grey[400],
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
      );
    }
    return Container(
      color: Colors.grey[200],
      child: Icon(
        Icons.category,
        size: 40,
        color: Colors.grey[400],
      ),
    );
  }
}