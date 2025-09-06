import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class EventGalleryGrid extends StatelessWidget {
  final List<Map<String, dynamic>> eventImages;
  final EdgeInsets padding;

  const EventGalleryGrid({
    super.key,
    required this.eventImages,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    // Extract image URLs from event images
    final List<String> imageUrls = eventImages.isNotEmpty
        ? eventImages
        .map((image) => image['url']?.toString() ?? '')
        .where((url) => url.isNotEmpty)
        .toList()
        : [
      'assets/images/events/featured_event_img.png',
    ];

    if (imageUrls.isEmpty) {
      return Center(
        child: Text(
          'No event images available',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
      );
    }

    return Padding(
      padding: padding,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: imageUrls.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildGalleryItem(
            imageUrls[index],
            index: index,
            context: context,
          );
        },
      ),
    );
  }

  Widget _buildGalleryItem(
      String imageUrl, {
        required int index,
        required BuildContext context,
      }) {
    // Handle .avif and .webp formats by converting to .jpg
    String finalUrl = imageUrl;
    if (imageUrl.endsWith('.avif') || imageUrl.endsWith('.webp')) {
      finalUrl = imageUrl.replaceAll(RegExp(r'\.(avif|webp)$'), '.jpg');
    }

    return GestureDetector(
      onTap: () {
        // Handle image tap - show full screen view
        _showFullScreenImage(context, finalUrl, index);
      },
      child: Hero(
        tag: 'event_gallery_$index',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: finalUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[300],
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl, int index) {
    // Get all image URLs for the fullscreen viewer
    final List<String> allImageUrls = eventImages.isNotEmpty
        ? eventImages
        .map((image) {
      String url = image['url']?.toString() ?? '';
      if (url.endsWith('.avif') || url.endsWith('.webp')) {
        url = url.replaceAll(RegExp(r'\.(avif|webp)$'), '.jpg');
      }
      return url;
    })
        .where((url) => url.isNotEmpty)
        .toList()
        : [
      'assets/images/events/featured_event_img.png',
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _EventFullScreenImageView(
          images: allImageUrls,
          initialIndex: index,
          heroTag: 'event_gallery_$index',
        ),
      ),
    );
  }
}

class _EventFullScreenImageView extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final String heroTag;

  const _EventFullScreenImageView({
    required this.images,
    required this.initialIndex,
    required this.heroTag,
  });

  @override
  State<_EventFullScreenImageView> createState() => _EventFullScreenImageViewState();
}

