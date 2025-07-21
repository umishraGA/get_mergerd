import 'package:flutter/material.dart';
import 'package:myapp/features/spiritual/presentation/screens/live_darshan_player_screen.dart';
import 'package:myapp/features/spiritual/presentation/widgets/DarshanCard.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';

class LiveDarshanScreen extends StatefulWidget {
  const LiveDarshanScreen({super.key});

  @override
  State<LiveDarshanScreen> createState() => _LiveDarshanScreenState();
}

class _LiveDarshanScreenState extends State<LiveDarshanScreen> {
  final List<Map<String, String>> _darshanList = [
    {
      'image': 'assets/images/spiritual/darshan.png',
      'title': 'Morning Aarti',
      'temple': 'Sai Baba Temple',
    },
    {
      'image': 'assets/images/spiritual/darshan.png',
      'title': 'Evening Aarti',
      'temple': 'Iskon Temple',
    },
    {
      'image': 'assets/images/spiritual/darshan.png',
      'title': 'Noon Aarti',
      'temple': 'Shiva Temple',
    },
  ];

  void _navigateToPlayerScreen(Map<String, String> darshan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveDarshanPlayerScreen(
          image: darshan['image'] ?? '',
          title: darshan['title'] ?? '',
          temple: darshan['temple'] ?? '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: Column(
        children: [
          const AppHeader(title: 'Live Darshan'),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              itemCount: _darshanList.length,
              separatorBuilder: (context, index) => const Divider(
                color: Color(0xFFEEEEEE),
                height: 1,
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final darshan = _darshanList[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: DarshanCard(
                    image: darshan['image'] ?? '',
                    title: darshan['title'] ?? '',
                    temple: darshan['temple'] ?? '',
                    onTap: () => _navigateToPlayerScreen(darshan),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
