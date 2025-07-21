import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/features/utsav/widgets/UtsavOfferBanner.dart';

class Bannercorousal extends StatefulWidget {
  final List<String>? imagePaths;
  final double height;
  final EdgeInsetsGeometry? margin;

  const Bannercorousal({
    super.key,
    this.imagePaths,
    this.height = 160,
    this.margin,
  });

  @override
  State<Bannercorousal> createState() => _BannercorousalState();
}

class _BannercorousalState extends State<Bannercorousal>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final List<String> _bannerImages;
  int _currentPage = 1000;
  Timer? _autoScrollTimer;
  bool _isUserInteracting = false;

  // Default banner images to use if none are provided
  static const List<String> defaultBanners = [
    'assets/images/utsav/banners/offer_banner.png',
    'assets/images/utsav/banners/offer_banner.png',
    'assets/images/utsav/banners/offer_banner.png',
  ];

  @override
  void initState() {
    super.initState();
    _bannerImages = widget.imagePaths ?? defaultBanners;
    _pageController = PageController(
      viewportFraction: 0.87, // Reduced to show more of adjacent banners
      initialPage: _currentPage,
    );

    // Add listener to keep track of page changes
    _pageController.addListener(() {
      if (_pageController.page?.round() != _currentPage) {
        setState(() {
          _currentPage = _pageController.page!.round();
        });
      }
    });

    // Start auto-scroll timer after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients && !_isUserInteracting && mounted) {
        _pageController.animateToPage(
          _currentPage + 1,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _pauseAutoScroll() {
    _isUserInteracting = true;
    _autoScrollTimer?.cancel();
  }

  void _resumeAutoScroll() {
    _isUserInteracting = false;
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      margin: widget.margin ?? const EdgeInsets.only(top: 10, bottom: 8),
      // Add outer padding to ensure the side banners are always visible
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onPanDown: (_) => _pauseAutoScroll(),
        onPanEnd: (_) => _resumeAutoScroll(),
        onPanCancel: () => _resumeAutoScroll(),
        child: PageView.builder(
          controller: _pageController,
          physics: const BouncingScrollPhysics(), // Smoother scrolling
          padEnds: true, // Add padding to the ends
          onPageChanged: (int page) {
            setState(() {
              _currentPage = page;
            });
          },
          itemBuilder: (BuildContext context, int index) {
            final adjustedIndex = index % _bannerImages.length;

            return AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                double value = 1.0;

                if (_pageController.position.haveDimensions) {
                  value = (_pageController.page! - index);
                  // Adjusted clamp values to ensure side banners remain visible
                  value = (1 - (value.abs() * 0.001)).clamp(0.75, 1.0);
                }

                return Center(
                  child: Transform.scale(
                    scale: value,
                    child: child,
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: UtsavOfferBanner(
                    imagePath: _bannerImages[adjustedIndex],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