class _EventFullScreenImageViewState extends State<_EventFullScreenImageView>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late int _currentIndex;
  final Map<int, TransformationController> _transformationControllers = {};
  bool _isUIVisible = true;

  // Animation controller for smoother zooming
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    // Initialize transformation controllers for each image
    for (int i = 0; i < widget.images.length; i++) {
      _transformationControllers[i] = TransformationController();
    }

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animationController.addListener(() {
      if (_animation != null) {
        _transformationControllers[_currentIndex]?.value = _animation!.value;
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    // Dispose all transformation controllers
    for (var controller in _transformationControllers.values) {
      controller.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  // Reset zoom level with animation
  void _resetZoom() {
    final controller = _transformationControllers[_currentIndex];
    if (controller != null) {
      _animateMatrix(controller.value, Matrix4.identity());
    }
  }

  // Animate between two matrices
  void _animateMatrix(Matrix4 begin, Matrix4 end) {
    _animation = Matrix4Tween(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.reset();
    _animationController.forward();
  }

  // Toggle UI visibility
  void _toggleUIVisibility() {
    setState(() {
      _isUIVisible = !_isUIVisible;
    });
  }

  // Handle double tap with smooth animation
  void _handleDoubleTap(BuildContext context, int index) {
    final TransformationController controller =
    _transformationControllers[index]!;

    // Get the screen size
    final Size screenSize = MediaQuery.of(context).size;

    // Center point for zoom focus
    final Offset center = Offset(screenSize.width / 2, screenSize.height / 2);

    if (controller.value != Matrix4.identity()) {
      // If already zoomed in, animate back to identity
      _animateMatrix(controller.value, Matrix4.identity());
    } else {
      // Use a fixed reasonable zoom factor
      const double targetScale = 2.0;

      // Calculate the matrix for the zoomed state
      final Matrix4 endMatrix = Matrix4.identity()
        ..translate(
            -center.dx * (targetScale - 1), -center.dy * (targetScale - 1))
        ..scale(targetScale);

      // Animate to the zoomed state
      _animateMatrix(Matrix4.identity(), endMatrix);
    }
  }

  void _ensureImageInBounds(int index) {
    final TransformationController controller =
    _transformationControllers[index]!;
    final Matrix4 matrix = controller.value;

    // Don't do anything if not transformed
    if (matrix == Matrix4.identity()) return;

    // Get scale from the matrix
    final double scale = matrix.getMaxScaleOnAxis();

    // If the scale is less than 1.0, reset to identity
    if (scale < 1.0) {
      _animateMatrix(matrix, Matrix4.identity());
      return;
    }

    // Extract translation values
    final double translationX = matrix.getTranslation().x;
    final double translationY = matrix.getTranslation().y;

    // Size of the screen
    final Size screenSize = MediaQuery.of(context).size;

    // Calculate the size of the scaled image
    final double scaledWidth = screenSize.width * scale;
    final double scaledHeight = screenSize.height * scale;

    // Calculate how much the image can be translated
    // For width: if the scaled width is larger than screen, allow translation
    // up to the difference between scaled width and screen width
    final double maxTranslationX = (scaledWidth - screenSize.width) / 2;
    final double maxTranslationY = (scaledHeight - screenSize.height) / 2;

    // Calculate the bounds for allowed translations
    double minX = -maxTranslationX;
    double maxX = maxTranslationX;
    double minY = -maxTranslationY;
    double maxY = maxTranslationY;

    // If image is smaller than screen in either dimension, center it
    if (scaledWidth <= screenSize.width) {
      minX = 0;
      maxX = 0;
    }

    if (scaledHeight <= screenSize.height) {
      minY = 0;
      maxY = 0;
    }

    // Check if we need to adjust the translation
    bool needsAdjustment = false;
    double newTranslationX = translationX;
    double newTranslationY = translationY;

    if (translationX < minX) {
      newTranslationX = minX;
      needsAdjustment = true;
    } else if (translationX > maxX) {
      newTranslationX = maxX;
      needsAdjustment = true;
    }

    if (translationY < minY) {
      newTranslationY = minY;
      needsAdjustment = true;
    } else if (translationY > maxY) {
      newTranslationY = maxY;
      needsAdjustment = true;
    }

    // If we need to adjust, create a new matrix and animate to it
    if (needsAdjustment) {
      final Matrix4 adjustedMatrix = Matrix4.copy(matrix);
      adjustedMatrix
          .setTranslation(Vector3(newTranslationX, newTranslationY, 0));

      _animateMatrix(matrix, adjustedMatrix);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Full screen image with PageView for swiping
            PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                  // Reset zoom level when changing pages
                  _resetZoom();
                });
              },
              itemBuilder: (context, index) {
                // Make sure we have a controller for this index
                _transformationControllers[index] ??=
                    TransformationController();

                return GestureDetector(
                  onTap: _toggleUIVisibility,
                  onDoubleTap: () => _handleDoubleTap(context, index),
                  child: Hero(
                    tag: index == widget.initialIndex
                        ? widget.heroTag
                        : 'event_gallery_$index',
                    child: SizedBox.expand(
                      child: InteractiveViewer(
                        transformationController:
                        _transformationControllers[index],
                        minScale: 1.0,
                        maxScale: 2.0,
                        boundaryMargin: const EdgeInsets.all(0),
                        clipBehavior: Clip.hardEdge,
                        constrained: true,
                        panEnabled: true,
                        scaleEnabled: true,
                        onInteractionEnd: (ScaleEndDetails details) {
                          // Check if we need to snap back to bounds
                          _ensureImageInBounds(index);
                        },
                        child: CachedNetworkImage(
                          imageUrl: widget.images[index],
                          fit: BoxFit.contain,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[800],
                            child: const Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[800],
                            child: const Icon(Icons.broken_image, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Left/right navigation indicators (semi-transparent arrows)
            if (_isUIVisible)
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left arrow (if not first image)
                    GestureDetector(
                      onTap: () {
                        if (_currentIndex > 0) {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: _currentIndex > 0
                          ? Container(
                        width: 50,
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      )
                          : const SizedBox.shrink(),
                    ),

                    // Right arrow (if not last image)
                    if (_currentIndex < widget.images.length - 1)
                      GestureDetector(
                        onTap: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          width: 50,
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

            // Top bar with controls
            if (_isUIVisible)
              Positioned(
                top: 16,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Close button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      // Page indicator
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          '${_currentIndex + 1}/${widget.images.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // Reset zoom button
                      GestureDetector(
                        onTap: _resetZoom,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.zoom_out_map,
                            color: Colors.white,
                            size: 24,
                          ),
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
}