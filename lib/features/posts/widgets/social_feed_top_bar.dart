import 'package:flutter/material.dart';
import 'package:myapp/common/navigation/route_manager.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:myapp/features/location/LocationSearchPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Top bar widget for the social feed containing location, notifications, and profile
class SocialFeedTopBar extends StatefulWidget {
  /// Callback when location is changed
  final VoidCallback? onLocationChanged;
  
  /// Creates a [SocialFeedTopBar] widget
  const SocialFeedTopBar({super.key, this.onLocationChanged});

  @override
  State<SocialFeedTopBar> createState() => _SocialFeedTopBarState();
}

class _SocialFeedTopBarState extends State<SocialFeedTopBar> with WidgetsBindingObserver {
  String _locationName = 'Charbag';
  String _locationAddress = 'current location of user with pin code';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadSelectedLocation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
    return Container(
      padding: EdgeInsets.only(
        left: 18,
        right: 18,
        top: 16 + MediaQuery.of(context).padding.top, // Add status bar height padding
        bottom: 22,
      ),
      child: Row(
        children: [
          // Location icon and address
          GestureDetector(
            onTap: () => _navigateToLocationSearch(context),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color(0xFF426DB3).withValues(alpha: 0.23),
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
                      Flexible(
                        child: Text(
                          _locationName,
                          style: AppTextStyles.semiBold18,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                    _locationAddress,
                    style: AppTextStyles.regular12
                        .withColor(const Color(0xFF909090)),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
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
    );
  }

  /// Navigates to the location search page
  void _navigateToLocationSearch(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LocationSearchPage(),
      ),
    );
    
    // Reload location if user made a selection
    if (result != null) {
      await _loadSelectedLocation();
      // Notify parent widget about location change
      widget.onLocationChanged?.call();
    }
  }
}
