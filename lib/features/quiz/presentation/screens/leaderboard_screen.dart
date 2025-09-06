import 'package:flutter/material.dart';

import '../widgets/TopAppBarQuiz.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  String _selectedTimeFilter = 'Daily';
  final List<String> _timeFilters = ['Daily', 'Weekly', 'All Time'];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Mock data for leaderboard
  final List<Map<String, dynamic>> _leaderboardData = [
    {
      'rank': 1,
      'name': 'Sachin',
      'score': 2600,
      'country': 'India',
      'avatar': 'assets/images/avatars/avatar1.png',
      'trend': '+5', // Trend indicator (improved by 5 positions)
    },
    {
      'rank': 2,
      'name': 'Rahul',
      'score': 1549,
      'country': 'India',
      'avatar': 'assets/images/avatars/avatar2.png',
      'trend': '-1', // Trend indicator (dropped by 1 position)
    },
    {
      'rank': 3,
      'name': 'Rajat',
      'score': 847,
      'country': 'India',
      'avatar': 'assets/images/avatars/avatar3.png',
      'trend': '0', // No change in position
    },
    {
      'rank': 4,
      'name': 'Sunil Shankar',
      'score': 590,
      'country': 'India',
      'avatar': 'assets/images/avatars/avatar4.png',
      'trend': '+2',
    },
    {
      'rank': 5,
      'name': 'Priya Sharma',
      'score': 575,
      'country': 'India',
      'avatar': 'assets/images/avatars/avatar5.png',
      'trend': '-2',
    },
    {
      'rank': 6,
      'name': 'Anil Kumar',
      'score': 520,
      'country': 'India',
      'avatar': 'assets/images/avatars/avatar6.png',
      'trend': '+4',
    },
    {
      'rank': 7,
      'name': 'Vikram Singh',
      'score': 495,
      'country': 'India',
      'avatar': 'assets/images/avatars/avatar5.png',
      'trend': '+1',
    },
    {
      'rank': 8,
      'name': 'Kavita Patel',
      'score': 482,
      'country': 'India',
      'avatar': 'assets/images/avatars/avatar2.png',
      'trend': '-3',
    },
    {
      'rank': 9,
      'name': 'Rajan Mishra',
      'score': 450,
      'country': 'India',
      'avatar': 'assets/images/avatars/avatar3.png',
      'trend': '+6',
    },
    {
      'rank': 10,
      'name': 'Neha Gupta',
      'score': 425,
      'country': 'India',
      'avatar': 'assets/images/avatars/avatar4.png',
      'trend': '-1',
    },
    {
      'rank': 11,
      'name': 'Ankit Verma',
      'score': 410,
      'country': 'India',
      'avatar': 'assets/images/avatars/avatar1.png',
      'trend': '+2',
    },
    {
      'rank': 12,
      'name': 'You',
      'score': 380,
      'country': 'India',
      'avatar': 'assets/images/avatars/avatar_user.png',
      'trend': '+3',
      'isCurrentUser': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter out the current user for separate display
    final currentUserData = _leaderboardData.firstWhere(
      (user) => user['isCurrentUser'] == true,
      orElse: () => _leaderboardData.last,
    );

    // Get top 3 for podium
    final topThreeUsers =
        _leaderboardData.where((user) => (user['rank'] as int) <= 3).toList();

    // Get other users (excluding current user if not in top 3)
    final otherUsers = _leaderboardData
        .where((user) =>
            (user['rank'] as int) > 3 && user['isCurrentUser'] != true)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF7B61FF), // Purple background
      body: Column(
        children: [
          // TopAppBarQuiz with purple background
          Container(
            color: const Color(0xFF7B61FF),
            child: TopAppBarQuiz(
              coins: "370",
              onBack: () => Navigator.of(context).pop(),
              title: "Leaderboard",
              useDarkTheme: true, // Enable dark theme for white text
            ),
          ),

          // Make everything below the app bar scrollable
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Time filter tabs with improved styling
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4D9F50), // Green background
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: _timeFilters.map((filter) {
                          final isSelected = filter == _selectedTimeFilter;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedTimeFilter = filter;
                                });
                                // Reset and replay the animation when filter changes
                                _animationController.reset();
                                _animationController.forward();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF8BC34A)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  filter,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: isSelected ? 16 : 14,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // Podium section with animations
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SizedBox(
                      height:
                          320, // Increased height for better podium visualization
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Shine effect behind winner
                          if (topThreeUsers.isNotEmpty)
                            Positioned(
                              top: 0,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.3),
                                      Colors.white.withOpacity(0.0),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          // Podium platforms
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // 2nd place podium
                                if (topThreeUsers.length > 1)
                                  _build3DPodium(
                                    height: 140,
                                    rank: '2',
                                    user: topThreeUsers[1],
                                    width: MediaQuery.of(context).size.width *
                                        0.28,
                                  ),

                                // 1st place podium (tallest)
                                if (topThreeUsers.isNotEmpty)
                                  _build3DPodium(
                                    height: 180,
                                    rank: '1',
                                    user: topThreeUsers[0],
                                    width: MediaQuery.of(context).size.width *
                                        0.32,
                                    isWinner: true,
                                  ),

                                // 3rd place podium
                                if (topThreeUsers.length > 2)
                                  _build3DPodium(
                                    height: 110,
                                    rank: '3',
                                    user: topThreeUsers[2],
                                    width: MediaQuery.of(context).size.width *
                                        0.28,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // White container for participants
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Current user box (if not in top 3)
                        if ((currentUserData['rank'] as int) > 3)
                          Container(
                            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFF9C4), Color(0xFFFFECB3)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.amber.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Rank
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.amber.shade700,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${currentUserData['rank']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Avatar
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundImage: AssetImage(
                                          currentUserData['avatar'] as String),
                                      backgroundColor: Colors.grey.shade200,
                                      onBackgroundImageError:
                                          (exception, stackTrace) {},
                                      child: const Icon(Icons.person,
                                          color: Colors.grey),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: _buildCountryFlag(
                                          currentUserData['country'] as String),
                                    ),
                                    // First place crown indicator for current user
                                    if (currentUserData['rank'] == 1)
                                      Positioned(
                                        top: -10,
                                        left: 0,
                                        right: 0,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.emoji_events,
                                            color: const Color(0xFFFFD700),
                                            size: 18,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                blurRadius: 3,
                                                offset: const Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(width: 16),

                                // Name and score
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            currentUserData['name'] as String,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(Icons.star,
                                              color: Colors.amber, size: 16),
                                          const Text(
                                            " (You)",
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.amber,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${currentUserData['score']} points',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          _buildTrendIndicator(
                                              currentUserData['trend']
                                                  as String),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Divider with text
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              const Expanded(child: Divider()),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  'Top Players',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const Expanded(child: Divider()),
                            ],
                          ),
                        ),

                        // List of players - use a fixed height ListView to display all items
                        ListView.builder(
                          physics:
                              const NeverScrollableScrollPhysics(), // Disable scrolling for this list
                          padding: const EdgeInsets.only(top: 8, bottom: 16),
                          itemCount: otherUsers.length,
                          shrinkWrap: true, // Use minimal space needed
                          itemBuilder: (context, index) {
                            final userData = otherUsers[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Rank
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      color: Colors.grey.shade50,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${userData['rank']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade700,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Avatar and flag
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundImage: AssetImage(
                                            userData['avatar'] as String),
                                        backgroundColor: Colors.grey.shade200,
                                        onBackgroundImageError:
                                            (exception, stackTrace) {},
                                        child: const Icon(Icons.person,
                                            color: Colors.grey),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: _buildCountryFlag(
                                            userData['country'] as String),
                                      ),
                                      // First place crown indicator
                                      if (userData['rank'] == 1)
                                        Positioned(
                                          top: -10,
                                          left: 0,
                                          right: 0,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.emoji_events,
                                              color: const Color(0xFFFFD700),
                                              size: 18,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  blurRadius: 3,
                                                  offset: const Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(width: 16),

                                  // Name and score
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userData['name'] as String,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '${userData['score']} points',
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            _buildTrendIndicator(
                                                userData['trend'] as String),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // New enhanced 3D podium method
  Widget _build3DPodium({
    required double height,
    required String rank,
    required Map<String, dynamic> user,
    required double width,
    bool isWinner = false,
  }) {
    // User info will be in the original _buildPodium method
    return _buildPodium(
        height: height,
        rank: rank,
        user: user,
        width: width,
        isWinner: isWinner);
  }

  Widget _buildPodium({
    required double height,
    required String rank,
    required Map<String, dynamic> user,
    required double width,
    bool isWinner = false,
  }) {
    // Colors for the 3D effect
    final Color podiumBaseColor =
        isWinner ? const Color(0xFF8F7AE8) : const Color(0xFF9D8AEF);
    final Color podiumTopColor =
        isWinner ? const Color(0xFFE5E1F9) : const Color(0xFFEDE9FC);
    final Color podiumFrontColor =
        isWinner ? const Color(0xFF7B61FF) : const Color(0xFF9D8AEF);
    final Color podiumSideColor =
        isWinner ? const Color(0xFF6D55E8) : const Color(0xFF917EE0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Crown for winner
        if (isWinner)
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 800),
            builder: (context, double value, child) {
              return Transform.translate(
                offset: Offset(0, -5 * value),
                child: Opacity(
                  opacity: value,
                  child: Image.asset(
                    'assets/images/quiz/crown.png',
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.emoji_events,
                        color: Color(0xFFFFD700),
                        size: 40,
                      );
                    },
                  ),
                ),
              );
            },
          ),

        // User avatar with animation
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 600),
          builder: (context, double value, child) {
            return Transform.scale(
              scale: 0.5 + (0.5 * value),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: isWinner
                              ? const Color(0xFFFFD700).withOpacity(0.5)
                              : Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(user['avatar'] as String),
                      backgroundColor: Colors.white,
                      onBackgroundImageError: (exception, stackTrace) {},
                      child: const Icon(Icons.person, color: Colors.grey),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: _buildCountryFlag(user['country'] as String),
                  ),
                ],
              ),
            );
          },
        ),

        // User name
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            user['name'] as String,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),

        // Score bubble with trend
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isWinner ? const Color(0xFF4CAF50) : const Color(0xFF4D9F50),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${user['score']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (user.containsKey('trend') &&
                  user['trend'] is String &&
                  user['trend'] as String != '0')
                _buildTrendIndicator(user['trend'] as String,
                    color: Colors.white),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Enhanced 3D Podium animation
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 800),
          curve: Curves.elasticOut,
          builder: (context, double value, child) {
            final double actualHeight = height * value;
            // Define depth for 3D effect (around 20% of width)
            final double depth = width * 0.2;

            return SizedBox(
              width: width + depth, // Add space for the side face
              height: actualHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Base podium with perspective
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      width: width,
                      height: actualHeight,
                      decoration: BoxDecoration(
                        color: podiumBaseColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 1,
                            offset: const Offset(4, 4),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Right side face (3D effect)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Transform(
                      transform: Matrix4.skewY(-0.2),
                      child: Container(
                        width: depth,
                        height: actualHeight,
                        color: podiumSideColor,
                      ),
                    ),
                  ),

                  // Enhanced top face with true perspective
                  // Positioned(
                  //   top: 0, // Precisely at the top of the front face
                  //   left: 0,
                  //   child: CustomPaint(
                  //     size: Size(
                  //         width * 1.2, width * 0.06), // Wider and thinner top
                  //     painter: _PodiumTopPainter(
                  //       color: const Color(
                  //           0xFFE5E1F9), // Even lighter color for better contrast
                  //       shadowColor: Colors.black.withOpacity(0.15),
                  //     ),
                  //   ),
                  // ),

                  // Main front face with rank number (on top of everything)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: width,
                      height: actualHeight,
                      color: podiumFrontColor,
                      child: Center(
                        child: Text(
                          rank,
                          style: TextStyle(
                            fontSize: isWinner ? 100 : 80,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCountryFlag(String country) {
    // For simplicity, just showing India flag
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/flags/india.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback text-based flag
            return Container(
              color: Colors.orange,
              child: const Center(
                child: Text(
                  '🇮🇳',
                  style: TextStyle(fontSize: 10),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTrendIndicator(String trend, {Color color = Colors.black}) {
    final trendValue =
        int.tryParse(trend.replaceAll(RegExp(r'[^-0-9]'), '')) ?? 0;
    final isPositive = trend.contains('+');

    if (trendValue == 0) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isPositive ? Icons.arrow_upward : Icons.arrow_downward,
          color: isPositive ? Colors.green : Colors.red,
          size: 14,
        ),
        Text(
          '$trendValue',
          style: TextStyle(
            color: isPositive ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

// Add the custom painter class at the end of the file, outside any method
class _PodiumTopPainter extends CustomPainter {
  final Color color;
  final Color shadowColor;

  _PodiumTopPainter({
    required this.color,
    required this.shadowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Paint shadowPaint = Paint()
      ..color = shadowColor
      ..style = PaintingStyle.fill;

    final double width = size.width;
    final double height = size.height;

    // Calculate the points for the trapezoid (top face)
    final Path topPath = Path();
    // Create a sharper angle on the right side for more pronounced perspective
    topPath.moveTo(0, 0); // Top-left
    topPath.lineTo(width * 0.9, 0); // Top-right
    topPath.lineTo(width, height); // Bottom-right
    topPath.lineTo(0, height); // Bottom-left
    topPath.close();

    // Draw a very subtle shadow
    canvas.drawPath(
      topPath.shift(const Offset(1, 1)),
      shadowPaint,
    );

    // Draw main shape
    canvas.drawPath(topPath, paint);

    // More subtle highlight along top edge only
    final Paint highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final Path highlightPath = Path();
    highlightPath.moveTo(0, 0);
    highlightPath.lineTo(width * 0.9, 0);

    canvas.drawPath(highlightPath, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
