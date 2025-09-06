import 'package:flutter/material.dart';

class CoinManagementScreen extends StatelessWidget {
  const CoinManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar with back button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      "Coin",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Coin Balance Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8F7AE8),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    children: [
                      // Coin icon and amount
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: const Icon(
                              Icons.emoji_events_outlined,
                              color: Color(0xFF8F7AE8),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "20",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Coins balance",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Daily Tasks Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  "Daily Tasks",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // First row of daily tasks
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTaskCard(
                        title: "Check-In",
                        coins: 25,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTaskCard(
                        title: "Like Post",
                        coins: 2,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTaskCard(
                        title: "Follow Business",
                        coins: 2,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Second row of daily tasks
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTaskCard(
                        title: "Share App",
                        coins: 25,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTaskCard(
                        title: "Send Enquiry",
                        coins: 25,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTaskCard(
                        title: "Add Review",
                        coins: 5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Buy Coins Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  "Buy Coins",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Coin packages
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildCoinPackageCard(
                        coins: 500,
                        price: 30,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildCoinPackageCard(
                        coins: 1000,
                        price: 50,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildCoinPackageCard(
                        coins: 2000,
                        price: 90,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24), // Add bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard({required String title, required int coins}) {
    return Container(
      height: 130, // Smaller consistent height
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: const Color(0xFF8F7AE8),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Space elements evenly
        children: [
          // Title at the top
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          // Coin amount
          Text(
            "$coins Coins",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          // Claim button at the bottom
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const Text(
              "Claim",
              style: TextStyle(
                color: Color(0xFF8F7AE8),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinPackageCard({required int coins, required int price}) {
    return Container(
      height: 130, // Same height as task cards
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: const Color(0xFF8F7AE8),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Space elements evenly
        children: [
          // Title at the top
          Text(
            "Get\n$coins Coins",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          // Price
          Text(
            "Rs. $price",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          // Buy button at the bottom
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const Text(
              "Buy",
              style: TextStyle(
                color: Color(0xFF8F7AE8),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
