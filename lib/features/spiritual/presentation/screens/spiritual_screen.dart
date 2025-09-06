import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controller/choose_your_religion_controller.dart';
import 'package:myapp/features/common/widgets/TopAppBarCustom.dart';

class SpiritualScreen extends StatefulWidget {
  const SpiritualScreen({super.key});

  @override
  State<SpiritualScreen> createState() => _SpiritualScreenState();
}

class _SpiritualScreenState extends State<SpiritualScreen> {
  final SpiritualController controller = Get.put(SpiritualController());

  int _getCrossAxisCount(double width) {
    if (width >= 1024) return 4;
    if (width >= 768) return 3;
    return 2;
  }

  double _getPadding(double width) {
    if (width >= 1024) return 24;
    if (width >= 768) return 20;
    return 16;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = _getCrossAxisCount(width);
    final padding = _getPadding(width);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          const TopAppBarCustom(isVisibleSearchBar: false),
          const SizedBox(height: 10),
          const Text(
            'Choose Your Spiritual Path',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return _buildLoadingGrid(crossAxisCount, padding);
              }

              if (controller.religionList.isEmpty) {
                return const Center(
                  child: Text(
                    'No spiritual paths available',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return GridView.builder(
                padding: EdgeInsets.all(padding),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: controller.religionList.length,
                itemBuilder: (context, index) {
                  final religion = controller.religionList[index];
                  final name = religion['name']?.toString() ?? '';
                  final imageUrl = religion['icon']?['mobile_image']?.toString();

                  return _ReligionCard(
                    title: name.toUpperCase(),
                    imageUrl: imageUrl,
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/spiritual/${name.toLowerCase()}',
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingGrid(int crossAxisCount, double padding) {
    return GridView.builder(
      padding: EdgeInsets.all(padding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6, // Skeleton placeholders
      itemBuilder: (context, index) => _buildSkeletonCard(),
    );
  }

  Widget _buildSkeletonCard() {
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 6,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey.shade300,
                  Colors.grey.shade400,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReligionCard extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final VoidCallback onTap;

  const _ReligionCard({
    required this.title,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 6,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildBackground(),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 8,
                  right: 8,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      String optimizedUrl = imageUrl!;

      // Convert unsupported formats to JPG for older devices
      if (imageUrl!.endsWith('.avif') || imageUrl!.endsWith('.webp')) {
        optimizedUrl = imageUrl!.replaceAll(RegExp(r'\.(avif|webp)$'), '.jpg');
      }

      return CachedNetworkImage(
        imageUrl: optimizedUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildShimmerEffect(),
        errorWidget: (context, url, error) => _buildPlaceholderWithIcon(
          Icons.broken_image,
          "Failed to load",
        ),
      );
    }

    return _buildPlaceholderWithIcon(Icons.auto_awesome, "Spiritual Path");
  }

  Widget _buildShimmerEffect() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade300,
            Colors.grey.shade200,
            Colors.grey.shade300,
          ],
          stops: const [0.1, 0.5, 0.9],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }

  Widget _buildPlaceholderWithIcon(IconData icon, String message) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.shade400,
            Colors.purple.shade400,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.white.withOpacity(0.8),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
