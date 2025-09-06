import 'package:flutter/material.dart';
import 'package:myapp/features/story/controllers/story_controller.dart';
import '../widgets/shimmer_loading_widgets.dart';
import '../widgets/StoryCardWidget.dart';

/// Horizontal row widget displaying stories in the social feed
class SocialFeedStoriesRow extends StatefulWidget {
  /// Creates a [SocialFeedStoriesRow] widget
  const SocialFeedStoriesRow({super.key});

  @override
  State<SocialFeedStoriesRow> createState() => _SocialFeedStoriesRowState();
}

class _SocialFeedStoriesRowState extends State<SocialFeedStoriesRow> {
  late final StoryController _storyController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _storyController = StoryController();
    _initializeController();
  }

  Future<void> _initializeController() async {
    try {
      await _storyController.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing story controller: $e');
      if (mounted) {
        setState(() {
          _isInitialized = true; // Still show UI with fallback data
        });
      }
    }
  }

  @override
  void dispose() {
    _storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: const StoriesShimmerLoading(),
      );
    }

    return ListenableBuilder(
      listenable: _storyController,
      builder: (context, child) {
        final stories = _storyController.getStoriesWithMedia();
        debugPrint('SocialFeedStoriesRow rendering ${stories.length} stories');

        if (_storyController.isLoading && stories.isEmpty) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: const StoriesShimmerLoading(),
          );
        }

        if (stories.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 200,
          margin: const EdgeInsets.only(bottom: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            // Prevent parent scroll interference
            physics: const ClampingScrollPhysics(),
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];
              return StoryCardWidget(
                story: story,
                storyIndex: index,
                allStories: stories, // Pass only the filtered stories with media
              );
            },
          ),
        );
      },
    );
  }
}
