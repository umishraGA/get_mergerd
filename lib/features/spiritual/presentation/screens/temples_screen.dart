import 'package:flutter/material.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';

import 'temple_detail_screen.dart';

class TemplesScreen extends StatefulWidget {
  const TemplesScreen({super.key});

  @override
  State<TemplesScreen> createState() => _TemplesScreenState();
}

class _TemplesScreenState extends State<TemplesScreen> {
  // Track which temple descriptions are expanded
  final List<bool> _expandedDescriptions = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppHeader(title: 'Temples', showShare: false),
            // Header banner with India map
            _buildHeaderBanner(context),

            // Search bar
            _buildSearchBar(),

            // Temple categories
            _buildTempleCategories(),

            // Divider
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: CommonDivider(),
            ),

            // Temple listings
            _buildTempleListing(context, 0),
            _buildTempleListing(context, 1),
            _buildTempleListing(context, 2),
            _buildTempleListing(context, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Image.asset(
        'assets/images/spiritual/india_map.png',
        fit: BoxFit.contain,
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget _buildSearchBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Row(
            children: [
              const Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  child: TextField(
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: 'Search for temple',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 15,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(8),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTempleCategories() {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return SizedBox(
      height: isTablet ? 160 : 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        children: [
          _buildCategoryItem('All', 'assets/images/spiritual/all_temples.png'),
          _buildCategoryItem('Ayodhya', 'assets/images/spiritual/ayodhya.png'),
          _buildCategoryItem('Bhopal', 'assets/images/spiritual/bhopal.png'),
          _buildCategoryItem(
              'Prayagraj', 'assets/images/spiritual/prayagraj.png'),
          _buildCategoryItem(
              'Varanasi', 'assets/images/spiritual/prayagraj.png'),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String name, String imagePath) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return Container(
      width: isTablet ? 120 : 70,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isTablet ? 120 : 70,
            height: isTablet ? 120 : 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTempleListing(BuildContext context, int index) {
    // Sample temple data - in a real app, this would come from an API or database
    const String fullDescription =
        'A huge building has been constructed for satsang in the temple, in which 25000 people can sit together. The walls temple, in which 25000 people together. The walls of the temple are adorned with beautiful carvings depicting scenes from the Ramayana. The temple is a symbol of faith and devotion for millions of Hindus around the world. The grand structure features intricate architecture that blends traditional temple styles with modern engineering techniques. Visitors can explore the main sanctum, prayer halls, and surrounding gardens during visiting hours. Special ceremonies and rituals are performed during festivals and auspicious occasions.';

    final isTablet = MediaQuery.of(context).size.width > 600;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TempleDetailScreen(
              templeName: 'Ayodhya Ram Mandir',
              location: 'Uttar Pradesh',
              imagePath: 'assets/images/spiritual/ayodhya_temple.png',
              description: fullDescription,
              followers: 10100,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Temple image
                Container(
                  height: isTablet ? 360 : 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    'assets/images/spiritual/ayodhya_temple.png',
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 12),

                // Temple info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Temple name and location
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Ayodhya',
                              style: AppTextStyles.bold16.copyWith(
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified,
                              color: Colors.green,
                              size: 16,
                            ),
                          ],
                        ),
                        Text(
                          'Uttar Pradesh',
                          style: AppTextStyles.medium14.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    // Followers count
                    Row(
                      children: [
                        Text(
                          '10.1k Followers',
                          style: AppTextStyles.medium15.copyWith(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Temple description - expanded or collapsed based on state
                Text(
                  fullDescription,
                  style: AppTextStyles.medium15.copyWith(
                    color: Colors.black87,
                    height: 1.3,
                  ),
                  maxLines: _expandedDescriptions[index] ? null : 3,
                  overflow: _expandedDescriptions[index]
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                // More/Less button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _expandedDescriptions[index] =
                          !_expandedDescriptions[index];
                    });
                  },
                  child: Text(
                    _expandedDescriptions[index] ? 'less' : 'more',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Divider between temple listings
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CommonDivider(),
          ),
        ],
      ),
    );
  }
}
