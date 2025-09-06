import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/features/common/widgets/BannerCorousal.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/common/widgets/TopAppBarCustom.dart';
import 'package:myapp/features/listings/views/EducationListingsPage.dart';

import '../controller/all_category_controller.dart';
import '../controller/test1.dart';
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
            // Categories section
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

              // Check if we're showing main categories or child categories
              bool isMainCategory = controller.breadcrumb.isEmpty;

              return isMainCategory
                  ? _buildGridView(controller)
                  : _buildListView(controller);
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

  Widget _buildGridView(CategoryControllerTest controller) {
    // Calculate height based on number of items
    int crossAxisCount = 3;
    int rowCount = (controller.currentCategories.length / crossAxisCount).ceil();
    double itemHeight = (MediaQuery.of(context).size.width - 56) / crossAxisCount / 0.8; // 56 = padding + spacing
    double gridHeight = (rowCount * itemHeight) + (rowCount - 1) * 12 + 32; // 12 = mainAxisSpacing, 32 = padding

    return Container(
      height: gridHeight,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(), // Disable GridView scrolling
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
            onTap: () {},
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

  Widget _buildListView(CategoryControllerTest controller) {
    // Calculate height based on number of items
    double itemHeight = 72; // Approximate height of each ListTile with Card
    double listHeight = (controller.currentCategories.length * itemHeight) + 32; // 32 = padding

    return Container(
      height: listHeight,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(), // Disable ListView scrolling
        padding: EdgeInsets.all(16),
        itemCount: controller.currentCategories.length,
        itemBuilder: (context, index) {
          final category = controller.currentCategories[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: Colors.blue.withOpacity(0.1),
                child: Icon(
                  Icons.category,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
              title: Text(
                category.name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[600],
              ),
              onTap: () {},
            ),
          );
        },
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