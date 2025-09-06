import 'package:flutter/material.dart';

class DonationScreen extends StatelessWidget {
  const DonationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'DONATION',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Green gradient donation card
              DonationCard(
                title: 'Lite Donation',
                subtitle: 'A support towards',
                amount: 1000,
                gradientColors: const [
                  Color(0xFF0A3F2E),
                  Color(0xFF1E7E51),
                ],
                isPopular: false,
                onTap: () => _processDonation(context, 'Lite Donation', 1000),
              ),

              const SizedBox(height: 16),

              // Orange gradient donation card with "Most Popular" badge
              DonationCard(
                title: 'Lite Donation',
                subtitle: 'A support towards',
                amount: 1000,
                gradientColors: const [
                  Color(0xFFAA5F39),
                  Color(0xFFE57F43),
                ],
                isPopular: true,
                onTap: () => _processDonation(context, 'Lite Donation', 1000),
              ),

              const SizedBox(height: 16),

              // Additional donation options could be added here
              DonationCard(
                title: 'Standard Donation',
                subtitle: 'Help our cause grow',
                amount: 2500,
                gradientColors: const [
                  Color(0xFF1F4690),
                  Color(0xFF3A8DDE),
                ],
                isPopular: false,
                onTap: () =>
                    _processDonation(context, 'Standard Donation', 2500),
              ),

              const SizedBox(height: 16),

              DonationCard(
                title: 'Premium Donation',
                subtitle: 'Make a significant impact',
                amount: 5000,
                gradientColors: const [
                  Color(0xFF6A1B9A),
                  Color(0xFF9C27B0),
                ],
                isPopular: false,
                onTap: () =>
                    _processDonation(context, 'Premium Donation', 5000),
              ),

              const SizedBox(height: 24),

              // Custom amount section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Custom Amount',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixText: 'Rs. ',
                        hintText: 'Enter amount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            _processDonation(context, 'Custom Donation', 0),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Donate Now',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Info section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Why Donate?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your donations help support mosque maintenance, community services, educational programs, and charitable activities for those in need.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _processDonation(BuildContext context, String type, int amount) {
    // Here you would typically integrate with a payment gateway
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Processing Donation'),
        content: Text(
            'Processing $type of Rs. ${amount == 0 ? 'custom amount' : amount}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class DonationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int amount;
  final List<Color> gradientColors;
  final bool isPopular;
  final VoidCallback onTap;

  const DonationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.gradientColors,
    required this.isPopular,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side - title and subtitle
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  // Right side - amount
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Rs. $amount',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // "Most Popular" badge
            if (isPopular)
              Positioned(
                top: 0,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Most Popular',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
