import 'package:flutter/material.dart';
import 'package:myapp/features/mainPage/widgets/SocialFeedWidget.dart';

import '../../common/navigation/route_manager.dart';
import '../../core/theme/AppTextStyles.dart';
import '../location/LocationSearchPage.dart';

class DemoScreenView extends StatefulWidget {
  const DemoScreenView({super.key});

  @override
  State<DemoScreenView> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreenView> {

  late ScrollController _scrollController;
  late AnimationController _hideBottomBarAnimController;
  bool _isBottomBarVisible = true;

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

  void _navigateToLocationSearch(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LocationSearchPage(
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
     children: [
      Container(
      padding: EdgeInsets.only(
      left: 18,
          right: 18,
          top: 16 +
              MediaQuery.of(context)
                  .padding
                  .top, // Add status bar height padding
          bottom: 22),
      child: Row(
        children: [
          // Location icon and address
          GestureDetector(
            // onTap: () => _navigateToLocationSearch(context),
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
                      const Text(
                        'Charbag',
                        style: AppTextStyles.semiBold18,
                      ),
                      const SizedBox(width: 4),
                      Image.asset(
                        'assets/images/down_arrow.png',
                        width: 13,
                        height: 9,
                      ),
                    ],
                  ),
                  Text(
                    'current location of user with pin code ',
                    style: AppTextStyles.regular12
                        .withColor(const Color(0xFF909090)),
                  ),
                ],
              ),
            ),
          ),
          // Test Description Button
          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (context) => const TestDescriptionPage(),
          //       ),
          //     );
          //   },
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.amber,
          //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          //     minimumSize: const Size(30, 30),
          //   ),
          //   child: const Text('Test', style: TextStyle(fontSize: 12)),
          // ),
          const SizedBox(width: 5),
          // Notification bell
          const Icon(
            Icons.notifications_outlined,
            color: Color(0xFF426DB3),
            size: 25,
          ),
          const SizedBox(width: 10),
          // Profile image
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
    ),
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
    );
  }
}
