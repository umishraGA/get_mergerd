import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

void openFullImage(BuildContext context, String imageUrl) {
  Navigator.push(
    context,
    PageRouteBuilder(
      opaque: false,
      pageBuilder: (_, __, ___) => FullscreenImageViewer(imageUrl: imageUrl),
    ),
  );
}

class FullscreenImageViewer extends StatelessWidget {
  final String imageUrl;
  const FullscreenImageViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ExtendedImageSlidePage(
      slideType: SlideType.onlyImage,
      slideAxis: SlideAxis.vertical,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: ExtendedImageSlidePageHandler(
                child: Hero(
                  tag: getFallbackUrl(),
                  child: ExtendedImage.network(
                    getFallbackUrl(),
                    fit: BoxFit.contain,
                    mode: ExtendedImageMode.gesture,
                    enableSlideOutPage: true,
                    initGestureConfigHandler: (_) => GestureConfig(
                      minScale: 0.8,
                      maxScale: 4.0,
                      animationMinScale: 0.7,
                      animationMaxScale: 4.5,
                      speed: 1.0,
                      inertialSpeed: 100.0,
                      initialScale: 1.0,
                      inPageView: false,
                      initialAlignment: InitialAlignment.center,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 5,
              child: IconButton(
                onPressed: ()=> Navigator.of(context).pop(),
                icon: const Icon(Icons.west_outlined, size: 30, color: Colors.white,),
              ),
            ),
          ],
        ),
      ),
    );
  }
  String getFallbackUrl() {
    // Cloudinary f_auto automatically sends supported format
    return imageUrl.replaceAll("/upload/", "/upload/f_auto,q_auto/");
  }
}

