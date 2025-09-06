import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:myapp/common/navigation/custom_bottom_nav_bar.dart';
import '../../../listings/views/bannercorousal_hinduism.dart';
import '../controller/Hinduism_controller.dart';
import '../widgets/AudioPlayer.dart';
import 'aarti_chalisa_screen.dart';
import 'articles_screen.dart';
import 'festival_screen.dart';
import 'live_darshan_screen.dart';
import 'panchang_details_screen.dart';
import 'temples_screen.dart';

class HinduismScreen extends StatefulWidget {
  final String? bannerImage;

  const HinduismScreen({super.key, this.bannerImage});

  @override
  State<HinduismScreen> createState() => _HinduismScreenState();
}

class _HinduismScreenState extends State<HinduismScreen> {
  final HinduismController hinduismController = Get.put(HinduismController());

  String formatTitle(String text) {
    if (text.isEmpty) return text;
    return text
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isEmpty ? word : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  /// --- IMAGE HANDLER ---
  Widget _buildImageWidget(String? imageUrl, double height,
      {double? width, BoxFit fit = BoxFit.cover, double borderRadius = 0}) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildPlaceholderWithIcon(Icons.image_not_supported, "No Image",
          height: height, width: width, borderRadius: borderRadius);
    }

    // Convert unsupported formats to JPG
    String optimizedUrl = imageUrl;
    if (imageUrl.endsWith('.avif') || imageUrl.endsWith('.webp')) {
      optimizedUrl = imageUrl.replaceAll(RegExp(r'\.(avif|webp)$'), '.jpg');
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: optimizedUrl,
        height: height,
        width: width ?? double.infinity,
        fit: fit,
        placeholder: (context, url) => _buildShimmerEffect(height, width),
        errorWidget: (context, url, error) =>
            _buildPlaceholderWithIcon(Icons.broken_image, "Failed to load",
                height: height, width: width, borderRadius: borderRadius),
      ),
    );
  }

  /// --- SHIMMER EFFECT ---
  Widget _buildShimmerEffect(double height, [double? width]) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        color: Colors.white,
      ),
    );
  }

  /// --- PLACEHOLDER WITH ICON ---
  Widget _buildPlaceholderWithIcon(IconData icon, String text,
      {double height = 140, double? width, double borderRadius = 0}) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          colors: [Colors.indigo.shade400, Colors.purple.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// --- SKELETON LOADER ---
  Widget _buildSkeletonLoader({double? height, double? width, double radius = 8}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  Widget _buildBannerSkeleton() => _buildSkeletonLoader(height: 280, width: double.infinity, radius: 0);

  Widget _buildFeatureGridSkeleton() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.9,
        mainAxisSpacing: 16,
        crossAxisSpacing: 8,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Column(
          children: [
            _buildSkeletonLoader(height: 90, width: 90, radius: 12),
            const SizedBox(height: 8),
            _buildSkeletonLoader(height: 16, width: 80, radius: 4),
          ],
        );
      },
    );
  }

  /// --- FEATURE CARD ---
  Widget _buildFeatureGridCard(String title, String imageUrl, BuildContext context,
      {VoidCallback? onTap, double? itemWidth}) {
    final double containerSize = itemWidth != null ? itemWidth * 0.85 : 90;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
              color: const Color(0xFFFEE7AA),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _buildImageWidget(imageUrl, containerSize, width: containerSize, borderRadius: 12),
          ),
          const SizedBox(height: 6),
          Container(
            width: containerSize,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              formatTitle(title),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                fontFamily: 'FacebookSans',
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// --- NAVIGATION LOGIC ---
  void _navigateToFeaturePage(BuildContext context, String featureName) {
    switch (featureName.toLowerCase()) {
      case 'temple':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const TemplesScreen()));
        break;
      case 'aarti':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AartiChalisaScreen()));
        break;
      case 'dharmik_gyaan':
      case 'articles':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ArticlesScreen()));
        break;
      case 'live_darshan':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const LiveDarshanScreen()));
        break;
      case 'festival':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const FestivalScreen()));
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$featureName page is coming soon!'), duration: const Duration(seconds: 2)),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: CustomScrollView(
        slivers: [
          /// --- APPBAR & BANNER ---
          SliverAppBar(
            expandedHeight: 230,
            pinned: true,
             backgroundColor: const Color(0xFFFDBB45),
            flexibleSpace: FlexibleSpaceBar(
              background: Obx(() {
                if (hinduismController.isLoading.value) return _buildBannerSkeleton();

                final imageUrl = hinduismController.bannerImage['mobile_image']?.toString();
                return _buildImageWidget(imageUrl, 280, fit: BoxFit.cover);
              }),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios_new, color: Colors.red, size: 18),
                ),
              ),
            ),
            title: const Text('Hinduism', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20)),
            // actions: const [
            //   Padding(
            //     padding: EdgeInsets.only(right: 16.0),
            //     child: CircleAvatar(backgroundImage: AssetImage('assets/images/profile_pic.png')),
            //   ),
            // ],
          ),

          /// --- BODY CONTENT ---
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 AudioPlayerWidget(),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Text('Featured', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Obx(() {
                    if (hinduismController.isLoading.value) {
                      return SizedBox(height: 220, child: _buildFeatureGridSkeleton());
                    }

                    final featureData = hinduismController.featuredList;
                    if (featureData.isEmpty) {
                      return Container(
                        height: 150,
                        alignment: Alignment.center,
                        child: Text('No featured items available', style: TextStyle(color: Colors.grey[600])),
                      );
                    }

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final itemWidth = constraints.maxWidth / 3;
                        final aspectRatio = itemWidth / (itemWidth + 16);

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: aspectRatio,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0,
                          ),
                          itemCount: featureData.length,
                          itemBuilder: (context, index) {
                            final feature = featureData[index] as Map<String, dynamic>;
                            final rawTitle = (feature['name'] ?? 'No Title').toString();
                            final title = rawTitle.isNotEmpty
                                ? rawTitle[0].toUpperCase() + rawTitle.substring(1).toLowerCase()
                                : 'No title';
                            final imageUrl = (feature['mobile_image'] ?? '').toString();

                            return _buildFeatureGridCard(
                              title,
                              imageUrl,
                              context,
                              itemWidth: itemWidth,
                              onTap: () => _navigateToFeaturePage(context, feature['name']?.toString() ?? ''),
                            );
                          },
                        );
                      },
                    );
                  }),
                ),

                /// --- AD BANNERS ---
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 16, 10, 0),
                  child: Obx(() {
                    if (hinduismController.isLoading.value) {
                      return _buildSkeletonLoader(height: isTablet ? 280 : 160, width: double.infinity, radius: 8);
                    }

                    final adSliderImages = hinduismController.adSliderList
                        .map<String>((item) => item['image']?.toString() ?? '')
                        .where((url) => url.isNotEmpty)
                        .toList();

                    if (adSliderImages.isEmpty) {
                      return Container(
                        height: isTablet ? 280 : 160,
                        color: Colors.grey[100],
                        alignment: Alignment.center,
                        child: Text('No banners available', style: TextStyle(color: Colors.grey[600])),
                      );
                    }

                    return BannerCarousel(imageUrls: adSliderImages, height: isTablet ? 280 : 160);
                  }),
                ),

                /// --- FOOTER TEXT ---
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Bless', style: TextStyle(color: Colors.grey, fontSize: 32, fontWeight: FontWeight.bold)),
                      const Text('Yourself!', style: TextStyle(color: Colors.grey, fontSize: 32, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Designed with divine blessings in India.',
                          style: TextStyle(color: Colors.grey.withOpacity(0.7), fontSize: 14)),
                      const SizedBox(height: 40),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: CustomBottomNavBar(
          selectedIndex: 1,
          onItemTapped: (index) {
            if (index != 1) Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
