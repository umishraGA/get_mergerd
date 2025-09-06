import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:just_audio/just_audio.dart';
import 'package:myapp/common/navigation/custom_bottom_nav_bar.dart';
import '../../../listings/views/bannercorousal_hinduism.dart';
import '../controller/Hinduism_controller.dart';
import '../widgets/AudioPlayer.dart';

class ChristianityScreen extends StatefulWidget {
  final String? bannerImage;

  const ChristianityScreen({
    super.key,
    this.bannerImage,
  });

  @override
  State<ChristianityScreen> createState() => _HinduismScreenState();
}

class _HinduismScreenState extends State<ChristianityScreen> {
  final HinduismController hinduismController =Get.put(HinduismController());
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

  @override
  void dispose() {
    _ramPlayer.dispose();
    _hanumanPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String type) async {
    try {
      // Stop any currently playing audio
      if (_isPlaying) {
        await _ramPlayer.stop();
        await _hanumanPlayer.stop();
      }

      // Play the selected audio
      final player = type == 'Ram' ? _ramPlayer : _hanumanPlayer;
      await player.seek(Duration.zero);
      await player.play();
      setState(() {
        _isPlaying = true;
      });
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  Future<void> _stopAudio() async {
    try {
      await _ramPlayer.stop();
      await _hanumanPlayer.stop();
      setState(() {
        _isPlaying = false;
      });
    } catch (e) {
      debugPrint('Error stopping audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true, // Make body extend behind bottom navigation bar
      body: CustomScrollView(
        slivers: [
          // App Bar with background
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: const Color(0xFFFDBB45), // Golden background
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background image with temple graphics
                  Obx(() {
                    final imageUrl = hinduismController.bannerImage['mobile_image']?.toString();

                    if (imageUrl == null || imageUrl.isEmpty) {
                      return const Center(child: Text("No image available"));
                    }

                    return Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Text("Image failed to load"));
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
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
                    onTap: () {
                      Navigator.pop(context);
                    },
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
                      // Container(
                      //   width: 50,
                      //   height: 50,
                      //   decoration: const BoxDecoration(
                      //     color: Color(0xFFF5F5F5),
                      //     borderRadius: BorderRadius.horizontal(
                      //       right: Radius.circular(8),
                      //     ),
                      //   ),
                      //   child: const Center(
                      //     child: Icon(
                      //       Icons.search,
                      //       color: Colors.grey,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Audio Player Section
                 AudioPlayerWidget(),

                // Featured section

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
                      return const Center(child: CircularProgressIndicator());
                    }

                    final featureData = hinduismController.featuredList;
                    print("llllllllllllllllllllllllllll ${featureData.length}");
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
                            final imageUrl = (feature['mobile_image'] ??
                                'https://via.placeholder.com/100'); // fallback image
                            return _buildFeatureGridCard(
                              title,
                              imageUrl.toString(),
                              context,
                              itemWidth: itemWidth,
                              onTap: (){},
                            );
                          },
                        );
                      },
                    );
                  }),
                ),


                // Spiritual Information section
                //             const Padding(
                //               padding: EdgeInsets.fromLTRB(16, 10, 16, 16),
                //               child: Text(
                //                 'Spiritual Information',
                //                 style: TextStyle(
                //                   fontSize: 20,
                //                   fontWeight: FontWeight.w500,
                //                 ),
                //               ),
                //             ),
                //             Padding(
                //               padding: const EdgeInsets.symmetric(horizontal: 16),
                //               child: InkWell(
                //                 onTap: () {
                //                   Navigator.push(
                //                     context,
                //                     MaterialPageRoute(
                //                       builder: (context) => const PanchangDetailsScreen(),
                //                     ),
                //                   );
                //                 },
                //                 child: Container(
                //                   decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(16),
                //                   ),
                //                   child: Image.asset(
                //                     'assets/images/spiritual/mandala_pattern.png',
                //                     fit: BoxFit.fitHeight,
                //                     width: double.infinity,
                //                   ),
                //                 ),
                //               ),
                //             ),

                // Vishu banner
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 16, 10, 0),
                  child: Obx(() {
                    final adSliderImages = hinduismController.adSliderList
                        .map<String>((item) => item['image']?.toString() ?? '')
                        .where((url) => url.isNotEmpty)
                        .toList();

                    return BannerCarousel(
                      imageUrls: adSliderImages.isNotEmpty
                          ? adSliderImages
                          : ['https://via.placeholder.com/300x150'], // Fallback if empty
                      height: isTablet ? 280 : 160,
                    );
                  }),
                ),

                // Upcoming Pujas section
                // const Padding(
                //   padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
                //   child: Text(
                //     'Upcoming Pujas',
                //     style: TextStyle(
                //       fontSize: 20,
                //       fontWeight: FontWeight.w500,
                //     ),
                //   ),
                // ),
                //
                // Bannercorousal(
                //   imagePaths: const [
                //     'assets/images/spiritual/ram_navmi.png',
                //     'assets/images/spiritual/ram_navmi.png',
                //     'assets/images/spiritual/ram_navmi.png',
                //   ],
                //   height: isTablet ? 280 : 160,
                //   // viewportFraction: 0.93,
                //   margin: const EdgeInsets.symmetric(horizontal: 0),
                // ),

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
          selectedIndex: 1, // Selected index 1 for Spiritual tab
          onItemTapped: (index) {
            // Handle navigation between tabs
            if (index != 1) {
              // Only navigate if not already on this tab
              Navigator.pop(context);
              // Additional navigation logic could be added here
            }
          },
        ),
      ),
    );
  }

  Widget _buildFeatureGridCard(
      String title, String imagePath, BuildContext context,
      {VoidCallback? onTap, double? itemWidth})
  {
    // Default container size if itemWidth not provided
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
              color: const Color(0xFFFEE7AA), // Light golden background
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
              child: Image.network(
                imagePath, // Make sure this is a valid image URL
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
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

