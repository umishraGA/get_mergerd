import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'image_view.dart';

class CustomImage extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final BoxFit? fit;
  final bool viewMode;
  const CustomImage({super.key, required this.imageUrl, this.radius=10, this.fit, this.viewMode=true,});

  @override
  Widget build(BuildContext context) {
    String getFallbackUrl() {
      // Cloudinary f_auto automatically sends supported format
      return imageUrl.replaceAll("/upload/", "/upload/f_auto,q_auto/");
    }
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: viewMode ? ()=> openFullImage(context, imageUrl) : null,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fadeOutDuration: const Duration(seconds: 2),
        fadeInCurve: Curves.fastOutSlowIn,
        fadeOutCurve: Curves.fastEaseInToSlowEaseOut,
        filterQuality: FilterQuality.high,
        repeat: ImageRepeat.repeat,
        imageBuilder: (context, imageProvider) => Container(
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            image: DecorationImage(
              image: imageProvider,
              fit: fit ?? BoxFit.fill,
              colorFilter: const ColorFilter.mode(Colors.white,
                BlendMode.colorBurn,
              ),
            ),
          ),
        ),
        placeholder: (context, url) => const Center(
          child: SizedBox(
            height: 45,
            width: 45,
            child: CircularProgressIndicator(color: Colors.redAccent),
          ),
        ),
        errorWidget: (context, url, error) => CachedNetworkImage(
          imageUrl: getFallbackUrl(),
          placeholder: (ctx, url) => const Center(
            child: SizedBox(
              height: 45,
              width: 45,
              child: CircularProgressIndicator(color: Colors.redAccent),
            ),
          ),
          errorWidget: (ctx, url, error) => const Icon(Icons.error, size: 40),
          fit: fit ?? BoxFit.fill,
        ),
      ),
    );
  }
}

class CustomCircleImage extends StatelessWidget {
  final String imageUrl;
  final bool viewMode;
  const CustomCircleImage({super.key, required this.imageUrl, this.viewMode=true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: viewMode ? ()=> openFullImage(context, imageUrl) : null,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fadeOutDuration: const Duration(seconds: 2),
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 0.5, color: Colors.redAccent.withOpacity(0.5)),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.colorBurn,
              ),
            ),
          ),
        ),
        placeholder: (context, url) => Center(
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 0.5, color: Colors.redAccent.withOpacity(0.5)),
            ),
            child: const CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Icon(
          Icons.error,
          size: 25,
          color: Colors.orange.withOpacity(0.7),
        ),
      ),
    );
  }
}
