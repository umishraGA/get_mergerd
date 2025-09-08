import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
<<<<<<< HEAD
import 'package:flutter_avif/flutter_avif.dart'; // For AVIF support
=======
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
import '../controller/banner_controller.dart';

class EventBannerSlider extends StatefulWidget {
  const EventBannerSlider({super.key});

  @override
  State<EventBannerSlider> createState() => _EventBannerSliderState();
}

class _EventBannerSliderState extends State<EventBannerSlider> {
  final EventBannerController controller = Get.put(EventBannerController());
<<<<<<< HEAD
=======

>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
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

<<<<<<< HEAD
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
=======
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
        );
      }

      if (controller.errorMessage.isNotEmpty) {
        return SizedBox(
<<<<<<< HEAD
          height: bannerHeight,
=======
          height: 200,
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
          child: Center(child: Text(controller.errorMessage.value)),
        );
      }

      if (controller.banners.isEmpty) {
<<<<<<< HEAD
        return SizedBox(
          height: bannerHeight,
          child: const Center(child: Text("No banners found")),
=======
        return const SizedBox(
          height: 200,
          child: Center(child: Text("No banners found")),
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
        );
      }

      return SizedBox(
<<<<<<< HEAD
        height: bannerHeight,
=======
        height: 200,
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
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
<<<<<<< HEAD
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
=======
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
<<<<<<< HEAD
                    child: _buildBannerImage(banner.mobBanner),
=======
                    child: Image.network(
                      banner.mobBanner,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.broken_image, size: 50),
                      ),
                    ),
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
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
<<<<<<< HEAD
                          ? const [BoxShadow(color: Colors.black26, blurRadius: 4)]
=======
                          ? [BoxShadow(color: Colors.black26, blurRadius: 4)]
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
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
