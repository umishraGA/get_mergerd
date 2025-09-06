import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/features/common/widgets/BannerCorousal.dart';
import 'package:myapp/features/spiritual/presentation/screens/article_detail_screen.dart';
import 'package:myapp/features/spiritual/presentation/widgets/ArticleCard.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';

import '../controller/article_controller.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  final ArticleController articleController = Get.put(ArticleController());
  final List<Map<String, String>> _articles = [
    {
      'title':
      'Understanding Energy, Black magic and Protection : The role of Spiritual ...',
      'image': 'assets/images/spiritual/article_image.png',
      'time': '3 day ago',
    },
    {
      'title':
      'Understanding Energy, Black magic and Protection : The role of Spiritual ...',
      'image': 'assets/images/spiritual/article_image.png',
      'time': '3 day ago',
    },
    {
      'title':
      'Understanding Energy, Black magic and Protection : The role of Spiritual ...',
      'image': 'assets/images/spiritual/article_image.png',
      'time': '3 day ago',
    },
    {
      'title':
      'Understanding Energy, Black magic and Protection : The role of Spiritual ...',
      'image': 'assets/images/spiritual/article_image.png',
      'time': '3 day ago',
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
            const AppHeader(title: 'Articles'),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    // Ram Navami Banner
                    Bannercorousal(
                      imagePaths: [
                        'assets/images/spiritual/ram_navmi.png',
                        'assets/images/spiritual/ram_navmi.png',
                        'assets/images/spiritual/ram_navmi.png',
                      ],
                      height: isTablet ? 280 : 160,
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      // viewportFraction: 0.93,
                    ),
                    // Latest Posts Section
                    const Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        'Latest Posts',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Articles List
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: articleController.articles.length,
                        itemBuilder: (context, index) {
                          final articles = articleController.articles[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ArticleDetailScreen(
                                    title: articles['title']?.toString() ?? '',
                                    imagePath:articles['mobile_image']?.toString() ?? '',
                                    createdAt: articles['createdAt']?.toString() ?? '',
                                    description: articles['description'].toString() ?? '',
                                  ),
                                ),
                              );


                            },
                            child: ArticleCard(
                              title: articles['title']?.toString() ?? '',
                              imagePath:articles['mobile_image']?.toString() ?? '',
                              createdAt: articles['createdAt']?.toString() ?? '',
                            ),
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
}