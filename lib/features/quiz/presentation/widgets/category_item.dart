import 'package:flutter/material.dart';
import 'package:myapp/common/image/custom_image.dart';
import 'package:shimmer/shimmer.dart';

import '../routes/quiz_routes.dart';

class CategoryCard extends StatelessWidget {
  final String icon;
  final String type;
  final VoidCallback? onTap;
  final bool rightSpace;
  final bool viewImage;
  const CategoryCard({super.key, required this.icon, required this.type, this.onTap, this.rightSpace = true, this.viewImage=false});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return GestureDetector(
      onTap: onTap ??
              () {
            Navigator.pushNamed(
              context,
              QuizRoutes.categoryLevels,
              arguments: type,
            );
          },
      child: Container(
        width: isTablet ? 190 : 150,
        height: isTablet ? 260 : 170,
        margin: EdgeInsets.only(right: rightSpace == true ? 10 : 0, bottom: rightSpace == false ? 10 : 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1, color: Colors.grey.shade200),
        ),
        child: Stack(
          children: [
            // Image part (takes most of the space)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CustomImage(imageUrl: icon, viewMode: viewImage,),
              ),
            ),

            // Name at the bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black45.withOpacity(0.35),
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(7), bottomRight: Radius.circular(7)),
                ),
                child: Text(
                  type,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CategoryCardShimmer extends StatelessWidget {
  const CategoryCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return Container(
      width: isTablet ? 190 : 150,
      height: isTablet ? 260 : 170,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        children: [
          // Image shimmer
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(color: Colors.white),
              ),
            ),
          ),

          // Text shimmer at bottom
          Positioned(
            bottom: 5,
            left: 5,
            right: 5,
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: double.infinity-10,
                  height: 25,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


