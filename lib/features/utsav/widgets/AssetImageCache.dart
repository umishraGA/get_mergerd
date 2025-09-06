import 'package:flutter/material.dart';

/// A widget that loads an asset image with caching
class AssetImageCache extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final ImageErrorWidgetBuilder? errorBuilder;

  const AssetImageCache({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: errorBuilder ??
          (context, error, stackTrace) {
            print('Error loading asset image: $assetPath - Error: $error');
            return Container(
              width: width,
              height: height,
              color: Colors.grey[300],
              child: const Center(
                child: Icon(
                  Icons.broken_image,
                  color: Colors.grey,
                  size: 40,
                ),
              ),
            );
          },
      // Use caching by not specifying cacheWidth/cacheHeight
    );
  }
}
