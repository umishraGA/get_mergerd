import 'package:flutter/material.dart';
import '../models/post_poll_models.dart';

/// A widget that displays reactions from dynamic API data
class DynamicReactionDisplayWidget extends StatefulWidget {
  /// The total count of reactions
  final int reactionCount;

  /// Dynamic reactions list from API
  final List<ReactionsItem>? reactions;

  /// Likes list from API
  final List<LikeItem>? likes;

  /// Likes count
  final int likesCount;

  /// Reaction count breakdown
  final List<ReactionItem>? reactionCountBreakdown;

  /// Whether current user liked the post
  final bool isLikedByUser;

  /// The current user's reaction (if any)
  final String? currentUserReaction;

  const DynamicReactionDisplayWidget({
    super.key,
    required this.reactionCount,
    this.reactions,
    this.likes,
    this.likesCount = 0,
    this.reactionCountBreakdown,
    this.isLikedByUser = false,
    this.currentUserReaction,
  });

  @override
  State<DynamicReactionDisplayWidget> createState() => _DynamicReactionDisplayWidgetState();
}

class _DynamicReactionDisplayWidgetState extends State<DynamicReactionDisplayWidget> {
  @override
  Widget build(BuildContext context) {
    // Check if there are any likes or reactions to display
    bool hasLikes = widget.likes != null && widget.likes!.isNotEmpty;
    bool hasReactions = widget.reactions != null && widget.reactions!.isNotEmpty;
    
    // Debug logging
    print('DynamicReactionDisplayWidget Debug:');
    print('  - Likes count: ${widget.likes?.length ?? 0}');
    print('  - Reactions count: ${widget.reactions?.length ?? 0}');
    print('  - Reaction breakdown: ${widget.reactionCountBreakdown?.map((e) => '${e.name}: ${e.count}').join(', ') ?? 'none'}');
    print('  - Current user reaction: ${widget.currentUserReaction}');
    print('  - Is liked by user: ${widget.isLikedByUser}');
    
    if (!hasLikes && !hasReactions) {
      return const SizedBox.shrink();
    }

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
    Set<String> uniqueReactions = <String>{};
    
    print('_buildReactionsBar Debug: Starting with ${uniqueReactions.length} unique reactions');

    // First priority: Add the user's own reaction if present
    if (widget.currentUserReaction != null && widget.currentUserReaction!.isNotEmpty) {
      String userReaction = widget.currentUserReaction!.toUpperCase();
      if (!uniqueReactions.contains(userReaction) && totalDisplayed < maxReactionsToShow) {
        uniqueReactions.add(userReaction);
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
            child: _getReactionEmoji(userReaction),
          ),
        );
        totalDisplayed++;
        print('_buildReactionsBar: Added user reaction: $userReaction. Total: $totalDisplayed');
      }
    }

    // Second priority: Add the user's like if they liked but it's different from their reaction
    if (widget.isLikedByUser && !uniqueReactions.contains('LIKE') && totalDisplayed < maxReactionsToShow) {
      uniqueReactions.add('LIKE');
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
          child: _getReactionEmoji('LIKE'),
        ),
      );
      totalDisplayed++;
    }

    // Third priority: Add likes from API data if present and not already added
    if (widget.likes != null && widget.likes!.isNotEmpty && !uniqueReactions.contains('LIKE') && totalDisplayed < maxReactionsToShow) {
      uniqueReactions.add('LIKE');
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
          child: _getReactionEmoji('LIKE'),
        ),
      );
      totalDisplayed++;
    }

    // Fourth priority: Get unique reaction types from reactionCountBreakdown
    if (widget.reactionCountBreakdown != null) {
      for (var reactionData in widget.reactionCountBreakdown!) {
        String reactionName = reactionData.name.toUpperCase();
        int count = reactionData.count;
        if (count > 0 && !uniqueReactions.contains(reactionName) && totalDisplayed < maxReactionsToShow) {
          uniqueReactions.add(reactionName);
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
              child: _getReactionEmoji(reactionName),
            ),
          );
          totalDisplayed++;
        }
      }
    }

    // Last priority: Add remaining unique reactions from the reactions list if needed
    if (totalDisplayed < maxReactionsToShow && widget.reactions != null && widget.reactions!.isNotEmpty) {
      for (var reaction in widget.reactions!) {
        if (totalDisplayed >= maxReactionsToShow) break;

        String reactionName = (reaction.reactionName ?? '').toUpperCase();
        if (reactionName.isNotEmpty && !uniqueReactions.contains(reactionName)) {
          uniqueReactions.add(reactionName);
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
              child: _getReactionEmoji(reactionName),
            ),
          );
          totalDisplayed++;
        }
      }
    }

    print('_buildReactionsBar: Final - uniqueReactions: $uniqueReactions, totalDisplayed: $totalDisplayed, widgetCount: ${reactionWidgets.length}');

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Stack the reaction emojis with proper overlap
          // if (reactionWidgets.isNotEmpty)
          //   SizedBox(
          //     width: reactionWidgets.length > 1
          //         ? 24 + ((reactionWidgets.length - 1) * 16)
          //         : 24,
          //     height: 24,
          //     child: Stack(
          //       children: List.generate(reactionWidgets.length, (index) {
          //         return Positioned(
          //           left: index * 16.0, // Overlap each icon by 8px
          //           child: reactionWidgets[index],
          //         );
          //       }),
          //     ),
          //   ),
          // const SizedBox(width: 8),
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
        builder: (_, controller) => DynamicReactionListBottomSheet(
          reactionCount: widget.reactionCount,
          reactions: widget.reactions,
          likes: widget.likes,
          likesCount: widget.likesCount,
          reactionCountBreakdown: widget.reactionCountBreakdown,
          isLikedByUser: widget.isLikedByUser,
          currentUserReaction: widget.currentUserReaction,
          scrollController: controller,
        ),
      ),
    );
  }

  /// Helper to get emoji for reaction type
  Widget _getReactionEmoji(String reactionName) {
    switch (reactionName.toUpperCase()) {
      case 'LIKE':
        return const Center(child: Text('👍', style: TextStyle(fontSize: 13)));
      case 'LOVE':
        return const Center(child: Text('❤️', style: TextStyle(fontSize: 13)));
      case 'HAHA':
        return const Center(child: Text('😂', style: TextStyle(fontSize: 13)));
      case 'WOW':
      case 'SURPRISE':
        return const Center(child: Text('😮', style: TextStyle(fontSize: 13)));
      case 'SAD':
        return const Center(child: Text('😢', style: TextStyle(fontSize: 13)));
      case 'ANGRY':
        return const Center(child: Text('😡', style: TextStyle(fontSize: 13)));
      case 'HEART':
        return const Center(
            child: Icon(Icons.favorite, color: Colors.red, size: 14));
      default:
        return const Center(child: Text('👍', style: TextStyle(fontSize: 13)));
    }
  }

  /// Build text summary of reactions
  String _buildReactionSummaryText() {
    List<String> userNames = [];
    
    // Extract user names from likes
    if (widget.likes != null) {
      for (var like in widget.likes!) {
        String userName = like.userName ?? '';
        if (userName.isNotEmpty && !userNames.contains(userName)) {
          userNames.add(userName);
        }
      }
    }
    
    // Extract user names from reactions
    if (widget.reactions != null) {
      for (var reaction in widget.reactions!) {
        String userName = reaction.userName ?? '';
        if (userName.isNotEmpty && !userNames.contains(userName)) {
          userNames.add(userName);
        }
      }
    }

    // Add current user if they liked or reacted
    if ((widget.isLikedByUser || widget.currentUserReaction != null) && !userNames.contains('You')) {
      userNames.insert(0, 'You');
    }

    // Build reaction type summary for better context
    Set<String> reactionTypes = <String>{};
    
    // Add user's own reaction first if present
    if (widget.currentUserReaction != null && widget.currentUserReaction!.isNotEmpty) {
      String userReaction = widget.currentUserReaction!.toLowerCase();
      if (userReaction == 'love') {
        reactionTypes.add('❤️');
      } else if (userReaction == 'haha') {
        reactionTypes.add('😂');
      } else if (userReaction == 'wow' || userReaction == 'surprise') {
        reactionTypes.add('😮');
      } else if (userReaction == 'sad') {
        reactionTypes.add('😢');
      } else if (userReaction == 'angry') {
        reactionTypes.add('😡');
      } else if (userReaction == 'like') {
        reactionTypes.add('👍');
      }
    }
    
    // Add like emoji if there are likes and not already added
    if (widget.likes != null && widget.likes!.isNotEmpty) {
      reactionTypes.add('👍');
    }
    
    // Add other reaction emojis from breakdown (avoiding duplicates)
    if (widget.reactionCountBreakdown != null) {
      for (var reactionData in widget.reactionCountBreakdown!) {
        if (reactionData.count > 0) {
          String reactionName = reactionData.name.toLowerCase();
          if (reactionName == 'love') {
            reactionTypes.add('❤️');
          } else if (reactionName == 'haha') {
            reactionTypes.add('😂');
          } else if (reactionName == 'wow' || reactionName == 'surprise') {
            reactionTypes.add('😮');
          } else if (reactionName == 'sad') {
            reactionTypes.add('😢');
          } else if (reactionName == 'angry') {
            reactionTypes.add('😡');
          } else if (reactionName == 'like') {
            reactionTypes.add('👍');
          }
        }
      }
    }

    // Create reaction summary with emojis
    String reactionEmojis = reactionTypes.take(3).join('');
    String emojiPrefix = reactionEmojis.isNotEmpty ? '$reactionEmojis ' : '';

    // Calculate total interactions (likes + reactions)
    int totalInteractions = (widget.likes?.length ?? 0) + (widget.reactions?.length ?? 0);

    if (userNames.isEmpty) {
      return '$emojiPrefix$totalInteractions ${totalInteractions == 1 ? 'reaction' : 'reactions'}';
    }

    if (userNames.length == 1) {
      return '$emojiPrefix${userNames[0]}${totalInteractions > 1 ? ' and ${totalInteractions - 1} others' : ''}';
    } else if (userNames.length == 2) {
      return '$emojiPrefix${userNames[0]}, ${userNames[1]}${totalInteractions > 2 ? ' and ${totalInteractions - 2} others' : ''}';
    } else {
      return '$emojiPrefix${userNames[0]}, ${userNames[1]} and ${totalInteractions - 2} others';
    }
  }
}

