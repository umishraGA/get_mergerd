import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:myapp/common/navigation/custom_bottom_nav_bar.dart';
import 'package:myapp/features/common/widgets/BannerCorousal.dart';
import 'package:myapp/features/spiritual/presentation/screens/aarti_chalisa_screen.dart';
import 'package:myapp/features/spiritual/presentation/screens/articles_screen.dart';
import 'package:myapp/features/spiritual/presentation/screens/festival_screen.dart';
import 'package:myapp/features/spiritual/presentation/screens/live_darshan_screen.dart';
import 'package:myapp/features/spiritual/presentation/screens/panchang_details_screen.dart';
import 'package:myapp/features/spiritual/presentation/screens/temples_screen.dart';

class HinduismScreen extends StatefulWidget {
  final String? bannerImage;

  const HinduismScreen({
    super.key,
    this.bannerImage,
  });

  @override
  State<HinduismScreen> createState() => _HinduismScreenState();
}

class _HinduismScreenState extends State<HinduismScreen> {
  final AudioPlayer _ramPlayer = AudioPlayer();
  final AudioPlayer _hanumanPlayer = AudioPlayer();
  bool _isPlaying = false;
  final String _selectedTab = 'Ram';
  late String _bannerImage;

  @override
  void initState() {
    super.initState();
    _initAudio();
    _bannerImage = widget.bannerImage ??
        'assets/images/spiritual/backgrounds/hinduism_bg.png';
  }

  Future<void> _initAudio() async {
    try {
      await _ramPlayer.setAsset('assets/audio/shriram_jairam.mp3');
      await _hanumanPlayer.setAsset('assets/audio/hanumanchalisa.mp3');
    } catch (e) {
      debugPrint('Error initializing audio: $e');
    }
  }

