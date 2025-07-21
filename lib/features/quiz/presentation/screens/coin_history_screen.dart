import 'package:flutter/material.dart';

class CoinHistoryScreen extends StatelessWidget {
  const CoinHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for coin history
    final List<Map<String, dynamic>> historyItems = [
      {
        'action': 'Used 50-50 lifeline',
        'date': '24 Mar, 2025',
        'coins': -10,
      },
      {
        'action': 'Used 50-50 lifeline',
        'date': '24 Mar, 2025',
        'coins': -10,
      },
      {
        'action': 'Daily quiz completed',
        'date': '23 Mar, 2025',
        'coins': 20,
      },
      {
        'action': 'Watched ad for coins',
        'date': '23 Mar, 2025',
        'coins': 5,
      },
      {
        'action': 'Completed health quiz',
        'date': '22 Mar, 2025',
        'coins': 50,
      },
      {
        'action': 'Used skip question',
        'date': '22 Mar, 2025',
        'coins': -15,
      },
      {
        'action': 'Referral bonus',
        'date': '21 Mar, 2025',
        'coins': 100,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          // Custom app bar with back button
          Container(
            color: const Color(0xFFF5F7FA),
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                bottom: 16,
                left: 16,
                right: 16,
              ),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Title
                  const Text(
                    "Coin History",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // List of coin history items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: historyItems.length,
              itemBuilder: (context, index) {
                final item = historyItems[index];
                return _buildCoinHistoryItem(
                  action: item['action'] as String,
                  date: item['date'] as String,
                  coins: item['coins'] as int,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinHistoryItem({
    required String action,
    required String date,
    required int coins,
  }) {
    final bool isNegative = coins < 0;
    final String coinText = isNegative ? "$coins" : "+$coins";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // Coin amount
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isNegative ? const Color(0xFFEF4444) : Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              coinText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