/// Bottom sheet that displays reaction users grouped by reaction type
class DynamicReactionListBottomSheet extends StatefulWidget {
  final int reactionCount;
  final List<ReactionsItem>? reactions;
  final List<LikeItem>? likes;
  final int likesCount;
  final List<ReactionItem>? reactionCountBreakdown;
  final bool isLikedByUser;
  final String? currentUserReaction;
  final ScrollController scrollController;

  const DynamicReactionListBottomSheet({
    super.key,
    required this.reactionCount,
    this.reactions,
    this.likes,
    this.likesCount = 0,
    this.reactionCountBreakdown,
    this.isLikedByUser = false,
    this.currentUserReaction,
    required this.scrollController,
  });

  @override
  State<DynamicReactionListBottomSheet> createState() =>
      _DynamicReactionListBottomSheetState();
}

class _DynamicReactionListBottomSheetState extends State<DynamicReactionListBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<String> _availableReactions;
  int _selectedIndex = 0;

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
    super.dispose();
  }

  List<String> _getAvailableReactions() {
    Set<String> reactions = {};
    
    // Add likes if present
    if (widget.likes != null && widget.likes!.isNotEmpty) {
      reactions.add('LIKE');
    }
    
    // Get reactions from breakdown
    if (widget.reactionCountBreakdown != null) {
      for (var reactionData in widget.reactionCountBreakdown!) {
        String reactionName = reactionData.name;
        int count = reactionData.count;
        if (count > 0 && reactionName.isNotEmpty) {
          reactions.add(reactionName);
        }
      }
    }
    
    // Get reactions from reactions list
    if (widget.reactions != null) {
      for (var reaction in widget.reactions!) {
        String reactionName = reaction.reactionName ?? '';
        if (reactionName.isNotEmpty) {
          reactions.add(reactionName);
        }
      }
    }
    
    return reactions.toList();
  }

  Widget _getReactionIcon(String reactionName, {double size = 18}) {
    switch (reactionName.toUpperCase()) {
      case 'LIKE':
        return const Text('👍', style: TextStyle(fontSize: 18));
      case 'LOVE':
        return const Text('❤️', style: TextStyle(fontSize: 18));
      case 'HAHA':
        return const Text('😂', style: TextStyle(fontSize: 18));
      case 'WOW':
      case 'SURPRISE':
        return const Text('😮', style: TextStyle(fontSize: 18));
      case 'SAD':
        return const Text('😢', style: TextStyle(fontSize: 18));
      case 'ANGRY':
        return const Text('😡', style: TextStyle(fontSize: 18));
      case 'HEART':
        return const Icon(Icons.favorite, color: Colors.red, size: 18);
      default:
        return const Text('👍', style: TextStyle(fontSize: 18));
    }
  }

  List<dynamic> _getUsersForReaction(String? reactionType) {
    List<dynamic> users = [];
    
    // If showing all or specifically likes, add like users
    if (reactionType == null || reactionType.toUpperCase() == 'LIKE') {
      if (widget.likes != null) {
        for (var like in widget.likes!) {
          // Create a pseudo ReactionsItem for likes to maintain consistency
          users.add({
            'type': 'like',
            'userName': like.userName,
            'userAvatar': like.userAvatar,
            'reactionName': 'LIKE',
          });
        }
      }
    }
    
    // Add reaction users
    if (reactionType == null || reactionType.toUpperCase() != 'LIKE') {
      if (widget.reactions != null) {
        for (var reaction in widget.reactions!) {
          String reactionName = reaction.reactionName ?? '';
          
          if (reactionType == null || reactionName.toUpperCase() == reactionType.toUpperCase()) {
            users.add({
              'type': 'reaction',
              'userName': reaction.userName,
              'userAvatar': reaction.userAvatar,
              'reactionName': reaction.reactionName,
            });
          }
        }
      }
    }
    
    return users;
  }

  int _getReactionCount(String reactionName) {
    if (reactionName.toUpperCase() == 'LIKE') {
      return widget.likes?.length ?? 0;
    }
    
    if (widget.reactionCountBreakdown != null) {
      for (var reactionData in widget.reactionCountBreakdown!) {
        if (reactionData.name.toUpperCase() == reactionName.toUpperCase()) {
          return reactionData.count;
        }
      }
    }
    return 0;
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
          _buildHeader(),
          _buildReactionTabs(),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Expanded(
            child: TabBarView(
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
          const Text(
            'People who reacted',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'FacebookSans',
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildReactionTabs() {
    double screenWidth = MediaQuery.of(context).size.width;
    int totalItems = _availableReactions.length + 1; // +1 for "All" tab

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        labelColor: const Color(0xFF1877F2),
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: const Color(0xFF1877F2),
        indicatorWeight: 3,
        dividerColor: const Color(0xFFEEEEEE),
        dividerHeight: 1,
        labelPadding: EdgeInsets.zero,
        tabs: [
          SizedBox(
            width: screenWidth / totalItems,
            child: _buildTabItem(
              "All",
              (widget.likes?.length ?? 0) + (widget.reactions?.length ?? 0),
              isSelected: _selectedIndex == 0,
            ),
          ),
          for (int i = 0; i < _availableReactions.length; i++)
            SizedBox(
              width: screenWidth / totalItems,
              child: _buildReactionTabItem(
                _availableReactions[i],
                _getReactionCount(_availableReactions[i]),
                isSelected: _selectedIndex == i + 1,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label, int count, {required bool isSelected}) {
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

  Widget _buildReactionTabItem(String reactionName, int count, {required bool isSelected}) {
    return Tab(
      height: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              _getReactionIcon(reactionName),
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
          const SizedBox(height: 4),
          Text(
            reactionName,
            style: TextStyle(
              fontSize: 11,
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

  Widget _buildUserList(String? reactionType) {
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
        String userName = 'Unknown User';
        String userAvatar = '';
        String userReaction = '';
        
        if (user is Map<String, dynamic>) {
          userName = (user['userName'] as String?) ?? 'Unknown User';
          userAvatar = (user['userAvatar'] as String?) ?? '';
          userReaction = (user['reactionName'] as String?) ?? '';
        } else if (user is ReactionsItem) {
          userName = user.userName ?? 'Unknown User';
          userAvatar = user.userAvatar ?? '';
          userReaction = user.reactionName ?? '';
        }

        return _buildUserListItem(userName, userAvatar, userReaction);
      },
    );
  }

  Widget _buildUserListItem(String userName, String userAvatar, String userReaction) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.grey[200],
              backgroundImage: userAvatar.isNotEmpty ? NetworkImage(userAvatar) : null,
              child: userAvatar.isEmpty
                  ? Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            if (userReaction.isNotEmpty)
              Positioned(
                right: -5,
                bottom: -3,
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 3,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Transform.scale(
                      scale: 0.7,
                      child: _getReactionIcon(userReaction, size: 12),
                    ),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          userName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'FacebookSans',
          ),
        ),
        trailing: userReaction.isNotEmpty
            ? Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: _getReactionIcon(userReaction, size: 16),
                ),
              )
            : null,
      ),
    );
  }
}