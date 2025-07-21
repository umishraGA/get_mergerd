import 'package:flutter/material.dart';

class LocationSearchWidget extends StatelessWidget {
  final VoidCallback onBackPressed;

  const LocationSearchWidget({
    super.key,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header with back button and location
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Back button
                InkWell(
                  onTap: onBackPressed,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFBB9F9F)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Location text
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sector 38',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Noida',
                        style: TextStyle(
                          color: Color(0xFF909090),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Search input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF909090)),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Color(0xFF909090),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Start typing your location',
                          hintStyle: TextStyle(
                              color: Color(0xFF909090),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              backgroundColor: Colors.transparent),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                          fillColor: Colors.transparent,
                          focusedBorder: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Auto-detect location button
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFEAEBFF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Auto-detect current location',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Icon(
                    Icons.my_location,
                    color: Color(0xFF426DB3),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // Saved address section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SAVED ADDRESS',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF909090),
                  ),
                ),
                const SizedBox(height: 12),
                _buildAddressItem(
                  icon: Icons.location_on,
                  title: 'Faizabad Road Sanjay gandhi puram',
                  subtitle: 'hhh, yy, Faizabad Road, Sanjay Gandhi Puram...',
                ),
              ],
            ),
          ),

          // Recent searches section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'RECENT SEARCHES',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF909090),
                      ),
                    ),
                    Text(
                      'Clear',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildRecentSearchItem(
                  icon: Icons.history,
                  text: 'Sector 38',
                ),
                const SizedBox(height: 12),
                _buildRecentSearchItem(
                  icon: Icons.history,
                  text: 'Chinahot',
                ),
              ],
            ),
          ),

          // Popular localities section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'POPULAR LOCALITIES',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF909090),
                  ),
                ),
                const SizedBox(height: 12),
                _buildPopularLocalityItem(
                  text: 'Sector 38, Noida',
                  distance: '3M',
                ),
                const SizedBox(height: 12),
                _buildPopularLocalityItem(
                  text: 'DLF Mall of India, Noida',
                  distance: '992M',
                ),
                const SizedBox(height: 12),
                _buildPopularLocalityItem(
                  text: 'Sector 18, Noida',
                  distance: '1.2KM',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey,
          size: 24,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF909090),
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentSearchItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey,
          size: 24,
        ),
        const SizedBox(width: 16),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildPopularLocalityItem({
    required String text,
    required String distance,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              Icons.trending_up,
              color: Colors.grey,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        Text(
          distance,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
