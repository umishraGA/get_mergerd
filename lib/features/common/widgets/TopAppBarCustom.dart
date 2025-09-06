import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/common/navigation/route_manager.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:myapp/features/location/LocationSearchPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopAppBarCustom extends StatefulWidget {
  const TopAppBarCustom({
    super.key,
    this.color = const Color(0xFFE13C40),
    this.textColor = Colors.white,
    this.subTitleColor = Colors.white,
    this.isVisibleSearchBar = true,
    this.onSearchSubmitted,
  });

  final Color color;
  final Color textColor;
  final Color subTitleColor;
  final bool isVisibleSearchBar;
  final Function(String)? onSearchSubmitted;

  @override
  State<TopAppBarCustom> createState() => _TopAppBarCustomState();
}

class _TopAppBarCustomState extends State<TopAppBarCustom> with WidgetsBindingObserver {
  String _locationName = 'Charbag';
  String _locationAddress = 'Mattyari,Lucknow - 226028';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadSelectedLocation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadSelectedLocation();
    }
  }

  Future<void> _loadSelectedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('selected_location_name');
      final address = prefs.getString('selected_location_address');
      
      if (name != null && address != null) {
        setState(() {
          _locationName = name;
          _locationAddress = address;
        });
      }
    } catch (e) {
      debugPrint('Error loading selected location: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping on the app bar
        FocusScope.of(context).unfocus();
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.color, // Red background
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
            bottom: widget.isVisibleSearchBar ? 22 : 0),
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
                      color: widget.textColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: widget.textColor,
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
                          Flexible(
                            child: Text(
                              _locationName,
                              style:
                                  AppTextStyles.semiBold18.withColor(widget.textColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Image.asset(
                            'assets/images/down_arrow.png',
                            width: 13,
                            height: 9,
                            color: widget.textColor,
                          )
                        ],
                      ),
                      Text(
                        _locationAddress,
                        style: AppTextStyles.regular12.withColor(widget.subTitleColor),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
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
                      color: widget.textColor,
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
            if (widget.isVisibleSearchBar)
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
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                          child: RotatingHintTextField(
                            controller: _searchController,
                            onSearchSubmitted: widget.onSearchSubmitted,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          final text = _searchController.text.trim();
                          if (text.isNotEmpty) {
                            widget.onSearchSubmitted?.call(text);
                          }
                        },
                        child: Container(
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

  void _navigateToLocationSearch(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LocationSearchPage(),
      ),
    );
    
    // Reload location if user made a selection
    if (result != null) {
      _loadSelectedLocation();
    }
  }
}

/// A TextField with a hint that changes every 2 seconds
class RotatingHintTextField extends StatefulWidget {
  const RotatingHintTextField({
    super.key,
    this.controller,
    this.onSearchSubmitted,
  });

  final TextEditingController? controller;
  final Function(String)? onSearchSubmitted;

  @override
  State<RotatingHintTextField> createState() => _RotatingHintTextFieldState();
}

class _RotatingHintTextFieldState extends State<RotatingHintTextField> {
  late final TextEditingController _controller;
  final List<String> _searchSuggestions = [
    'Search for \'Wedding Planner\'',
    'Search for \'Restaurants\'',
    'Search for \'Hotels\'',
    'Search for \'Beauty Salon\'',
    'Search for \'Event Venues\'',
    'Search for \'Catering\'',
    'Search for \'Photography\'',
  ];

  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
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
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      cursorColor: Colors.black,
      onSubmitted: (value) {
        if (value.trim().isNotEmpty) {
          widget.onSearchSubmitted?.call(value.trim());
        }
      },
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
