import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shimmer/shimmer.dart';
import 'package:myapp/common/navigation/custom_bottom_nav_bar.dart';
import 'package:myapp/features/spiritual/presentation/screens/panchang_details_screen.dart';
import 'package:myapp/features/spiritual/presentation/screens/temples_screen.dart';
import '../../../listings/views/bannercorousal_hinduism.dart';
import '../controller/Hinduism_controller.dart';
import '../widgets/AudioPlayer.dart';
import 'aarti_chalisa_screen.dart';
import 'articles_screen.dart';
import 'festival_screen.dart';
import 'live_darshan_screen.dart';

class HinduismScreen extends StatefulWidget {
  final String? bannerImage;

  const HinduismScreen({
    super.key,
    this.bannerImage,
  });

  @override
  State<HinduismScreen> createState() => _HinduismScreenState();
}

class _HinduismScreenState extends State<HinduismScreen> {
  final HinduismController hinduismController = Get.put(HinduismController());
  final AudioPlayer _ramPlayer = AudioPlayer();
  final AudioPlayer _hanumanPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      await _ramPlayer.setAsset('assets/audio/shriram_jairam.mp3');
      await _hanumanPlayer.setAsset('assets/audio/hanumanchalisa.mp3');
    } catch (e) {
      debugPrint('Error initializing audio: $e');
    }
  }

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

  Widget _buildBannerSkeleton() {
    return _buildSkeletonLoader(height: 280, width: double.infinity, radius: 0);
  }

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

  Widget _buildBannerCarouselSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: _buildSkeletonLoader(height: 160, width: double.infinity, radius: 8),
    );
  }

  void _navigateToFeaturePage(BuildContext context, String featureName) {
    switch (featureName.toLowerCase()) {
      case 'temple':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TemplesScreen()),
        );
        break;
      case 'aarti':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AartiChalisaScreen()),
        );
        break;
      case 'dharmik_gyaan':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ArticlesScreen()),
        );
        break;
      case 'live_darshan':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LiveDarshanScreen()),
        );
        break;
      case 'festival':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FestivalScreen()),
        );
        break;
      case 'articles':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ArticlesScreen()),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$featureName page is coming soon!'),
            duration: const Duration(seconds: 2),
          ),
        );
        break;
    }
  }

  @override
  void dispose() {
    _ramPlayer.dispose();
    _hanumanPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: const Color(0xFFFDBB45),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Obx(() {
                    if (hinduismController.isLoading.value) {
                      return _buildBannerSkeleton();
                    }

                    final imageUrl = hinduismController.bannerImage['mobile_image']?.toString();

                    if (imageUrl == null || imageUrl.isEmpty) {
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Icon(Icons.broken_image, size: 50, color: Colors.grey[400]),
                        ),
                      );
                    }

                    return Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Center(
                            child: Icon(Icons.error_outline, size: 50, color: Colors.grey[400]),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return _buildBannerSkeleton();
                      },
                    );
                  }),
                ],
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
            title: const Text(
              'Hinduism',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/profile_pic.png'),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                          child: TextField(
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              hintText: 'Search for temple',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 15,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AudioPlayerWidget(),

                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Text(
                    'Featured',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Obx(() {
                    if (hinduismController.isLoading.value) {
                      return SizedBox(
                        height: 220,
                        child: _buildFeatureGridSkeleton(),
                      );
                    }

                    final featureData = hinduismController.featuredList;
                    if (featureData.isEmpty) {
                      return Container(
                        height: 150,
                        alignment: Alignment.center,
                        child: Text(
                          'No featured items available',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      );
                    }

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final itemWidth = (constraints.maxWidth) / 3;
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
                              onTap: () {
                                _navigateToFeaturePage(context, feature['name']?.toString() ?? '');
                              },
                            );
                          },
                        );
                      },
                    );
                  }),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 16, 10, 0),
                  child: Obx(() {
                    if (hinduismController.isLoading.value) {
                      return _buildBannerCarouselSkeleton();
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
                        child: Text(
                          'No banners available',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      );
                    }

                    return BannerCarousel(
                      imageUrls: adSliderImages,
                      height: isTablet ? 280 : 160,
                    );
                  }),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bless',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const Text(
                        'Yourself!',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Designed with divine blessings in India.',
                        style: TextStyle(
                          color: Colors.grey.withOpacity(0.7),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.start,
                      ),
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
            if (index != 1) {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildFeatureGridCard(
      String title, String imagePath, BuildContext context,
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imagePath.isEmpty
                  ? Icon(Icons.image_not_supported, size: 40, color: Colors.grey[400])
                  : Image.network(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.broken_image, size: 40, color: Colors.grey[400]);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildSkeletonLoader(height: containerSize, width: containerSize);
                },
              ),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: containerSize,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
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
}