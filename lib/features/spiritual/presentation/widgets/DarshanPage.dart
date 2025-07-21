import 'package:flutter/material.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/spiritual/presentation/screens/live_darshan_screen.dart';
import 'package:myapp/features/spiritual/presentation/widgets/DarshanCard.dart';

class DarshanPage extends StatelessWidget {
  const DarshanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading
          // const Text(
          //   'Live Darshan',
          //   style: TextStyle(
          //     fontSize: 22,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),

          // const SizedBox(height: 8),

          // const Text(
          //   'Watch live aarti and darshan from these temples',
          //   style: TextStyle(
          //     fontSize: 14,
          //     color: Colors.grey,
          //   ),
          // ),

          // const SizedBox(height: 24),

          // const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 10),

          // Live darshan cards
          DarshanCard(
            image: 'assets/images/spiritual/darshan.png',
            title: 'Morning Aarti',
            temple: 'Sai Baba Temple',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LiveDarshanScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 10),

          const CommonDivider(),

          const SizedBox(height: 14),

          DarshanCard(
            image: 'assets/images/spiritual/darshan.png',
            title: 'Morning Aarti',
            temple: 'Sai Baba Temple',
            onTap: () {},
          ),

          const SizedBox(height: 8),

          const CommonDivider(),

          const SizedBox(height: 14),

          DarshanCard(
            image: 'assets/images/spiritual/darshan.png',
            title: 'Morning Aarti',
            temple: 'Sai Baba Temple',
            onTap: () {},
          ),

          const SizedBox(height: 8),

          const CommonDivider(),

          // const SizedBox(height: 24),

          // // Upcoming Darshan section
          // const Text(
          //   'Upcoming Darshan',
          //   style: TextStyle(
          //     fontSize: 22,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),

          // const SizedBox(height: 8),

          // const Text(
          //   'Schedule of upcoming aartis and darshans',
          //   style: TextStyle(
          //     fontSize: 14,
          //     color: Colors.grey,
          //   ),
          // ),

          // const SizedBox(height: 16),

          // // Upcoming darshan list
          // _buildUpcomingDarshanItem(
          //   time: '06:30 AM',
          //   title: 'Morning Aarti',
          //   temple: 'Siddhivinayak Temple',
          //   remainingTime: '1 hour remaining',
          // ),

          // const SizedBox(height: 12),

          // _buildUpcomingDarshanItem(
          //   time: '12:00 PM',
          //   title: 'Afternoon Aarti',
          //   temple: 'Sai Baba Temple',
          //   remainingTime: '6 hours remaining',
          // ),

          // const SizedBox(height: 12),

          // _buildUpcomingDarshanItem(
          //   time: '07:00 PM',
          //   title: 'Evening Aarti',
          //   temple: 'Tirupati Balaji Temple',
          //   remainingTime: '13 hours remaining',
          // ),

          // const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildUpcomingDarshanItem({
    required String time,
    required String title,
    required String temple,
    required String remainingTime,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Time column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                remainingTime,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red[400],
                ),
              ),
            ],
          ),

          const SizedBox(width: 24),
          const VerticalDivider(width: 1, thickness: 1,color: Color(0xFFEEEEEE),),
          const SizedBox(width: 24),

          // Temple info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  temple,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Notification bell
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
            color: Colors.grey[700],
          ),
        ],
      ),
    );
  }
}
