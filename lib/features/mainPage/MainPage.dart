import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/common/navigation/custom_bottom_nav_bar.dart';
import 'package:myapp/features/events/screens/events_screen.dart';
import 'package:myapp/features/posts/screens/SocialFeedWidget.dart';
import 'package:myapp/features/quiz/presentation/screens/quiz_home.dart';
import 'package:myapp/features/spiritual/presentation/screens/spiritual_screen.dart';
import 'package:myapp/features/utsav/views/UtsavPage.dart';
import '../listings/views/categorypage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _showLocationSearch = false;
  late ScrollController _scrollController;
  late AnimationController _hideBottomBarAnimController;
  bool _isBottomBarVisible = true;
  double _lastScrollPosition = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _hideBottomBarAnimController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scrollController.addListener(() {
      // Check scroll direction by comparing current position with last position
      final currentPosition = _scrollController.position.pixels;
      final isScrollingDown = currentPosition > _lastScrollPosition;
      _lastScrollPosition = currentPosition;

      if (isScrollingDown) {
        if (_isBottomBarVisible) {
          _isBottomBarVisible = false;
          _hideBottomBarAnimController.forward();
        }
      } else {
        if (!_isBottomBarVisible) {
          _isBottomBarVisible = true;
          _hideBottomBarAnimController.reverse();
        }
      }
    });

    // Set full screen mode for edge-to-edge experience
    _setFullScreen();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _hideBottomBarAnimController.dispose();
    // Restore system UI when disposing
    _restoreSystemUI();
    super.dispose();
  }

  // Set full screen mode by hiding system UI
  void _setFullScreen() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [], // Hide both status bar and navigation bar
    );
  }

  // Restore system UI when leaving the screen
  void _restoreSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersive,
      overlays: SystemUiOverlay.values, // Show all system overlays
    );
  }

  void _onItemTapped(int index) {
    if (index == 5) {
      // If Quiz is selected, navigate to QuizScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const QuizHome()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
        _showLocationSearch = false;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Main content screens
    final List<Widget> screens = [
      // _showLocationSearch
      //     ? LocationSearchWidget(
      //         currentLocation: 'Sector 38, Noida',
      //         onBackPressed: _toggleLocationSearch,
      //       )
      //     :
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
        const SpiritualScreen(),       // TicketPage(eventId: '68944c4e02145fd86b8da317',),
        const ListingsPageTest(),
        const UtsavPage(),
        const EventsScreen(),
        const QuizHome(),
    ];

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      // Remove the app bar since we're including it in the content
      body: screens[_selectedIndex], // Don't wrap in SafeArea for edge-to-edge
      bottomNavigationBar: _showLocationSearch
          ? null
          : CustomBottomNavBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
              hideAnimationController: _hideBottomBarAnimController,
            ),
      extendBody: true, // Extend content behind the bottom navigation bar
      extendBodyBehindAppBar: true, // Extend content behind the app bar area
      resizeToAvoidBottomInset: true,
    );
  }
}
