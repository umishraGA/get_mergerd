import 'package:flutter/material.dart';
import '../models/post_poll_models.dart';

/// Enum representing different types of reactions
enum ReactionType {
  /// Like reaction
  like,
  /// Love reaction
  love,
  /// Haha reaction
  haha,
  /// Wow reaction
  wow,
  /// Sad reaction
  sad,
  /// Angry reaction
  angry,
  /// Heart reaction
  heart,
}

/// A widget that displays recent reactions for posts or comments
class ReactionDisplayWidget extends StatefulWidget {
  /// The total count of reactions
  final int reactionCount;

  /// Map of reaction types to lists of LikeItem who reacted
  final Map<ReactionType, List<LikeItem>> recentReactions;

  /// The current user's reaction (if any)
  final ReactionType? currentUserReaction;

  /// Creates a [ReactionDisplayWidget]
  const ReactionDisplayWidget({
    super.key,
    required this.reactionCount,
    required this.recentReactions,
    this.currentUserReaction,
  });

  @override
  State<ReactionDisplayWidget> createState() => _ReactionDisplayWidgetState();
}

class _ReactionDisplayWidgetState extends State<ReactionDisplayWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.reactionCount == 0) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => _showReactionBottomSheet(context),
      child: _buildReactionsBar(),
    );
  }

  /// Builds the main reactions bar with icons and summary text
  Widget _buildReactionsBar() {
    List<Widget> reactionWidgets = [];
    int totalDisplayed = 0;
    const maxReactionsToShow = 3;

    // First add the reactions with users
    widget.recentReactions.forEach((reaction, users) {
      if (users.isNotEmpty && totalDisplayed < maxReactionsToShow) {
        reactionWidgets.add(
          Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 2,
                ),
              ],
            ),
            child: _getReactionEmoji(reaction),
          ),
        );
        totalDisplayed++;
      }
    });

    // Add the user's own reaction if present
    if (widget.currentUserReaction != null) {
      bool alreadyShown = false;
      for (var entry in widget.recentReactions.entries) {
        if (entry.key == widget.currentUserReaction &&
            entry.value.any((user) => 
                user.userName == 'You' || 
                user.userName == null || 
                user.userName!.isEmpty)) {
          alreadyShown = true;
          break;
        }
      }

      if (!alreadyShown && totalDisplayed < maxReactionsToShow) {
        reactionWidgets.insert(
          0,
          Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 2,
                ),
              ],
            ),
            child: _getReactionEmoji(widget.currentUserReaction!),
          ),
        );
        totalDisplayed++;
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Stack the reaction emojis with proper overlap
          if (reactionWidgets.isNotEmpty)
            SizedBox(
              width: reactionWidgets.length > 1
                  ? 24 + ((reactionWidgets.length - 1) * 16)
                  : 24,
              height: 24,
              child: Stack(
                children: List.generate(reactionWidgets.length, (index) {
                  return Positioned(
                    left: index * 16.0, // Overlap each icon by 8px
                    child: reactionWidgets[index],
                  );
                }),
              ),
            ),
          const SizedBox(width: 8),
          // Show text summary
          Expanded(
            child: Text(
              _buildReactionSummaryText(),
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                fontFamily: 'FacebookSans',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Shows the reaction bottom sheet
  void _showReactionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      useSafeArea: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, controller) => ReactionListBottomSheet(
          reactionCount: widget.reactionCount,
          recentReactions: widget.recentReactions,
          currentUserReaction: widget.currentUserReaction,
          scrollController: controller,
        ),
      ),
    );
  }

  /// Helper to get emoji for reaction type
  Widget _getReactionEmoji(ReactionType type) {
    switch (type) {
      case ReactionType.like:
        return const Center(child: Text('👍', style: TextStyle(fontSize: 13)));
      case ReactionType.love:
        return const Center(child: Text('❤️', style: TextStyle(fontSize: 13)));
      case ReactionType.haha:
        return const Center(child: Text('😂', style: TextStyle(fontSize: 13)));
      case ReactionType.wow:
        return const Center(child: Text('😮', style: TextStyle(fontSize: 13)));
      case ReactionType.sad:
        return const Center(child: Text('😢', style: TextStyle(fontSize: 13)));
      case ReactionType.angry:
        return const Center(child: Text('😡', style: TextStyle(fontSize: 13)));
      case ReactionType.heart:
        return const Center(
            child: Icon(Icons.favorite, color: Colors.red, size: 14));
    }
  }

  /// Build text summary of reactions
  String _buildReactionSummaryText() {
    List<String> allUserNames = [];
    widget.recentReactions.forEach((reaction, users) {
      for (var user in users) {
        final userName = user.userName ?? 'Anonymous';
        if (!allUserNames.contains(userName)) {
          allUserNames.add(userName);
        }
      }
    });

    // Check if current user has reacted
    bool currentUserReacted = false;
    if (widget.currentUserReaction != null) {
      for (var entry in widget.recentReactions.entries) {
        if (entry.key == widget.currentUserReaction) {
          currentUserReacted = entry.value.any((user) => 
            user.userName == 'You' || 
            user.userName == null || 
            user.userName!.isEmpty);
          break;
        }
      }
    }
    
    if (currentUserReacted && !allUserNames.contains('You')) {
      allUserNames.insert(0, 'You');
    }

    if (allUserNames.isEmpty) {
      return '${widget.reactionCount} ${
        widget.reactionCount == 1 ? 'like' : 'likes'}';
    }

    if (allUserNames.length == 1) {
      return '${allUserNames[0]}${
        widget.reactionCount > 1 ? 
          ' and ${widget.reactionCount - 1} others' : 
          ''}';
    } else if (allUserNames.length == 2) {
      return '${allUserNames[0]}, ${allUserNames[1]}${
        widget.reactionCount > 2 ? 
          ' and ${widget.reactionCount - 2} others' : 
          ''}';
    } else {
      return '${allUserNames[0]}, ${allUserNames[1]} and ${
        widget.reactionCount - 2} others';
    }
  }
}

