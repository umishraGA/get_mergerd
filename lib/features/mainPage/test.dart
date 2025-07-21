import 'package:flutter/material.dart';
import 'package:myapp/features/mainPage/widgets/SocialFeedWidget.dart';


// Mock of RouteManager
class RouteManager {
  static const String profilePage = '/profile';
}

// Main Widget
class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoState();
}

class _DemoState extends State<DemoScreen> {

  late ScrollController _scrollController;
  late AnimationController _hideBottomBarAnimController;
  bool _isBottomBarVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopBar(context),
            Column(
              children: [
                // Scrollable content
                Expanded(
                  child: SocialFeedWidget(
                    scrollController: _scrollController,
                    onDetailViewVisible: (isVisible) {
                      // Hide the bottom navigation bar when detail view is visible
                      if (isVisible) {
                        _hideBottomBar();
                      } else {
                        _showBottomBar();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToLocationSearch(BuildContext context) {
    // You can replace this with actual navigation
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Navigate to Location')));
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 18,
        right: 18,
        top: 16 + MediaQuery.of(context).padding.top,
        bottom: 22,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _navigateToLocationSearch(context),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color(0xFF426DB3).withOpacity(0.23),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.location_on,
                color: Color(0xFF426DB3),
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => _navigateToLocationSearch(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Charbag', style: TextStyle()),
                      const SizedBox(width: 4),
                      Image.asset(
                        'assets/images/down_arrow.png',
                        width: 13,
                        height: 9,
                      ),
                    ],
                  ),
                  Text(
                    'current location of user with pin code',
                    style: TextStyle()),
                ],
              ),
            ),
          ),
          const SizedBox(width: 5),
          const Icon(
            Icons.notifications_outlined,
            color: Color(0xFF426DB3),
            size: 25,
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, RouteManager.profilePage);
            },
            child: const CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/images/profile_pic.png'),
            ),
          ),
        ],
      ),
    );
  }
  void _hideBottomBar() {
    setState(() {
      _isBottomBarVisible = false;
      _hideBottomBarAnimController.forward();
    });
  }

  void _showBottomBar() {
    setState(() {
      _isBottomBarVisible = true;
      _hideBottomBarAnimController.reverse();
    });
  }
}
