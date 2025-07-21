import 'package:flutter/material.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';

import '../models/UtsavCategory.dart';
import 'UtsavItemDetailPage.dart';

class UtsavCategoryPage extends StatelessWidget {
  final UtsavCategory category;

  const UtsavCategoryPage({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header with red background
            const AppHeader(
              title: 'Apparel & Fashion',
              subtitle: 'Mattyari,Lucknow - 226028',
              showDropdown: true,
            ),

            // Results list (scrollable content)
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const ClampingScrollPhysics(),
                itemCount: 10, // Example count
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        _buildBannerAd(context),
                        const SizedBox(height: 10),
                        const Divider(
                          height: 1,
                          color: Color(0xFFEEEEEE),
                          indent: 16,
                          endIndent: 16,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Text(
                            '200 Results for your Search',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return _buildListingItem(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerAd(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return Container(
        height: isTablet ? 360 : 187,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          image: const DecorationImage(
            image: AssetImage(
                'assets/images/utsav/banners/limited_time_offer.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          height: 1,
        ));
  }

  Widget _buildListingItem(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UtsavItemDetailPage(
              title: 'Jiva Ayurvedic Clinic',
              location:
                  'Shop No. 51, Shalimar Building, Near Hospital, Sector 18, Noida ,Uttar Pradesh',
              imagePath: 'assets/images/post_image.png',
              isVerified: true,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Listing image
            Stack(
              children: [
                SizedBox(
                  height: isTablet ? 360 : 200,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                    child: Image.asset(
                      'assets/images/post_image.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Add a gradient overlay at the bottom for better text visibility
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(12),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        // Star icon with rating (green part)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF059E54), // Green background
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(6),
                              bottomLeft: Radius.circular(6),
                            ),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 2),
                              Text(
                                '4.3',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Number in white background
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(6),
                              bottomRight: Radius.circular(6),
                            ),
                          ),
                          child: const Text(
                            '120',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Listing details
            Padding(
              padding: const EdgeInsets.only(right: 12, top: 12, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Jiva Ayurvedic Clinic',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Image.asset(
                        'assets/images/check_icon.png',
                        width: 24,
                        height: 24,
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Sector 18,Noida',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              'assets/images/utsav/banners/discount_offer.png',
                              fit: BoxFit.fill,
                              width: 210,
                              height: 33,
                            ),
                          ),
                          const Positioned(
                            top: 10,
                            bottom: 0,
                            left: 60,
                            right: 0,
                            child: SizedBox(
                              height: 32,
                              child: Text(
                                '10 Vouchers Available',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'OCT, 15 2025',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Valid until',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const CommonDivider(),
          ],
        ),
      ),
    );
  }
}

class GridPatternPainter extends CustomPainter {
  final Color color;
  final double lineWidth;
  final double spacing;

  GridPatternPainter({
    required this.color,
    this.lineWidth = 1.0,
    this.spacing = 10.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(GridPatternPainter oldDelegate) =>
      color != oldDelegate.color ||
      lineWidth != oldDelegate.lineWidth ||
      spacing != oldDelegate.spacing;
}
