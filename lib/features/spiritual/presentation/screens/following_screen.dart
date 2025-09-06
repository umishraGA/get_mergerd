import 'package:flutter/material.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/spiritual/presentation/screens/temple_detail_screen.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({super.key});

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  final List<Map<String, dynamic>> _followedTemples = [
    {
      'name': 'Ayodhya',
      'address': 'Address of Temple will show here',
      'location': 'Uttar Pradesh',
      'image': 'assets/images/spiritual/ayodhya.png',
      'isVerified': true,
    },
    {
      'name': 'Ayodhya',
      'address': 'Address of Temple will show here',
      'location': 'Uttar Pradesh',
      'image': 'assets/images/spiritual/ayodhya.png',
      'isVerified': true,
    },
    {
      'name': 'Ayodhya',
      'address': 'Address of Temple will show here',
      'location': 'Uttar Pradesh',
      'image': 'assets/images/spiritual/ayodhya.png',
      'isVerified': true,
    },
  ];

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: Column(
        children: [
          const AppHeader(title: 'Followings'),
          // List of followed temples
          Expanded(
            child: ListView.builder(
              itemCount: _followedTemples.length,
              itemBuilder: (context, index) {
                final temple = _followedTemples[index];
                return _buildTempleListItem(temple, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTempleListItem(Map<String, dynamic> temple, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TempleDetailScreen(
              templeId: temple['_id'] as String,

            ),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Temple image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    temple['image'] as String,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, color: Colors.grey),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 16),

                // Temple details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Temple name and verified badge
                      Row(
                        children: [
                          Text(
                            temple['name'] as String,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          if (temple['isVerified'] == true)
                            const Icon(
                              Icons.verified,
                              color: Colors.green,
                              size: 18,
                            ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // Temple address
                      Text(
                        temple['address'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Location tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          temple['location'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Unfollow button
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      _showUnfollowDialog(temple, index);
                    },
                  ),
                )
              ],
            ),
          ),

          // Divider between items
          const CommonDivider(),
        ],
      ),
    );
  }

  void _showUnfollowDialog(Map<String, dynamic> temple, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unfollow'),
        content: Text(
            'Are you sure you want to unfollow ${temple['name'] as String}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _followedTemples.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('Unfollow'),
          ),
        ],
      ),
    );
  }
}
