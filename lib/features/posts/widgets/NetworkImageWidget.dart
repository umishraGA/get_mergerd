import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';

/// A widget that handles network images with AVIF format detection and fallback
class NetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final String? heroTag;

  const NetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.heroTag,
  });

  bool _isAvifFormat(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    
    final path = uri.path.toLowerCase();
    final query = uri.query.toLowerCase();
    
    // Check file extension in path
    if (path.endsWith('.avif') || path.contains('.avif')) {
      return true;
    }
    
    // Check query parameters that might indicate AVIF format
    if (query.contains('format=avif') || query.contains('f=avif')) {
      return true;
    }
    
    // Check for CDN-style AVIF conversion
    if (query.contains('avif') && (query.contains('auto') || query.contains('format'))) {
      return true;
    }
    
    return false;
  }

  Widget _buildErrorWidget() {
    if (errorWidget != null) return errorWidget!;
    
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            size: 50,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 8),
          Text(
            _isAvifFormat(imageUrl) 
                ? 'AVIF format not supported'
                : 'Unable to load image',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    if (placeholder != null) return placeholder!;
    
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// Check if the given URL is an asset path
  bool _isAssetPath(String url) {
    return url.startsWith('assets/') || !url.contains('://');
  }

  @override
  Widget build(BuildContext context) {
    // Handle asset paths
    if (_isAssetPath(imageUrl)) {
      Widget assetImage = Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
      );

      // Wrap with Hero if heroTag is provided
      if (heroTag != null) {
        assetImage = Hero(
          tag: heroTag!,
          child: assetImage,
        );
      }

      return assetImage;
    }

    // For AVIF format, use AvifImage instead of regular Image
    if (_isAvifFormat(imageUrl)) {
      // Only log once per unique URL to avoid spam
      // debugPrint('NetworkImageWidget: Loading AVIF image: $imageUrl');
      Widget avifImage = Stack(
        children: [
          AvifImage.network(
            imageUrl,
            width: width,
            height: height,
            fit: fit,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return _buildPlaceholder();
            },
            errorBuilder: (context, error, stackTrace) {
              debugPrint('NetworkImageWidget: AVIF loading failed for $imageUrl: $error');
              // If AVIF fails, try loading as regular image with CachedNetworkImage
              return CachedNetworkImage(
                imageUrl: imageUrl,
                width: width,
                height: height,
                fit: fit,
                placeholder: (context, url) => _buildPlaceholder(),
                errorWidget: (context, url, error) => _buildErrorWidget(),
              );
            },
          ),
          // Small success indicator for AVIF
          // Positioned(
          //   top: 8,
          //   right: 8,
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          //     decoration: BoxDecoration(
          //       color: Colors.green.withOpacity(0.8),
          //       borderRadius: BorderRadius.circular(4),
          //     ),
          //     child: const Text(
          //       'AVIF',
          //       style: TextStyle(
          //         color: Colors.white,
          //         fontSize: 10,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      );

      // Wrap with Hero if heroTag is provided
      if (heroTag != null) {
        avifImage = Hero(
          tag: heroTag!,
          child: avifImage,
        );
      }

      return avifImage;
    }

    // For other formats, use normal CachedNetworkImage
    Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => _buildPlaceholder(),
      errorWidget: (context, url, error) => _buildErrorWidget(),
    );

    // Wrap with Hero if heroTag is provided
    if (heroTag != null) {
      image = Hero(
        tag: heroTag!,
        child: image,
      );
    }

    return image;
  }
}