import 'package:flutter/material.dart';
import 'package:myapp/features/posts/widgets/NetworkImageWidget.dart';

class MultiImagePostWidget extends StatefulWidget {
  final List<String> imagePaths;
  final double height;
  final BorderRadius? borderRadius;
  final Function(int)? onTap;
  final VoidCallback? onDoubleTap; // Add double tap callback for liking
  final bool isDetailView; // Flag to indicate if this is in detail view

  const MultiImagePostWidget({
    super.key,
    required this.imagePaths,
    this.height = 300,
    this.borderRadius,
    this.onTap,
    this.onDoubleTap, // For handling likes on double tap
    this.isDetailView = false, // Default to posts view
  });

  @override
  State<MultiImagePostWidget> createState() => _MultiImagePostWidgetState();
}

class _MultiImagePostWidgetState extends State<MultiImagePostWidget>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(
    initialPage: 0,
    viewportFraction: 1.0,
    keepPage: true,
  );
  late TransformationController _transformationController;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;
  int _currentPage = 0;
  bool _isZooming = false;
  final double _maxScale = 3.0;

  @override
  void initState() {
    super.initState();
    // Initialize transformationController for zooming
    _transformationController = TransformationController();

    // Initialize animation controller for reset animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        if (_animation != null) {
          _transformationController.value = _animation!.value;
        }
      });

    // Jump to first page immediately without animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    });
  }

  @override
  void didUpdateWidget(MultiImagePostWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If image paths changed, reset to the first page
    if (oldWidget.imagePaths != widget.imagePaths) {
      _currentPage = 0;
      // Jump to first page without animation when content changes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _pageController.hasClients) {
          _pageController.jumpToPage(0);
        }
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Reset to initial position with animation
  void _resetZoom() {
    final Matrix4 initialMatrix = Matrix4.identity();
    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: initialMatrix,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward(from: 0.0).then((_) {
      setState(() {
        _isZooming = false;
      });
    });
  }

  // Handle double tap to zoom or like
  void _handleDoubleTapDown(TapDownDetails details) {
    if (_isZooming) {
      // If already zoomed in, zoom out to original position
      _resetZoom();
      return;
    }

    // If not zoomed in yet, check if we should like or zoom
    if (widget.onDoubleTap != null) {
      // If onDoubleTap is provided, it means we're in post list view
      // and should trigger like action instead of zoom
      widget.onDoubleTap!();
      return;
    }

    // Otherwise do the zoom action
    setState(() {
      _isZooming = true;
    });

    // Zoom in to the tapped point
    final position = details.localPosition;
    final Matrix4 newMatrix = Matrix4.identity()
      ..translate(-position.dx * 0.5, -position.dy * 0.5)
      ..scale(2.0);

    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: newMatrix,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward(from: 0.0);
  }

  // Called when user begins interaction
  void _onInteractionStart(ScaleStartDetails details) {
    if (!_isZooming) {
      setState(() {
        _isZooming = true;
      });
    }
  }

  // Called when user ends interactiveViewer interaction
  void _onInteractionEnd(ScaleEndDetails details) {
    // If scale is below the minimum threshold, animate back to original size
    if (_transformationController.value.getMaxScaleOnAxis() < 1.0) {
      _resetZoom();
    }
  }

  // Handle tap for navigation and zooming
  void _handleTap() {
    if (_isZooming) {
      // If zoomed in, tapping resets zoom
      _resetZoom();
    } else {
      // Call parent onTap if not zooming
      widget.onTap?.call(_currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: Stack(
        children: [
          // Main image carousel with zoom capability
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imagePaths.length,
            physics: _isZooming
                ? const NeverScrollableScrollPhysics()
                : const PageScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
                // Reset zoom when changing page
                if (_isZooming) {
                  _resetZoom();
                }
              });
            },
            // Prevent initial animation by setting this to false
            padEnds: false,
            // Ensure viewport fraction is 1.0 to avoid partial visibility of adjacent pages
            pageSnapping: true,
            clipBehavior: Clip.none,
            itemBuilder: (context, index) {
              return GestureDetector(
                onDoubleTap:
                    () {}, // Intercept double tap to use our own handler
                onDoubleTapDown: _handleDoubleTapDown,
                onTap: _handleTap,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius:
                        widget.borderRadius ?? BorderRadius.circular(5),
                  ),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      // Image with zoom capability
                      InteractiveViewer(
                        transformationController: _transformationController,
                        minScale: 0.8,
                        maxScale: _maxScale,
                        onInteractionStart: _onInteractionStart,
                        onInteractionEnd: _onInteractionEnd,
                        child: Hero(
                          tag: 'multi-image-${widget.imagePaths[index]}',
                          // Use flightShuttleBuilder for custom transitions
                          flightShuttleBuilder: (
                            BuildContext flightContext,
                            Animation<double> animation,
                            HeroFlightDirection flightDirection,
                            BuildContext fromHeroContext,
                            BuildContext toHeroContext,
                          ) {
                            // Create a smoother transition with proper sizing
                            return AnimatedBuilder(
                              animation: animation,
                              builder: (context, child) {
                                return Material(
                                  color: Colors.transparent,
                                  child: NetworkImageWidget(
                                    imageUrl: widget.imagePaths[index],
                                    fit: widget.isDetailView
                                        ? BoxFit.contain
                                        : BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    placeholder: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      color: Colors.grey.shade200,
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: NetworkImageWidget(
                            imageUrl: widget.imagePaths[index],
                            fit: widget.isDetailView
                                ? BoxFit.contain
                                : BoxFit.cover,
                            width: double.infinity,
                            height: widget.height,
                            placeholder: Container(
                              width: double.infinity,
                              height: widget.height,
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: Container(
                              width: double.infinity,
                              height: widget.height,
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: Icon(Icons.image_not_supported,
                                    size: 50, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Zoom indicator (only visible when not zoomed in)
                      if (!_isZooming && !widget.isDetailView)
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.zoom_out_map,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Page indicator (only visible when not zoomed in)
          if (!_isZooming)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.imagePaths.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),

          // Previous/Next buttons (only visible when not zoomed in and multiple images)
          if (widget.imagePaths.length > 1 && !_isZooming) ...[
            // Previous button (hidden on first image)
            if (_currentPage > 0)
              Positioned(
                left: 8,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),

            // Next button (hidden on last image)
            if (_currentPage < widget.imagePaths.length - 1)
              Positioned(
                right: 8,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
          ],

          // Counter indicator (only visible when not zoomed in)
          if (!_isZooming)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${_currentPage + 1}/${widget.imagePaths.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Pinch and zoom instruction (only visible when zoomed in)
          if (_isZooming)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Pinch to zoom • Double-tap to reset',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
