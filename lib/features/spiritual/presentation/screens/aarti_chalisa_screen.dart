import 'package:flutter/material.dart';
import 'package:myapp/features/common/widgets/BannerCorousal.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';

class AartiChalisaScreen extends StatefulWidget {
  const AartiChalisaScreen({super.key});

  @override
  State<AartiChalisaScreen> createState() => _AartiChalisaScreenState();
}

class _AartiChalisaScreenState extends State<AartiChalisaScreen> {
  final List<Map<String, String>> _deities = [
    {
      'name': 'Hanuman Ji',
      'image': 'assets/images/spiritual/aarti.png',
    },
    {
      'name': 'Shri Ram Ji',
      'image': 'assets/images/spiritual/aarti.png',
    },
    {
      'name': 'Kali Maa',
      'image': 'assets/images/spiritual/aarti.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            const AppHeader(title: 'Aarti & Chalisa'),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ram Navami Banner
                    Bannercorousal(
                      imagePaths: [
                        'assets/images/spiritual/ram_navmi.png',
                        'assets/images/spiritual/ram_navmi.png',
                        'assets/images/spiritual/ram_navmi.png',
                      ],
                      height: isTablet ? 280 : 160,
                      // viewportFraction: 0.93,
                      margin: EdgeInsets.symmetric(horizontal: 16),
                    ),

                    const SizedBox(height: 24),

                    // Deity Grid
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // Calculate optimal width and aspect ratio based on available space
                          final itemWidth = (constraints.maxWidth - 32) /
                              3; // 3 columns with 16px spacing
                          const aspectRatio =
                              0.75; // Fixed aspect ratio to prevent overflow

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: aspectRatio,
                            ),
                            itemCount: _deities.length,
                            itemBuilder: (context, index) {
                              return _buildDeityCard(
                                _deities[index]['name'] ?? '',
                                _deities[index]['image'] ?? '',
                                itemWidth: itemWidth,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeityCard(String name, String imagePath,
      {required double itemWidth}) {
    return GestureDetector(
      onTap: () {
        // Navigate to deity detail screen
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image container with proportional height
          AspectRatio(
            aspectRatio: 1.0, // Square image
            child: Container(
              width: itemWidth,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF2D1),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Name with constrained width to prevent overflow
          Container(
            width: itemWidth,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: 'FacebookSans',
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
