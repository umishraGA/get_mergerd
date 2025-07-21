import 'package:flutter/material.dart';

import '../../../features/common/widgets/listing_item_card.dart';

class MyFollowingsScreen extends StatefulWidget {
  const MyFollowingsScreen({super.key});

  @override
  State<MyFollowingsScreen> createState() => _MyFollowingsScreenState();
}

class _MyFollowingsScreenState extends State<MyFollowingsScreen> {
  // Sample list of followed places
  final List<Map<String, dynamic>> _followedPlaces = [
    {
      'id': '1',
      'title': 'Jiva Ayurvedic Clinic',
      'location':
          '61, Ground Floor, Rafi Ahmed Kidwai Road, Park Street, Kolkata - 700016',
      'imagePath': 'assets/images/post_image.png',
      'isVerified': true,
      'category': 'Doctors'
    },
    {
      'id': '2',
      'title': 'Jiva Ayurvedic Clinic',
      'location':
          '61, Ground Floor, Rafi Ahmed Kidwai Road, Park Street, Kolkata - 700016',
      'imagePath': 'assets/images/post_image.png',
      'isVerified': true,
      'category': 'Doctors'
    },
    {
      'id': '3',
      'title': 'Jiva Ayurvedic Clinic',
      'location':
          '61, Ground Floor, Rafi Ahmed Kidwai Road, Park Street, Kolkata - 700016',
      'imagePath': 'assets/images/post_image.png',
      'isVerified': true,
      'category': 'Doctors'
    },
  ];

  void _unfollowPlace(String id) {
    // Show confirmation dialog before unfollowing
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unfollow'),
        content: const Text('Are you sure you want to unfollow this place?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Remove the place from the list
              setState(() {
                _followedPlaces.removeWhere((place) => place['id'] == id);
              });
              Navigator.of(context).pop();

              // Show confirmation snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Place unfollowed successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Unfollow'),
          ),
        ],
      ),
    );
  }

  void _viewPlaceDetails(Map<String, dynamic> place) {
    // Navigate to place details screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing details for ${place['title']}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'My Followings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body:
          _followedPlaces.isEmpty ? _buildEmptyState() : _buildFollowingsList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No followings yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Follow your favorite places to see them here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate to discover screen
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Discover Places'),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowingsList() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 20),
      itemCount: _followedPlaces.length,
      itemBuilder: (context, index) {
        final place = _followedPlaces[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Use our reusable component
            ListingItemCard(),
          ],
        );
      },
    );
  }
}