  @override
  void dispose() {
    _ramPlayer.dispose();
    _hanumanPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String type) async {
    try {
      // Stop any currently playing audio
      if (_isPlaying) {
        await _ramPlayer.stop();
        await _hanumanPlayer.stop();
      }

      // Play the selected audio
      final player = type == 'Ram' ? _ramPlayer : _hanumanPlayer;
      await player.seek(Duration.zero);
      await player.play();
      setState(() {
        _isPlaying = true;
      });
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  Future<void> _stopAudio() async {
    try {
      await _ramPlayer.stop();
      await _hanumanPlayer.stop();
      setState(() {
        _isPlaying = false;
      });
    } catch (e) {
      debugPrint('Error stopping audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true, // Make body extend behind bottom navigation bar
      body: CustomScrollView(
        slivers: [
          // App Bar with background
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: const Color(0xFFFDBB45), // Golden background
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background image with temple graphics
                  Image.asset(
                    _bannerImage,
                    fit: BoxFit.cover,
                  ),
                  // Opacity overlay for better text visibility
                  Container(
                    color: Colors.yellow.withOpacity(0.3),
                  ),
                ],
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
            title: const Text(
              'Hinduism',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/profile_pic.png'),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                          child: TextField(
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              hintText: 'Search for temple',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 15,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
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
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Audio Player Section
                const AudioPlayerWidget(),

                // Featured section
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Text(
                    'Featured',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Calculate optimal aspect ratio based on available width
                      final itemWidth = (constraints.maxWidth - 0) /
                          3; // 3 columns with 8px spacing
                      final aspectRatio =
                          itemWidth / (itemWidth + 16); // Add height for text

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: aspectRatio,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                        ),
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          final List<Map<String, Object>> features = [
                            {
                              'title': 'Temple',
                              'imagePath': 'assets/images/spiritual/temple.png',
                              'onTap': () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TemplesScreen(),
                                  ),
                                );
                              },
                            },
                            {
                              'title': 'Aarti',
                              'imagePath': 'assets/images/spiritual/aarti.png',
                              'onTap': () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AartiChalisaScreen(),
                                  ),
                                );
                              },
                            },
                            {
                              'title': 'Dharmik Gyan',
                              'imagePath': 'assets/images/spiritual/book.png',
                              'onTap': () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PanchangDetailsScreen(),
                                  ),
                                );
                              },
                            },
                            {
                              'title': 'Articles',
                              'imagePath':
                                  'assets/images/spiritual/articles.png',
                              'onTap': () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ArticlesScreen(),
                                  ),
                                );
                              },
                            },
                            {
                              'title': 'Festivals',
                              'imagePath':
                                  'assets/images/spiritual/festivals.png',
                              'onTap': () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const FestivalScreen(),
                                  ),
                                );
                              },
                            },
                            {
                              'title': 'Live Darshan',
                              'imagePath': 'assets/images/spiritual/book.png',
                              'onTap': () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const LiveDarshanScreen(),
                                  ),
                                );
                              },
                            },
                          ];

                          return _buildFeatureGridCard(
                            features[index]['title'] as String,
                            features[index]['imagePath'] as String,
                            context,
                            itemWidth: itemWidth,
                            onTap: features[index]['onTap'] as VoidCallback,
                          );
                        },
                      );
                    },
                  ),
                ),

                // Spiritual Information section
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 16),
                  child: Text(
                    'Spiritual Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PanchangDetailsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.asset(
                        'assets/images/spiritual/mandala_pattern.png',
                        fit: BoxFit.fitHeight,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),

                // Vishu banner
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF6C00), // Orange background
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: AssetImage(
                            'assets/images/spiritual/vishu_banner.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // Upcoming Pujas section
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Text(
                    'Upcoming Pujas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                Bannercorousal(
                  imagePaths: const [
                    'assets/images/spiritual/ram_navmi.png',
                    'assets/images/spiritual/ram_navmi.png',
                    'assets/images/spiritual/ram_navmi.png',
                  ],
                  height: isTablet ? 280 : 160,
                  // viewportFraction: 0.93,
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bless',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const Text(
                        'Yourself!',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Designed with divine blessings in India.',
                        style: TextStyle(
                          color: Colors.grey.withOpacity(0.7),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: CustomBottomNavBar(
          selectedIndex: 1, // Selected index 1 for Spiritual tab
          onItemTapped: (index) {
            // Handle navigation between tabs
            if (index != 1) {
              // Only navigate if not already on this tab
              Navigator.pop(context);
              // Additional navigation logic could be added here
            }
          },
        ),
      ),
    );
  }

  Widget _buildFeatureGridCard(
      String title, String imagePath, BuildContext context,
      {VoidCallback? onTap, double? itemWidth}) {
    // Default container size if itemWidth not provided
    final double containerSize = itemWidth != null ? itemWidth * 0.85 : 90;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
              color: const Color(0xFFFEE7AA), // Light golden background
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: containerSize,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: 'FacebookSans',
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({super.key});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _ramPlayer = AudioPlayer();
  final AudioPlayer _hanumanPlayer = AudioPlayer();
  bool _isPlaying = false;
  int _selectedTab = 0; // 0 for Ram, 1 for Hanuman Chalisa
  // Keep track of active player stream subscriptions
  StreamSubscription<PlayerState>? _ramPlayerSubscription;
  StreamSubscription<PlayerState>? _hanumanPlayerSubscription;

  // Add a counter for tracking loops completed
  int _loopCount = 0;

  @override
  void initState() {
    super.initState();
    _initAudio();
    _setupPlayerListeners();
  }

  Future<void> _initAudio() async {
    try {
      // Set loop mode to true for both players
      await _ramPlayer.setLoopMode(LoopMode.one);
      await _hanumanPlayer.setLoopMode(LoopMode.one);

      await _ramPlayer.setAsset('assets/audio/shriram_jairam.mp3');
      await _hanumanPlayer.setAsset('assets/audio/hanumanchalisa.mp3');
    } catch (e) {
      debugPrint('Error initializing audio: $e');
    }
  }

  void _setupPlayerListeners() {
    // Setup listeners for both players to detect completion
    _ramPlayerSubscription = _ramPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed && mounted) {
        // Increment loop count when audio completes
        setState(() {
          if (_isPlaying) {
            _loopCount++;
          }
        });

        // No need to reset playing state since we've enabled looping
        debugPrint('Ram audio completed, loopCount: $_loopCount');
      }
    });

    _hanumanPlayerSubscription =
        _hanumanPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed && mounted) {
        // Increment loop count when audio completes
        setState(() {
          if (_isPlaying) {
            _loopCount++;
          }
        });

        // No need to reset playing state since we've enabled looping
        debugPrint('Hanuman audio completed, loopCount: $_loopCount');
      }
    });

    // Additional listeners for position stream to detect loop completion
    _ramPlayer.positionStream.listen((position) {
      _checkForLoopCompletion(_ramPlayer, position);
    });

    _hanumanPlayer.positionStream.listen((position) {
      _checkForLoopCompletion(_hanumanPlayer, position);
    });
  }

  // Helper method to check for loop completion more reliably
  void _checkForLoopCompletion(AudioPlayer player, Duration position) async {
    try {
      if (!_isPlaying || position.inMilliseconds == 0) return;

      final duration = player.duration;
      if (duration != null &&
          position.inMilliseconds > 0 &&
          position.inMilliseconds >= duration.inMilliseconds - 200) {
        // We're at the end of the track, about to loop
        if (mounted &&
            player == (_selectedTab == 0 ? _ramPlayer : _hanumanPlayer)) {
          setState(() {
            _loopCount++;
          });
          debugPrint(
              'Loop detected at position: $position, duration: $duration, count: $_loopCount');
        }
      }
    } catch (e) {
      debugPrint('Error in loop detection: $e');
    }
  }

  @override
  void dispose() {
    _ramPlayerSubscription?.cancel();
    _hanumanPlayerSubscription?.cancel();
    _ramPlayer.dispose();
    _hanumanPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    // Update UI state immediately for responsiveness
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (!_isPlaying) {
      // We just set _isPlaying to false, so we're stopping
      try {
        await _ramPlayer.stop();
        await _hanumanPlayer.stop();
        debugPrint('Audio stopped successfully');
      } catch (e) {
        debugPrint('Error stopping audio: $e');
      }
    } else {
      // We just set _isPlaying to true, so we're starting
      try {
        // Make sure both players are stopped first
        await _ramPlayer.stop();
        await _hanumanPlayer.stop();

        // Play the selected audio track
        if (_selectedTab == 0) {
          await _ramPlayer.seek(Duration.zero);
          await _ramPlayer.play();
          debugPrint('Ram audio started');
        } else {
          await _hanumanPlayer.seek(Duration.zero);
          await _hanumanPlayer.play();
          debugPrint('Hanuman audio started');
        }
      } catch (e) {
        debugPrint('Error playing audio: $e');
        // Reset play state in case of error
        setState(() {
          _isPlaying = false;
        });
      }
    }
  }

  void _resetCount() {
    setState(() {
      _loopCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define UI colors based on selected tab
    final Color backgroundColor = _selectedTab == 0
        ? const Color(0xFF493240) // Ram tab dark purple
        : const Color(0xFFFAB87F); // Hanuman tab orange

    final Color selectedTabColor = _selectedTab == 0
        ? const Color(0xFFCE3889) // Ram tab bright pink
        : const Color(0xFFEF8C40); // Hanuman tab bright orange

    final Color counterTextColor =
        _selectedTab == 0 ? Colors.white : Colors.black;

    final isTablet = MediaQuery.of(context).size.width > 600;

    return Container(
      height: isTablet ? 320 : 220,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 8,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
        // border: Border.all(
        //   color: Colors.white.withOpacity(0.2),
        //   width: 1.5,
        // ),
      ),
      child: Stack(
        children: [
          // Background image - positioned to bottom left
          Positioned(
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Image.asset(
                _selectedTab == 0
                    ? 'assets/images/spiritual/ram.png'
                    : 'assets/images/spiritual/hanuman.png',
                height: isTablet ? 320 : 220,
                fit: BoxFit.fill,
                width: double.infinity,
              ),
            ),
          ),

          // Counter section - right aligned
          Positioned(
            right: isTablet ? 100 : 12,
            bottom: isTablet ? 100 : 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Number counter with outline effect and reset button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _loopCount.toString(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'FacebookSans',
                      ),
                    ),
                  ],
                ),

                // Label text
                Text(
                  _selectedTab == 0 ? 'Todays Chants' : 'Todays Chalisa',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: counterTextColor,
                    fontFamily: 'FacebookSans',
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 16),

                // Start button - using AnimatedSwitcher for text animation
                GestureDetector(
                  onTap: _playAudio,
                  child: Container(
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: Text(
                          _isPlaying ? 'Stop' : 'Start',
                          key: ValueKey<bool>(_isPlaying),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontFamily: 'FacebookSans',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tab selector - positioned to overflow at the top
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.8),
                  width: 1.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Row(
                  children: [
                    // Ram Tab
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (_isPlaying) {
                            // Stop audio when changing tabs
                            _ramPlayer.stop();
                            _hanumanPlayer.stop();
                            setState(() {
                              _isPlaying = false;
                              _selectedTab = 0;
                            });
                          } else {
                            setState(() {
                              _selectedTab = 0;
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _selectedTab == 0
                                ? selectedTabColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Center(
                            child: Text(
                              'Ram',
                              style: TextStyle(
                                color: _selectedTab == 0
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16,
                                fontWeight: _selectedTab == 0
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                fontFamily: 'FacebookSans',
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Hanuman Chalisa Tab
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (_isPlaying) {
                            // Stop audio when changing tabs
                            _ramPlayer.stop();
                            _hanumanPlayer.stop();
                            setState(() {
                              _isPlaying = false;
                              _selectedTab = 1;
                            });
                          } else {
                            setState(() {
                              _selectedTab = 1;
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _selectedTab == 1
                                ? selectedTabColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Center(
                            child: Text(
                              'Hanuman Chalisa',
                              style: TextStyle(
                                color: _selectedTab == 1
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14,
                                fontWeight: _selectedTab == 1
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                fontFamily: 'FacebookSans',
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