/// Bottom sheet that displays reaction users grouped by reaction type
class ReactionListBottomSheet extends StatefulWidget {
  /// Total reaction count
  final int reactionCount;
  /// Recent reactions by type
  final Map<ReactionType, List<LikeItem>> recentReactions;
  /// Current user's reaction type
  final ReactionType? currentUserReaction;
  /// Scroll controller for the sheet
  final ScrollController scrollController;

  /// Creates a [ReactionListBottomSheet]
  const ReactionListBottomSheet({
    super.key,
    required this.reactionCount,
    required this.recentReactions,
    this.currentUserReaction,
    required this.scrollController,
  });

  @override
  State<ReactionListBottomSheet> createState() =>
      _ReactionListBottomSheetState();
}

class _ReactionListBottomSheetState extends State<ReactionListBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<ReactionType> _availableReactions;
  int _selectedIndex = 0;
  String? _searchQuery;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _availableReactions = _getAvailableReactions();
    _tabController = TabController(
      length: _availableReactions.length + 1, // All + specific reactions
      vsync: this,
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  List<ReactionType> _getAvailableReactions() {
    List<ReactionType> reactions = [];
    widget.recentReactions.forEach((reaction, users) {
      if (users.isNotEmpty && !reactions.contains(reaction)) {
        reactions.add(reaction);
      }
    });
    return reactions;
  }

  String _getReactionName(ReactionType type) {
    switch (type) {
      case ReactionType.like:
        return 'Like';
      case ReactionType.love:
        return 'Love';
      case ReactionType.haha:
        return 'Haha';
      case ReactionType.wow:
        return 'Wow';
      case ReactionType.sad:
        return 'Sad';
      case ReactionType.angry:
        return 'Angry';
      case ReactionType.heart:
        return 'Heart';
    }
  }


  Widget _getFallbackReactionIcon(ReactionType type) {
    // Fallback to emojis if assets are not available
    switch (type) {
      case ReactionType.like:
        return const Text('👍', style: TextStyle(fontSize: 18));
      case ReactionType.love:
        return const Text('❤️', style: TextStyle(fontSize: 18));
      case ReactionType.haha:
        return const Text('😂', style: TextStyle(fontSize: 18));
      case ReactionType.wow:
        return const Text('😮', style: TextStyle(fontSize: 18));
      case ReactionType.sad:
        return const Text('😢', style: TextStyle(fontSize: 18));
      case ReactionType.angry:
        return const Text('😡', style: TextStyle(fontSize: 18));
      case ReactionType.heart:
        return const Icon(Icons.favorite, color: Colors.red, size: 18);
    }
  }

  List<LikeItem> _getUsersForReaction(ReactionType? type) {
    if (type == null) {
      // All reactions
      Set<LikeItem> allUsers = {};
      widget.recentReactions.forEach((_, users) {
        allUsers.addAll(users);
      });
      return allUsers.toList();
    } else {
      // Specific reaction
      return widget.recentReactions[type] ?? [];
    }
  }

  List<LikeItem> _getFilteredUsers(List<LikeItem> users) {
    if (_searchQuery == null || _searchQuery!.isEmpty) {
      return users;
    }
    return users
        .where((user) => (user.userName ?? 'Anonymous')
            .toLowerCase()
            .contains(_searchQuery!.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // _buildHandleBar(),
          _buildHeader(),
          _isSearching ? _buildSearchField() : _buildReactionTabs(),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Expanded(
            child: _isSearching
                ? _buildSearchResults()
                : TabBarView(
                    controller: _tabController,
                    children: [
                      // All reactions tab
                      _buildUserList(null),
                      // Individual reaction tabs
                      for (var reaction in _availableReactions)
                        _buildUserList(reaction),
                    ],
                  ),
          ),
        ],
      ),
    );
  }


  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          AnimatedCrossFade(
            firstChild: const Text(
              'People who reacted',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'FacebookSans',
              ),
            ),
            secondChild: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchQuery = null;
                  _searchController.clear();
                });
              },
            ),
            crossFadeState: _isSearching
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
          const Spacer(),
          // IconButton(
          //   icon: Icon(_isSearching ? Icons.close : Icons.search),
          //   onPressed: () {
          //     setState(() {
          //       _isSearching = !_isSearching;
          //       if (!_isSearching) {
          //         _searchQuery = null;
          //         _searchController.clear();
          //       } else {
          //         Future.delayed(const Duration(milliseconds: 100), () {
          //           _searchFocusNode.requestFocus();
          //         });
          //       }
          //     });
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        decoration: InputDecoration(
          hintText: 'Search by name',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildSearchResults() {
    final allUsers = _getUsersForReaction(null);
    final filteredUsers = _getFilteredUsers(allUsers);

    if (filteredUsers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No results found for "$_searchQuery"',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        final user = filteredUsers[index];

        // Find which reaction this user made
        ReactionType? userReaction;
        for (var entry in widget.recentReactions.entries) {
          if (entry.value.any((u) => u.id == user.id)) {
            userReaction = entry.key;
            break;
          }
        }

        return _buildUserListItem(user, userReaction);
      },
    );
  }

  Widget _buildReactionTabs() {
    // Calculate the available width for the tabs
    double screenWidth = MediaQuery.of(context).size.width;
    int totalItems = _availableReactions.length + 1; // +1 for "All" tab

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          // BoxShadow(
          //   color: Colors.black.withOpacity(0.05),
          //   blurRadius: 2,
          //   offset: const Offset(0, 1),
          // ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TabBar(
              controller: _tabController,
              isScrollable: false,
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFFEEEEEE),
              indicatorColor: const Color(0xFF1877F2),
              indicatorWeight: 3,
              dividerColor: const Color(0xFFEEEEEE),
              dividerHeight: 1,
              labelPadding: EdgeInsets.zero,
              tabs: [
                SizedBox(
                  width: screenWidth / totalItems,
                  child: _buildCompactTabItem(
                    "All",
                    isSelected: _selectedIndex == 0,
                    count: widget.reactionCount,
                  ),
                ),
                for (int i = 0; i < _availableReactions.length; i++)
                  SizedBox(
                    width: screenWidth / totalItems,
                    child: _buildCompactReactionTabItem(
                      _availableReactions[i],
                      isSelected: _selectedIndex == i + 1,
                      count: widget.recentReactions[_availableReactions[i]]
                              ?.length ??
                          0,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactTabItem(String label,
      {required bool isSelected, required int count}) {
    return Tab(
      height: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFE7F3FF) : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? const Color(0xFF1877F2) : Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? const Color(0xFF1877F2) : Colors.grey[700],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCompactReactionTabItem(ReactionType reaction,
      {required bool isSelected, required int count}) {
    return Tab(
      height: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected
                  ? _getReactionColor(reaction).withValues(alpha: 0.1)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                _getAnimatedReactionIcon(reaction, isSelected: isSelected),
                if (count > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        count > 99 ? '99+' : count.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _getReactionName(reaction),
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color:
                  isSelected ? _getReactionColor(reaction) : Colors.grey[700],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(ReactionType? reactionType) {
    final users = _getUsersForReaction(reactionType);

    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No reactions yet',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: widget.scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];

        // Find which reaction this user made if showing All tab
        ReactionType? userReaction;
        if (reactionType == null) {
          for (var entry in widget.recentReactions.entries) {
            if (entry.value.any((u) => u.id == user.id)) {
              userReaction = entry.key;
              break;
            }
          }
        } else {
          userReaction = reactionType;
        }

        return _buildUserListItem(user, userReaction);
      },
    );
  }

  Widget _buildUserListItem(LikeItem user, ReactionType? userReaction) {
    final username = user.userName ?? 'Anonymous';
    final isCurrentUser = username == 'You' || username.isEmpty;
    final bool isMutualFriend = username.hashCode % 3 == 0 && !isCurrentUser;

    // Generate a unique avatar index for each user
    final int avatarIndex = isCurrentUser ? 0 : (username.hashCode % 8);

    // Use a list of actual profile pictures from the app
    final List<String> profileImages = [
      'assets/images/profile_pic.png', // Default user (You)
      'assets/images/story_logo1.png',
      'assets/images/story_logo2.png',
      'assets/images/story_logo3.png',
      'assets/images/username_comment.png',
      'assets/images/company_name.png',
      'assets/images/spiritual/temples/temple1.png',
      'assets/images/post_image.png',
    ];

    final String avatarPath = profileImages[avatarIndex];
    final String? randomName =
        isCurrentUser ? null : _getRandomFullName(username);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 22,
                backgroundColor:
                    isCurrentUser ? const Color(0xFF1877F2) : Colors.grey[200],
                backgroundImage: user.userAvatar != null && 
                    user.userAvatar!.isNotEmpty
                    ? NetworkImage(user.userAvatar!)
                    : AssetImage(avatarPath) as ImageProvider,
                onBackgroundImageError: (_, __) {
                  // Fallback if image fails to load
                },
                child: isCurrentUser
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 44,
                          color: const Color(0xFF1877F2)
                            .withValues(alpha: 0.7),
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: const Text(
                            'You',
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
            if (userReaction != null)
              Positioned(
                right: -5,
                bottom: -3,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.5, end: 1.0),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: _getReactionColor(userReaction),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 3,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Transform.scale(
                        scale: 0.7,
                        child: _getFallbackReactionIcon(userReaction),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          isCurrentUser ? 'You' : (randomName ?? username),
          style: TextStyle(
            fontSize: 16,
            fontWeight: isCurrentUser ? FontWeight.w600 : FontWeight.w500,
            fontFamily: 'FacebookSans',
          ),
        ),
        subtitle: isMutualFriend
            ? Row(
                children: [
                  Icon(Icons.people, size: 12, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Mutual Friend',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              )
            : null,
        trailing: userReaction != null
            ? Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _getReactionColor(userReaction)
                    .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child:
                      _getAnimatedReactionIcon(userReaction, isSelected: true),
                ),
              )
            : null,
        onTap: () {
          // Show toast when a user is tapped
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Viewing ${isCurrentUser ? 'your' : '$username\'s'} profile'),
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  Color _getReactionColor(ReactionType reaction) {
    switch (reaction) {
      case ReactionType.like:
        return const Color(0xFF1877F2); // Facebook blue
      case ReactionType.love:
        return const Color(0xFFE02020); // Red
      case ReactionType.haha:
        return const Color(0xFFFFD700); // Gold
      case ReactionType.wow:
        return const Color(0xFFFFD700); // Gold
      case ReactionType.sad:
        return const Color(0xFFFFD700); // Gold
      case ReactionType.angry:
        return const Color(0xFFFF7600); // Orange
      case ReactionType.heart:
        return const Color(0xFFE02020); // Red
    }
  }

  // Add custom Facebook reaction animations
  Widget _getAnimatedReactionIcon(ReactionType type,
      {bool isSelected = false}) {
    final Widget icon = _getFallbackReactionIcon(type);

    if (!isSelected) return icon;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: icon,
    );
  }

  // Helper to generate realistic random names for users
  String _getRandomFullName(String seed) {
    final List<String> firstNames = [
      'Anil',
      'Rahul',
      'Priya',
      'Ananya',
      'Vikram',
      'Deepa',
      'Arjun',
      'Meera',
      'Sanjay',
      'Kavita',
      'Raj',
      'Rishi',
      'Neha',
      'Pooja',
      'Varun'
    ];

    final List<String> lastNames = [
      'Sharma',
      'Patel',
      'Singh',
      'Verma',
      'Kumar',
      'Gupta',
      'Shah',
      'Joshi',
      'Desai',
      'Kohli',
      'Agarwal',
      'Malhotra',
      'Mehta',
      'Kapoor',
      'Chauhan'
    ];

    final int firstNameIndex = seed.hashCode % firstNames.length;
    final int lastNameIndex = (seed.hashCode * 31) % lastNames.length;

    return '${firstNames[firstNameIndex]} ${lastNames[lastNameIndex]}';
  }
}
