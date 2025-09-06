import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/features/common/widgets/BannerCorousal.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/common/widgets/TopAppBarCustom.dart';

import '../../utsav/widgets/AppHeader.dart';
import '../controller/all_category_controller.dart';
import '../controller/categorycontroller.dart'; // Your updated controller
import '../widgets/RequestQuoteForm.dart';

class ListingsPageTest extends StatefulWidget {
  const ListingsPageTest({super.key});

  @override
  State<ListingsPageTest> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPageTest> {
  // final CategoryController categoryController = Get.put(CategoryController());
  final CategoryControllerTest controller = Get.put(CategoryControllerTest());

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section with location and profile
            const TopAppBarCustom(isVisibleSearchBar: false),

            // Banner section
            Bannercorousal(
              height: isTablet ? 280 : 160,
            ),

            // Main Categories section
            Obx(() {
              if (controller.isLoading.value) {
                return _buildSkeletonLoading();
              }

              if (controller.currentCategories.isEmpty) {
                return _buildNoCategoriesFound();
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

  /// ✅ Format category name properly
  String formatName(String name) {
    return name
        .split('_')
        .map((word) =>
    word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
        .join(' ');
  }

  Widget _buildMainCategoriesGrid() {
    int crossAxisCount = 3;
    int rowCount = (controller.currentCategories.length / crossAxisCount).ceil();
    double itemHeight =
        (MediaQuery.of(context).size.width - 56) / crossAxisCount / 0.8;
    double gridHeight = (rowCount * itemHeight) + (rowCount - 1) * 12 + 32;

    return SizedBox(
      height: gridHeight+25,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.8,
          crossAxisSpacing: 13,
          mainAxisSpacing: 14,
        ),
        itemCount: controller.currentCategories.length,
        itemBuilder: (context, index) {
          final category = controller.currentCategories[index];
          return InkWell(
            onTap: () =>
                controller.navigateToSubcategoryPage(context, category),
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
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: _buildCategoryImage(category.bannerImage),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Center(
                        child: Flexible(
                          child: Text(
                            formatName(category.name),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13, // ✅ fixed size
                            ),
                          ),
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

  Widget _buildNoCategoriesFound() {
    return _buildNoDataFound(
      icon: Icons.category_outlined,
      title: 'No Categories Found',
      description: 'We couldn\'t find any categories at the moment.',
      onRetry: () => controller.fetchCategories(),
    );
  }

  // Universal "No Data Found" widget that can be used for clinics, schools, shops, malls, etc.
  Widget _buildNoDataFound({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onRetry,
    String retryText = 'Try Again',
    List<Widget>? additionalActions,
  }) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue[50]!,
            Colors.white,
            Colors.grey[50]!,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon with background circle
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue[100]!.withOpacity(0.3),
            ),
            child: Icon(
              icon,
              size: 50,
              color: Colors.blue[600],
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.blue[800],
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 25),

          // Action buttons
          Column(
            children: [
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                ),
                child: Text(retryText),
              ),

              // Additional actions if provided
              if (additionalActions != null) ...[
                const SizedBox(height: 10),
                ...additionalActions,
              ],
            ],
          ),
        ],
      ),
    );
  }

  // Example usage for different types of data
  Widget _buildNoClinicsFound() {
    return _buildNoDataFound(
      icon: Icons.local_hospital,
      title: 'No Clinics Found',
      description: 'We couldn\'t find any clinics matching your search. '
          'Please try different filters or check back later.',
      onRetry: () {
        // Add retry logic for clinics
      },
      additionalActions: [
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            // Add action for help
          },
          child: Text(
            'Need help finding a clinic?',
            style: TextStyle(
              color: Colors.blue[600],
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoSchoolsFound() {
    return _buildNoDataFound(
      icon: Icons.school,
      title: 'No Schools Found',
      description: 'We couldn\'t find any schools in this area. '
          'Try expanding your search radius or different filters.',
      onRetry: () {
        // Add retry logic for schools
      },
      retryText: 'Search Again',
    );
  }

  Widget _buildNoShopsFound() {
    return _buildNoDataFound(
      icon: Icons.shopping_cart,
      title: 'No Shops Found',
      description: 'No shops match your current search criteria. '
          'Please try different keywords or categories.',
      onRetry: () {
        // Add retry logic for shops
      },
    );
  }

  Widget _buildNoMallsFound() {
    return _buildNoDataFound(
      icon: Icons.store_mall_directory,
      title: 'No Malls Found',
      description: 'We couldn\'t find any malls in your selected location. '
          'Try searching in a different area or check back later.',
      onRetry: () {
        // Add retry logic for malls
      },
      additionalActions: [
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () {
            // Add action to change location
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.blue[600],
            side: BorderSide(color: Colors.blue[300]!),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: const Text('Change Location'),
        ),
      ],
    );
  }

  Widget _buildSkeletonLoading() {
    int crossAxisCount = 3;
    int itemCount = 6; // Number of skeleton items to show

    return SizedBox(
      height: MediaQuery.of(context).size.width * 1.2, // Approximate height
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.8,
          crossAxisSpacing: 13,
          mainAxisSpacing: 14,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Card(
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
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Container(
                      color: Colors.grey[200],
                      child: const SkeletonLoading(width: double.infinity, height: double.infinity),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: SkeletonLoading(
                        width: MediaQuery.of(context).size.width / 4,
                        height: 16,
                        borderRadius: 4,
                      ),
                    ),
                  ),
                ),
              ],
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
      child: const Icon(
        Icons.category,
        size: 40,
        color: Colors.grey,
      ),
    );
  }
}

// Skeleton Loading Widget
class SkeletonLoading extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoading({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius = 0,
  }) : super(key: key);

  @override
  _SkeletonLoadingState createState() => _SkeletonLoadingState();
}

class _SkeletonLoadingState extends State<SkeletonLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = ColorTween(
      begin: Colors.grey[300],
      end: Colors.grey[100],
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: _animation.value,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      },
    );
  }
}