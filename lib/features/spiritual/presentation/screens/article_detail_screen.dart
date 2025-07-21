import 'package:flutter/material.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/spiritual/presentation/widgets/ArticleCard.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';

class ArticleDetailScreen extends StatelessWidget {
  final String title;
  final String image;
  final String time;

  const ArticleDetailScreen({
    super.key,
    required this.title,
    required this.image,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(title: ''),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Article Image
                    Image.asset(
                      image,
                      width: double.infinity,
                      height: isTablet ? 370 : 230,
                      fit: BoxFit.cover,
                    ),

                    // Article Content
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Time
                          Text(
                            time,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Article Content
                          const Text(
                            'The power of Dhyanalinga in negating negative energy',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          const Text(
                            'Protect yourself from black magic with rudraksha Effects of black magic and how to combat them Importance of spiritual sadhana for protection from negativity How energy influences your life: Good and bad The science behind black magic and its psychological impact',
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 16),

                          const Text(
                            'Role of Dhyanalinga in trans forming negative influences Using Dhyanalinga to overcome occult forces and negativity How to remove black magic using spiritual methods The power of Dhyanalinga in negating negative energy',
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 24),

                          const Text(
                            'The power of Dhyanalinga in negating negative energy',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 24),

                          const CommonDivider(),

                          const SizedBox(height: 24),

                          // Related Posts
                          const Text(
                            'Related Posts',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Related Post Cards
                          ArticleCard(
                            title:
                                'Understanding Energy, Black magic and Protection : The role of Spiritual ...',
                            imagePath: image,
                            timeAgo: '3 day ago',
                            isHorizontal: false,
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ArticleDetailScreen(
                                    title:
                                        'Understanding Energy, Black magic and Protection : The role of Spiritual ...',
                                    image: image,
                                    time: '3 day ago',
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          ArticleCard(
                            title:
                                'Understanding Energy, Black magic and Protection : The role of Spiritual ...',
                            imagePath: image,
                            timeAgo: '3 day ago',
                            isHorizontal: false,
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ArticleDetailScreen(
                                    title:
                                        'Understanding Energy, Black magic and Protection : The role of Spiritual ...',
                                    image: image,
                                    time: '3 day ago',
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
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
