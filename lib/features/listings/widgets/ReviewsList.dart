import 'package:flutter/material.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';

class ReviewsList extends StatefulWidget {
  const ReviewsList({super.key});

  @override
  State<ReviewsList> createState() => _ReviewsListState();
}

class _ReviewsListState extends State<ReviewsList> {
  final Set<int> _expandedComments = {};

  final List<Map<String, Object>> reviews = [
    {
      'id': 1,
      'name': 'Ankit Singh',
      'rating': 4,
      'date': '14 April 2025',
      'comment':
          'Lorem ipsum dolor sit amet. Lorem elit ut tempor duo ea ssds lorem ipsum dolor. Lorem ipsum dolor sit amet. Lorem elit ut tempor duo ea ssds lorem ipsum dolor. Lorem ipsum dolor sit amet. Lorem elit ut tempor duo ea ssds lorem ipsum dolor.',
    },
    {
      'id': 2,
      'name': 'Ankit Singh',
      'rating': 5,
      'date': '14 April 2025',
      'comment':
          'Lorem ipsum dolor sit amet. Lorem elit ut tempor duo ea ssds lorem ipsum dolor. Lorem ipsum dolor sit amet. Lorem elit ut tempor duo ea ssds lorem ipsum dolor. Lorem ipsum dolor sit amet. Lorem elit ut tempor duo ea ssds lorem ipsum dolor.',
    },
    {
      'id': 3,
      'name': 'Ankit Singh',
      'rating': 3,
      'date': '14 April 2025',
      'comment':
          'Lorem ipsum dolor sit amet. Lorem elit ut tempor duo ea ssds lorem ipsum dolor. Lorem ipsum dolor sit amet. Lorem elit ut tempor duo ea ssds lorem ipsum dolor. Lorem ipsum dolor sit amet. Lorem elit ut tempor duo ea ssds lorem ipsum dolor.',
    },
  ];

  void _toggleComment(int id) {
    setState(() {
      if (_expandedComments.contains(id)) {
        _expandedComments.remove(id);
      } else {
        _expandedComments.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopRating(),
          const SizedBox(height: 16),
          _buildWriteReviewButton(),
          const SizedBox(height: 24),
          _buildOverallRating(),
          const SizedBox(height: 24),
          _buildReviewsList(),
        ],
      ),
    );
  }

  Widget _buildTopRating() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          const Text(
            '4.3',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Color(0xFF00A86D),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Based on 120 rating',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWriteReviewButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFCFE9FF),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.edit,
                  size: 18,
                  color: Color(0xFF2196F3),
                ),
                const SizedBox(width: 8),
                Text(
                  'Write a review',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverallRating() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side with Overall Rating and stars
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Overall Rating',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '4.0',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[900],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 2),
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: index < 4 ? Colors.red : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 16,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          // Right side with rating bars
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
              child: Column(
                children: [
                  _buildRatingBar('5 Star', 12, Colors.green),
                  _buildRatingBar('4 Star', 8, Colors.lightGreen),
                  _buildRatingBar('3 Star', 3, Colors.amber),
                  _buildRatingBar('2 Star', 2, Colors.orange),
                  _buildRatingBar('1 Star', 1, Colors.red[300]!),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(String label, int count, Color barColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 45,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: count / 12, // Normalize to max value
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(barColor),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsList() {
    return Column(
      children: reviews.map((review) => _buildReviewItem(review)).toList(),
    );
  }

  Widget _buildReviewItem(Map<String, Object> review) {
    final int id = review['id'] as int;
    final String comment = review['comment'] as String;
    final bool isExpanded = _expandedComments.contains(id);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey[200],
                child: const Icon(Icons.person, color: Colors.black, size: 20),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review['name'] as String,
                    style: AppTextStyles.bold16,
                  ),
                  Text(
                    review['date'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 8),
          _buildStarRating(review['rating'] as int),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment,
                maxLines: isExpanded ? null : 2,
                overflow: isExpanded ? null : TextOverflow.ellipsis,
                style: AppTextStyles.medium15,
              ),
              if (comment.length >
                  100) // Only show more/less if comment is long
                TextButton(
                  onPressed: () => _toggleComment(id),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: Colors.blue[700],
                  ),
                  child: Text(isExpanded ? 'less' : 'more'),
                ),
            ],
          ),
          const CommonDivider(),
        ],
      ),
    );
  }

  Widget _buildStarRating(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Container(
          margin: const EdgeInsets.only(left: 2),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: index < rating ? Colors.red : Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
          child: const Icon(
            Icons.star,
            color: Colors.white,
            size: 16,
          ),
        );
      }),
    );
  }
}
