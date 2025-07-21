import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/common/navigation/route_manager.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:myapp/features/location/LocationSearchPage.dart';

class TopAppBarCustom extends StatelessWidget {
  const TopAppBarCustom({
    super.key,
    this.color = const Color(0xFFE13C40),
    this.textColor = Colors.white,
    this.subTitleColor = Colors.white,
    this.isVisibleSearchBar = true,
  });

  final Color color;
  final Color textColor;
  final Color subTitleColor;
  final bool isVisibleSearchBar;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping on the app bar
        FocusScope.of(context).unfocus();
      },
      child: Container(
        decoration: BoxDecoration(
          color: color, // Red background
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          ),
        ),
        padding: EdgeInsets.only(
            left: 18,
            right: 18,
            top: 16 +
                MediaQuery.of(context)
                    .padding
                    .top, // Add status bar height padding
            bottom: isVisibleSearchBar ? 22 : 0),
        child: Column(
          children: [
            Row(
              children: [
                // Location icon and address
                GestureDetector(
                  onTap: () => _navigateToLocationSearch(context),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: textColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: textColor,
                      size: 24,
                    ),
                  ),
                ),

                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _navigateToLocationSearch(context),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Charbag',
                            style:
                                AppTextStyles.semiBold18.withColor(textColor),
                          ),
                          const SizedBox(width: 4),
                          Image.asset(
                            'assets/images/down_arrow.png',
                            width: 13,
                            height: 9,
                            color: textColor,
                          )
                        ],
                      ),
                      Text(
                        'Mattyari,Lucknow - 226028',
                        style: AppTextStyles.regular12.withColor(subTitleColor),
                      ),
                    ],
                  ),
                  ),
                ),
                // Notification bell
                GestureDetector(
                  onTap: () => _navigateToLocationSearch(context),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    // decoration: BoxDecoration(
                    //   color: textColor.withOpacity(0.23),
                    //   borderRadius: BorderRadius.circular(4),
                    // ),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: textColor,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
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
            const SizedBox(height: 16),
            if (isVisibleSearchBar)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
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
                          child: RotatingHintTextField(),
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
              )
          ],
        ),
      ),
    );
  }

  void _navigateToLocationSearch(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LocationSearchPage(
        ),
      ),
    );
  }
}

/// A TextField with a hint that changes every 2 seconds
class RotatingHintTextField extends StatefulWidget {
  const RotatingHintTextField({super.key});

  @override
  State<RotatingHintTextField> createState() => _RotatingHintTextFieldState();
}

class _RotatingHintTextFieldState extends State<RotatingHintTextField> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _searchSuggestions = [
    'Search for \'Wedding Planner\'',
    'Search for \'Restaurants\'',
    'Search for \'Hotels\'',
    'Search for \'Doctors\'',
    'Search for \'Clinics\'',
    'Search for \'Temples\'',
    'Search for \'Events\'',
  ];

  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start the timer to change suggestions every 2 seconds
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _searchSuggestions.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 15,
          bottom: 12,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        filled: true,
        fillColor: Colors.white,
        hintText: _searchSuggestions[_currentIndex],
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
    );
  }
}
