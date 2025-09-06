import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/features/common/widgets/BannerCorousal.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/common/widgets/TopAppBarCustom.dart';
import '../controller/all_category_controller.dart';
import '../controller/categorycontroller.dart';
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isDesktop = size.width > 1024;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar
            const TopAppBarCustom(),

            // Banner section responsive
            Bannercorousal(
              height: isDesktop ? size.height * 0.35 : isTablet ? size.height * 0.28 : size.height * 0.2,
            ),

            // Categories
            Obx(() {
              if (controller.isLoading.value) {
                return SizedBox(
                  height: size.height * 0.25,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              if (controller.currentCategories.isEmpty) {
                return SizedBox(
                  height: size.height * 0.3,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.category, size: size.width * 0.15, color: Colors.grey),
                        SizedBox(height: size.height * 0.02),
                        Text('No categories available',
                            style: TextStyle(fontSize: isTablet ? 18 : 14)),
                        SizedBox(height: size.height * 0.02),
                        ElevatedButton(
                          onPressed: () => controller.fetchCategories(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              bool isMainCategory = controller.breadcrumb.isEmpty;

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                  vertical: size.height * 0.015,
                ),
                child: isMainCategory
                    ? _buildGridView(controller, size, isTablet, isDesktop)
                    : _buildListView(controller, size, isTablet),
              );
            }),

            const SizedBox(height: 10),
            const CommonDivider(),

            // Request Quote form
            const RequestQuoteForm(),

            const CommonDivider(),

            // Business banner
            _buildBusinessPromotionBanner(size),

            SizedBox(height: size.height * 0.1),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessPromotionBanner(Size size) {
    return Container(
      margin: EdgeInsets.all(size.width * 0.04),
      child: Image.asset(
        'assets/images/listings/banner/chatbot_banner.png',
        width: double.infinity,
        height: size.height * 0.18,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildGridView(CategoryControllerTest controller, Size size, bool isTablet, bool isDesktop) {
    int crossAxisCount = isDesktop ? 5 : isTablet ? 4 : 3;
    double childAspectRatio = isDesktop ? 1 : isTablet ? 0.9 : 0.8;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.all(size.width * 0.04),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: size.width * 0.03,
        mainAxisSpacing: size.height * 0.02,
      ),
      itemCount: controller.currentCategories.length,
      itemBuilder: (context, index) {
        final category = controller.currentCategories[index];
        return InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    padding: EdgeInsets.all(size.width * 0.02),
                    child: Center(
                      child: Text(
                        category.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: isTablet ? 14 : 12,
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
    );
  }

  Widget _buildListView(CategoryControllerTest controller, Size size, bool isTablet) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.all(size.width * 0.04),
      itemCount: controller.currentCategories.length,
      itemBuilder: (context, index) {
        final category = controller.currentCategories[index];
        return Card(
          elevation: 4,
          margin: EdgeInsets.only(bottom: size.height * 0.012),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: size.width * 0.04,
              vertical: size.height * 0.01,
            ),
            leading: CircleAvatar(
              radius: isTablet ? 22 : 18,
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: Icon(Icons.category, color: Colors.blue, size: isTablet ? 22 : 18),
            ),
            title: Text(
              category.name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isTablet ? 16 : 14,
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: isTablet ? 18 : 14, color: Colors.grey[600]),
            onTap: () {},
          ),
        );
      },
    );
  }

  Widget _buildCategoryImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[200],
          child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey[400]),
        ),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: progress.expectedTotalBytes != null
                  ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    }
    return Container(
      color: Colors.grey[200],
      child: const Icon(Icons.category, size: 40, color: Colors.grey),
    );
  }
}
