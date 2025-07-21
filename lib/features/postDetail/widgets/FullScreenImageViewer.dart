import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/features/mainPage/widgets/MultiImagePostWidget.dart';

class FullScreenImageViewer extends StatefulWidget {
  final String imagePath;
  final Function() onClose;
  final List<String>? additionalImages;
  final bool isMultiImage;

  const FullScreenImageViewer({
    super.key,
    required this.imagePath,
    required this.onClose,
    this.additionalImages,
    this.isMultiImage = false,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer>
    with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;
  final double _minScale = 0.8;
  final double _maxScale = 5.0;
  bool _isZooming = false;
  bool _showControls = true;

  // Track if we're currently animating back to initial position
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        if (_animation != null) {
          _transformationController.value = _animation!.value;
        }
      });

    // Set system UI for immersive experience
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    // Hide status bar for truly immersive experience
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();

    // Restore system UI when closing
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    super.dispose();
  }

  // Reset to initial position with animation
  void _resetToInitialPosition() {
    _isAnimating = true;
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
      _isAnimating = false;
      setState(() {
        _isZooming = false;
        _showControls = true;
      });
    });
  }

  // Handle double tap to zoom
  void _handleDoubleTapDown(TapDownDetails details) {
    if (_isAnimating) return;

    if (_transformationController.value != Matrix4.identity()) {
      // If already zoomed in, zoom out to original position
      _resetToInitialPosition();
    } else {
      setState(() {
        _isZooming = true;
        _showControls = false;
      });

      // Zoom in to the tapped point
      final position = details.localPosition;
      final Matrix4 newMatrix = Matrix4.identity()
        ..translate(-position.dx * 1.5, -position.dy * 1.5)
        ..scale(2.5);

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
  }

  // Called when user begins interaction
  void _onInteractionStart(ScaleStartDetails details) {
    // When user starts zooming/panning, hide controls
    if (!_isZooming) {
      setState(() {
        _isZooming = true;
        _showControls = false;
      });
    }
  }

  // Called when user ends interactiveViewer interaction
  void _onInteractionEnd(ScaleEndDetails details) {
    // If scale is below the minimum threshold, animate back to original size
    if (_transformationController.value.getMaxScaleOnAxis() < 1.0) {
      _resetToInitialPosition();
    }
    // If not zoomed in anymore, show controls again
    else if (_transformationController.value.getMaxScaleOnAxis() < 1.2) {
      setState(() {
        _isZooming = false;
        _showControls = true;
      });
    }
  }

  // Single tap handler - toggle controls visibility
  void _handleTap() {
    if (_isZooming) {
      setState(() {
        _showControls = !_showControls;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main image viewer with zoom capability
          widget.isMultiImage && widget.additionalImages != null
              ? _buildMultiImageViewer()
              : _buildSingleImageViewer(),

          // Close button - only visible when not zooming
          if (_showControls)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: widget.onClose,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Instructions overlay - only shown initially
          if (_showControls && !_isZooming)
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.touch_app,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.isMultiImage
                              ? 'Swipe to view more images • Double tap to zoom'
                              : 'Double tap to zoom • Pinch to adjust view',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSingleImageViewer() {
    return GestureDetector(
      onDoubleTap: () {}, // Intercept double tap to use custom handler
      onDoubleTapDown: _handleDoubleTapDown,
      onTap: _handleTap,
      child: InteractiveViewer(
        transformationController: _transformationController,
        minScale: _minScale,
        maxScale: _maxScale,
        onInteractionStart: _onInteractionStart,
        onInteractionEnd: _onInteractionEnd,
        panEnabled: true,
        scaleEnabled: true,
        boundaryMargin: const EdgeInsets.all(double.infinity),
        child: Center(
          child: Hero(
            tag: 'image-${widget.imagePath}',
            child: Image.asset(
              widget.imagePath,
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade900,
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.white54,
                      size: 64,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMultiImageViewer() {
    final allImages = [widget.imagePath, ...?widget.additionalImages];

    return MultiImagePostWidget(
      imagePaths: allImages,
      height: double.infinity,
      borderRadius: BorderRadius.zero,
      onTap: (_) => _handleTap(),
    );
  }
}
