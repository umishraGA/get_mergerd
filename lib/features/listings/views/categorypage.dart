import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:get/get.dart';
import 'package:myapp/features/common/widgets/BannerCorousal.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/common/widgets/TopAppBarCustom.dart';
import '../controller/categorycontroller.dart'; // Your controller
import '../widgets/RequestQuoteForm.dart';

class ListingsPageTest extends StatefulWidget {
  const ListingsPageTest({super.key});

  @override
  State<ListingsPageTest> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPageTest> {
  final CategoryControllerTest controller = Get.put(CategoryControllerTest());

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopAppBarCustom(isVisibleSearchBar: false),
            Bannercorousal(
              height: isTablet ? 280 : 160,
            ),
            Obx(() {
              if (controller.isLoading.value) return _buildSkeletonLoading();
              if (controller.currentCategories.isEmpty) return _buildNoCategoriesFound();
              return _buildMainCategoriesGrid();
            }),
            const SizedBox(height: 10),
            const CommonDivider(),
            const RequestQuoteForm(),
            const CommonDivider(),
            _buildBusinessPromotionBanner(),
          ],
        ),
      ),
    );
  }

  /// Format category name properly
  String formatName(String name) {
    return name
        .split('_')
        .map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
        .join(' ');
  }

  Widget _buildMainCategoriesGrid() {
    int crossAxisCount = 3;
    int rowCount = (controller.currentCategories.length / crossAxisCount).ceil();
    double width = MediaQuery.of(context).size.width;
    double spacing = 16;
    double itemWidth = (width - (crossAxisCount + 1) * spacing) / crossAxisCount;
    double itemHeight = itemWidth * 1.2;

    return SizedBox(
      height: rowCount * itemHeight + (rowCount - 1) * spacing,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(spacing),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: itemWidth / itemHeight,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
        ),
        itemCount: controller.currentCategories.length,
        itemBuilder: (context, index) {
          final category = controller.currentCategories[index];
          return InkWell(
            onTap: () => controller.navigateToSubcategoryPage(context, category),
            borderRadius: BorderRadius.circular(12),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: _buildCategoryImage(category.bannerImage),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Center(
                        child: Text(
                          formatName(category.name),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
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

  Widget _buildCategoryImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return _fallbackImage();
    }

    // Solution 2: Convert AVIF to PNG/JPG if needed
    if (imageUrl.toLowerCase().endsWith(".avif")) {
      // Attempt to use AVIF package (Solution 1)
      return AvifImage.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _fallbackImage(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _loadingPlaceholder(loadingProgress);
        },
      );
    }

    // Normal JPG/PNG
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _fallbackImage(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _loadingPlaceholder(loadingProgress);
      },
    );
  }

  Widget _fallbackImage() {
    return Container(
      color: Colors.grey[200],
      child: const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
    );
  }

  Widget _loadingPlaceholder(ImageChunkEvent? loadingProgress) {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          value: loadingProgress?.expectedTotalBytes != null
              ? loadingProgress!.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
              : null,
        ),
      ),
    );
  }

  Widget _buildNoCategoriesFound() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('No Categories Found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[700])),
          const SizedBox(height: 8),
          Text('We couldn\'t find any categories at the moment.', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => controller.fetchCategories(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoading() {
    int crossAxisCount = 3;
    int itemCount = 6;
    double width = MediaQuery.of(context).size.width;
    double spacing = 16;
    double itemWidth = (width - (crossAxisCount + 1) * spacing) / crossAxisCount;
    double itemHeight = itemWidth * 1.2;

    return SizedBox(
      height: itemHeight * 2 + spacing, // Approx for 2 rows
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(spacing),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: itemWidth / itemHeight,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) => Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(color: Colors.grey[200]),
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
        fit: BoxFit.cover,
      ),
    );
  }
}
