import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/spiritual/presentation/widgets/ArticleCard.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';

class ArticleDetailScreen extends StatelessWidget {
  final String title;
  final String imagePath;
  final String createdAt;
  final String description;

  const ArticleDetailScreen({
    super.key,
    required this.title,
    required this.imagePath,
    required this.createdAt,
    required this.description,
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
                    Image.network(
                      imagePath,
                      width: double.infinity,
                      height: isTablet ? 370 : 230,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: isTablet ? 370 : 230,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported, size: 50),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            createdAt,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Html(
                            data: description,
                            style: {
                              "body": Style(
                                fontSize: FontSize(16),
                                lineHeight: LineHeight(1.5),
                              ),
                              "p": Style(
                                margin: Margins.only(bottom: 16),
                              ),
                            },
                          ),
                          const SizedBox(height: 24),
                          const CommonDivider(),
                          const SizedBox(height: 24),
                          const Text(
                            'Related Posts',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // You would replace these with actual related posts from your controller
                          ArticleCard(
                            title: 'Related Article Title',
                            imagePath: imagePath,
                            createdAt: '3 days ago',
                            isHorizontal: true,

                          ),
                          const SizedBox(height: 16),
                          ArticleCard(
                            title: 'Another Related Article',
                            imagePath: imagePath,
                            createdAt: '5 days ago',
                            isHorizontal: true,

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