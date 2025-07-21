import 'package:flutter/material.dart';
import 'package:myapp/features/listings/views/EnquiryPage.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class GalleryGrid extends StatelessWidget {
  final List<String>? images;
  final bool isShowOtherDetails;
  final EdgeInsets padding;
  const GalleryGrid({
    super.key,
    this.images = const [
      'assets/images/listings/items/food_image.png',
      'assets/images/listings/items/food_image.png',
      'assets/images/listings/items/food_image.png',
      'assets/images/listings/items/food_image.png',
      'assets/images/listings/items/food_image.png',
      'assets/images/listings/items/food_image.png',
      'assets/images/listings/items/food_image.png',
      'assets/images/listings/items/food_image.png',
    ],
    this.isShowOtherDetails = false,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    // Sample gallery images - used if no images are provided
    final List<String> galleryImages = images ??
        [
          'assets/images/listings/items/food_image.png',
          'assets/images/listings/items/food_image.png',
          'assets/images/listings/items/food_image.png',
          'assets/images/listings/items/food_image.png',
          'assets/images/listings/items/food_image.png',
          'assets/images/listings/items/food_image.png',
          'assets/images/listings/items/food_image.png',
          'assets/images/listings/items/food_image.png',
        ];

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
        itemCount: galleryImages.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildGalleryItem(
            galleryImages[index],
            index: index,
            context: context,
          );
        },
      ),
    );
  }

  Widget _buildGalleryItem(
    String imagePath, {
    required int index,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        // Handle image tap - show full screen view
        _showFullScreenImage(context, imagePath, index);
      },
      child: Hero(
        tag: 'gallery_$index',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imagePath, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _FullScreenImageView(
          images: images ?? [],
          initialIndex: index,
          heroTag: 'gallery_$index',
          isShowOtherDetails: isShowOtherDetails,
        ),
      ),
    );
  }
}

class _FullScreenImageView extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final String heroTag;
  final bool isShowOtherDetails;

  const _FullScreenImageView({
    required this.images,
    required this.initialIndex,
    required this.heroTag,
    required this.isShowOtherDetails,
  });

  @override
  State<_FullScreenImageView> createState() => _FullScreenImageViewState();
}

class _FullScreenImageViewState extends State<_FullScreenImageView>
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

  double _calculateMaxScale(BuildContext context, String imagePath) {
    // Get the screen dimensions
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Default max scale - will be used if we can't determine image dimensions
    double maxScale = 2.0;

    try {
      // Get the asset image and its dimensions at runtime
      // This is a simplified approach - in a real app we'd use a more robust method
      // to get image dimensions, possibly by caching them or using a precached image
      final AssetImage assetImage = AssetImage(imagePath);
      final ImageStream stream = assetImage.resolve(ImageConfiguration.empty);

      stream.addListener(ImageStreamListener((ImageInfo info, bool _) {
        final double imageHeight = info.image.height.toDouble();
        final double imageWidth = info.image.width.toDouble();

        // Calculate the displayed image size when fit to screen
        double displayHeight, displayWidth;

        // Calculate aspect ratios
        final double screenAspect = screenWidth / screenHeight;
        final double imageAspect = imageWidth / imageHeight;

        if (screenAspect > imageAspect) {
          // Image is limited by height
          displayHeight = screenHeight;
          displayWidth = screenHeight * imageAspect;
        } else {
          // Image is limited by width
          displayWidth = screenWidth;
          displayHeight = screenWidth / imageAspect;
        }

        // Limit zoom to fit image height to screen height
        // This ensures you can't zoom beyond the natural image height
        maxScale = screenHeight / displayHeight;

        // Ensure max scale is reasonable (not too small or large)
        maxScale = maxScale.clamp(1.0, 3.0);
      }));
    } catch (e) {
      debugPrint('Error calculating max scale: $e');
    }

    return maxScale;
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
                  // Use SizedBox.expand to fill all available space
                  child: Hero(
                    tag: index == widget.initialIndex
                        ? widget.heroTag
                        : 'gallery_$index',
                    child: SizedBox.expand(
                      child: InteractiveViewer(
                        transformationController:
                            _transformationControllers[index],
                        minScale:
                            1.0, // Start at 1.0 to prevent going smaller than screen
                        // Limit max scale based on image dimensions
                        maxScale: 2.0, // Fixed reasonable max zoom
                        boundaryMargin: const EdgeInsets.all(
                            0), // No margin to prevent scrolling beyond bounds
                        clipBehavior: Clip.hardEdge,
                        constrained: true,
                        panEnabled: true, // Enable panning
                        scaleEnabled: true, // Enable scaling
                        onInteractionEnd: (ScaleEndDetails details) {
                          // Check if we need to snap back to bounds
                          _ensureImageInBounds(index);
                        },
                        child: Image.asset(
                          widget.images[index],
                          fit: BoxFit.contain,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
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
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
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
                          child: Container(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (widget.isShowOtherDetails)
              // Bottom clinic details
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.grey[900]!,
                        Colors.grey[900]!.withOpacity(0.9),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.7, 1.0],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SSR Ayurvedic and Panchkarma Clinic',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Shop No. 51, Shalimar Building, Near Hospital, Sector 18, Noida ,Uttar Pradesh',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0F9D58),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      bottomLeft: Radius.circular(30)),
                                ),
                                elevation: 0,
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.call, size: 16),
                                  SizedBox(width: 8),
                                  Text('Call'),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const EnquiryPage(
                                            clinicName: 'Jiva Ayurvedic Clinic',
                                            category: 'Ayurvedic',
                                            subCategory: 'Clinic',
                                          )),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFBC02D),
                                foregroundColor: Colors.black,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                elevation: 0,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                              ),
                              child: const Text('Enquiry'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4976C2),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      bottomRight: Radius.circular(30)),
                                ),
                                elevation: 0,
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.directions, size: 16),
                                  SizedBox(width: 8),
                                  Text('Direction'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
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
