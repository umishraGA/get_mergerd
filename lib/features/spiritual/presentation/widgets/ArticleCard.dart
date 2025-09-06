import 'package:flutter/material.dart';

class ArticleCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String createdAt; // 👈 ISO date string from API like "2025-07-21T08:31:44.875Z"
  // final VoidCallback? onTap;
  final bool isHorizontal;

  const ArticleCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.createdAt,
    // this.onTap,
    this.isHorizontal = false,
  });

  /// ⏱️ Converts ISO string to time-ago text like '3d ago', '2mo ago', etc.
  String getTimeAgo(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString).toLocal();
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays >= 365) {
        final years = (difference.inDays / 365).floor();
        return '${years}y ago';
      } else if (difference.inDays >= 30) {
        final months = (difference.inDays / 30).floor();
        return '${months}mo ago';
      } else if (difference.inDays >= 7) {
        final weeks = (difference.inDays / 7).floor();
        return '${weeks}w ago';
      } else if (difference.inDays >= 1) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours >= 1) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes >= 1) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'just now';
      }
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return _buildHorizontalCard(context);
    }
    return _buildVerticalCard(context);
  }

  // Vertical layout for main article list
  Widget _buildVerticalCard(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return GestureDetector(
      // onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.network(
                imagePath,
                width: double.infinity,
                height: isTablet ? 270 : 180,
                fit: BoxFit.cover,
              ),
            ),

            // Title & Time
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    getTimeAgo(createdAt), // 👈 dynamically calculated
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Horizontal layout for related posts
  Widget _buildHorizontalCard(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return GestureDetector(
      // onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFEEEEEE)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.network(
                imagePath,
                width: isTablet ? 100 : 150,
                height: isTablet ? 100 : 150,
                fit: BoxFit.cover,
              ),
            ),

            // Title & Time
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      getTimeAgo(createdAt), // 👈 dynamically calculated
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
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
