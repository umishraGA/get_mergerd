import 'package:flutter/material.dart';

import '../utils/PlaceholderGenerator.dart';
import 'AssetImageCache.dart';

class UtsavOfferBanner extends StatelessWidget {
  final String imagePath;

  const UtsavOfferBanner({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    // Debug print to verify banner path
    print('Building banner with image path: $imagePath');
    final isTablet = MediaQuery.of(context).size.width > 600;

    // Get screen size for placeholder dimensions
    final size = MediaQuery.of(context).size;
    final bannerWidth = size.width - 32; // Account for margins
    final bannerHeight =
        isTablet ? 270.0 : 170.0; //bannerWidth * 2.08; // 16:9 aspect ratio

    return Container(
      width: bannerWidth,
      height: bannerHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _buildBannerImage(bannerWidth, bannerHeight),
      ),
    );
  }

  Widget _buildBannerImage(double width, double height) {
    if (imagePath.startsWith('assets/')) {
      // Handle asset images
      return AssetImageCache(
        assetPath: imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading banner: $imagePath - Error: $error');
          return _buildPlaceholder(width, height);
        },
      );
    } else {
      // Handle non-asset images with placeholder
      print('Using placeholder for non-asset banner path: $imagePath');
      return _buildPlaceholder(width, height);
    }
  }

  Widget _buildPlaceholder(double width, double height) {
    return PlaceholderGenerator.offerBanner(
      width: width,
      height: height,
      text: 'OFFERS',
    );
  }
}
