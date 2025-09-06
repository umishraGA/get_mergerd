import 'package:cached_network_image/cached_network_image.dart' show CachedNetworkImage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/features/common/widgets/BannerCorousal.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';
import 'package:shimmer/shimmer.dart';
import '../controller/aarti_controller.dart';
import 'detail_aarti_page.dart';
// make sure this is correct path

class AartiChalisaScreen extends StatefulWidget {
  const AartiChalisaScreen({super.key});

  @override
  State<AartiChalisaScreen> createState() => _AartiChalisaScreenState();
}

class _AartiChalisaScreenState extends State<AartiChalisaScreen> {
  final AartiController controller = Get.put(AartiController()); // Inject controller

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(title: 'Aarti & Chalisa'),

            Expanded(
              child: SingleChildScrollView(
                controller: controller.scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bannercorousal(
                      imagePaths: [
                        'assets/images/spiritual/ram_navmi.png',
                        'assets/images/spiritual/ram_navmi.png',
                        'assets/images/spiritual/ram_navmi.png',
                      ],
                      height: isTablet ? 280 : 160,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    const SizedBox(height: 24),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final itemWidth = (constraints.maxWidth - 32) / 3;
                          const aspectRatio = 0.75;

                          // ✅ Wrap only the GridView in Obx
                          return Obx(() => GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: aspectRatio,
                            ),
                            itemCount: controller.aartis.length,
                            itemBuilder: (context, index) {
                              final item = controller.aartis[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AartiDetailPage(
                                        title: item['title'].toString().toString() ?? '',
                                        imageUrl: item['web_image'].toString() ?? '',
                                        description: item['description'].toString() ?? '',
                                      ),
                                    ),
                                  );


                                },
                                child: _buildDeityCard(
                                  item['title'].toString(),
                                  item['mobile_image'].toString(),
                                  itemWidth: itemWidth,
                                ),
                              );
                            },
                          ));
                        },

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
  }


  Widget _buildDeityCard(String title, String? imagePath, {required double itemWidth}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: itemWidth,
          height: itemWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildImage(imagePath, itemWidth),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: itemWidth,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              formatTitle(title),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage(String? imageUrl, double size) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return _placeholderWithIcon(size, icon: Icons.image_not_supported);
    }

    String optimizedUrl = imageUrl;

    // Convert unsupported formats to JPG
    if (imageUrl.endsWith('.avif') || imageUrl.endsWith('.webp')) {
      optimizedUrl = imageUrl.replaceAll(RegExp(r'\.(avif|webp)$'), '.jpg');
    }

    return CachedNetworkImage(
      imageUrl: optimizedUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => _shimmerLoader(size),
      errorWidget: (context, url, error) => _placeholderWithIcon(size, icon: Icons.broken_image),
    );
  }

  Widget _shimmerLoader(double size) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: size,
        height: size,
        color: Colors.white,
      ),
    );
  }

  Widget _placeholderWithIcon(double size, {IconData icon = Icons.image}) {
    return Container(
      width: size,
      height: size,
      color: Colors.grey[200],
      child: Center(
        child: Icon(icon, size: size / 2, color: Colors.grey[400]),
      ),
    );
  }

// Helper function to format titles like "live_darshan" => "Live Darshan"
  String formatTitle(String title) {
    return title
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty
        ? word[0].toUpperCase() + word.substring(1).toLowerCase()
        : '')
        .join(' ');
  }
}
