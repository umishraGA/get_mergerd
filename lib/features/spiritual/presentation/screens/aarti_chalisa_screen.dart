import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/features/common/widgets/BannerCorousal.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';
import '../controller/aarti_controller.dart';
import 'detail_aarti_page.dart'; // make sure this is correct path

class AartiChalisaScreen extends StatefulWidget {
  const AartiChalisaScreen({super.key});

  @override
  State<AartiChalisaScreen> createState() => _AartiChalisaScreenState();
}

class _AartiChalisaScreenState extends State<AartiChalisaScreen> {
  final AartiController controller = Get.put(AartiController()); // Inject controller

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(title: 'Aarti & Chalisa'),

            Expanded(
              child: SingleChildScrollView(
                controller: controller.scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bannercorousal(
                      imagePaths: [
                        'assets/images/spiritual/ram_navmi.png',
                        'assets/images/spiritual/ram_navmi.png',
                        'assets/images/spiritual/ram_navmi.png',
                      ],
                      height: isTablet ? 280 : 160,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    const SizedBox(height: 24),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final itemWidth = (constraints.maxWidth - 32) / 3;
                          const aspectRatio = 0.75;

                          // ✅ Wrap only the GridView in Obx
                          return Obx(() => GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: aspectRatio,
                            ),
                            itemCount: controller.aartis.length,
                            itemBuilder: (context, index) {
                              final item = controller.aartis[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AartiDetailPage(
                                        title: item['title'].toString().toString() ?? '',
                                        imageUrl: item['web_image'].toString() ?? '',
                                        description: item['description'].toString() ?? '',
                                      ),
                                    ),
                                  );


                                },
                                child: _buildDeityCard(
                                  item['title'].toString(),
                                  item['mobile_image'].toString(),
                                  itemWidth: itemWidth,
                                ),
                              );
                            },
                          ));
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

  Widget _buildDeityCard(String title, String imagePath, {required double itemWidth}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: itemWidth,
          height: itemWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: itemWidth,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14, // You can adjust this
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
