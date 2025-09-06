import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_avif/flutter_avif.dart'; // For AVIF support
import '../controller/banner_controller.dart';

class EventBannerSlider extends StatefulWidget {
  const EventBannerSlider({super.key});

  @override
  State<EventBannerSlider> createState() => _EventBannerSliderState();
}

class _EventBannerSliderState extends State<EventBannerSlider> {
  final EventBannerController controller = Get.put(EventBannerController());
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (controller.banners.isNotEmpty) {
        _currentPage = (_currentPage + 1) % controller.banners.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  /// Returns the appropriate image widget based on URL extension
  Widget _buildBannerImage(String url) {
    if (url.toLowerCase().endsWith(".avif")) {
      return AvifImage.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) =>
        const Center(child: Icon(Icons.broken_image, size: 50)),
      );
    } else {
      return Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) =>
        const Center(child: Icon(Icons.broken_image, size: 50)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Responsive height: 25% of screen height
    final double bannerHeight = MediaQuery.of(context).size.height * 0.25;

    return Obx(() {
      if (controller.isLoading.value) {
        return SizedBox(
          height: bannerHeight,
          child: const Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.errorMessage.isNotEmpty) {
        return SizedBox(
          height: bannerHeight,
          child: Center(child: Text(controller.errorMessage.value)),
        );
      }

      if (controller.banners.isEmpty) {
        return SizedBox(
          height: bannerHeight,
          child: const Center(child: Text("No banners found")),
        );
      }

      return SizedBox(
        height: bannerHeight,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: controller.banners.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                final banner = controller.banners[index];
                return Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildBannerImage(banner.mobBanner),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(controller.banners.length, (index) {
                  bool isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 12 : 8,
                    height: isActive ? 12 : 8,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.white : Colors.white54,
                      shape: BoxShape.circle,
                      boxShadow: isActive
                          ? const [BoxShadow(color: Colors.black26, blurRadius: 4)]
                          : [],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      );
    });
  }
}
