import 'package:flutter/material.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';

class FestivalScreen extends StatefulWidget {
  const FestivalScreen({super.key});

  @override
  State<FestivalScreen> createState() => _FestivalScreenState();
}

class _FestivalScreenState extends State<FestivalScreen> {
  // Track expanded months
  final Map<String, bool> _expandedMonths = {
    'January 2025': true,
    'February 2025': false,
    'March 2025': false,
    'April 2025': false,
    'May 2025': false,
    'June 2025': false,
    'July 2025': false,
    'August 2025': false,
    'September 2025': false,
    'October 2025': false,
    'November 2025': false,
    'December 2025': false,
  };

  // Sample festival data
  final Map<String, List<Map<String, String>>> _festivals = {
    'January 2025': [
      {
        'name': 'Chandra Darshana',
        'date': 'January 1, 2025, Wednesday',
        'ritual': 'Pausha Shukla Pratipada',
        'image': 'assets/images/spiritual/darshan.png',
      },
      {
        'name': 'Chandra Darshana',
        'date': 'January 1, 2025, Wednesday',
        'ritual': 'Pausha Shukla Pratipada',
        'image': 'assets/images/spiritual/darshan.png',
      },
      {
        'name': 'Chandra Darshana',
        'date': 'January 1, 2025, Wednesday',
        'ritual': 'Pausha Shukla Pratipada',
        'image': 'assets/images/spiritual/darshan.png',
      },
    ],
    'February 2025': [],
    'March 2025': [],
    'April 2025': [],
    'May 2025': [],
    'June 2025': [],
    'July 2025': [],
    'August 2025': [],
    'September 2025': [],
    'October 2025': [],
    'November 2025': [],
    'December 2025': [],
  };

  void _toggleExpanded(String month) {
    setState(() {
      _expandedMonths[month] = !(_expandedMonths[month] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // App header with back button and title
          const AppHeader(title: 'Festivals'),

          // Featured festival card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/images/spiritual/hinduism_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Understanding',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Energy, Black Magic & Protection',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Month-wise festivals list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: _expandedMonths.length,
              itemBuilder: (context, index) {
                final month = _expandedMonths.keys.elementAt(index);
                final isExpanded = _expandedMonths[month] ?? false;

                return Column(
                  children: [
                    // Month header with expand/collapse
                    InkWell(
                      onTap: () => _toggleExpanded(month),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        color: const Color(0xFFF5F5F5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              month,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Festival items for this month (if expanded)
                    if (isExpanded) ..._buildFestivalItems(month),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFestivalItems(String month) {
    final festivals = _festivals[month] ?? [];

    if (festivals.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'No festivals in this month',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
      ];
    }

    return festivals.map((festival) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Row(
          children: [
            // Festival image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(festival['image'] ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Festival details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    festival['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    festival['date'] ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    festival['ritual'] ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
