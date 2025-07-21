import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class NonPremiumReviewService {
  static const String _lastReviewPromptKeyForNonPremium = 'last_review_prompt_non_premium';
  static const String _hasRatedkKeyForNonPremium = 'has_rated_app_non_premium';
  static const String _hasRatedkFiveStarKeyForNonPremium = 'has_rated_five_star_non_premium';
  static const String _reviewCountForNonPremium = 'review_count_non_premium';
  static const Duration _minTimeBetweenPrompts = Duration(days: 1);

  static final InAppReview _inAppReview = InAppReview.instance;

  static Future<void> markAsRatedForNonPremium() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasRatedkKeyForNonPremium, true);
  }

  static Future<void> showReviewForNonPremium(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hasRated = prefs.getBool(_hasRatedkKeyForNonPremium) ?? false;
    final hasFiveStar = prefs.getBool(_hasRatedkFiveStarKeyForNonPremium) ?? false;

    if (hasRated && !hasFiveStar) return;

    // Increment and check review count first
    final currentCount = prefs.getInt(_reviewCountForNonPremium) ?? 0;
    final newCount = currentCount + 1;
    await prefs.setInt(_reviewCountForNonPremium, newCount);
    
    print("Review count: $newCount");
    if (newCount < 2) return; // Show after reaching count of 2

    final lastPrompt = prefs.getInt(_lastReviewPromptKeyForNonPremium);
    final now = DateTime.now().millisecondsSinceEpoch;

    if (lastPrompt != null) {
      final timeSinceLastPrompt = Duration(
        milliseconds: now - lastPrompt,
      );
      if (timeSinceLastPrompt < _minTimeBetweenPrompts) return;
    }

    print("Showing review dialog");
    // Update last prompt time
    await prefs.setInt(_lastReviewPromptKeyForNonPremium, now);

    if (hasFiveStar) {
      print("User has 5 stars, showing in-app review");
      // Show in-app review directly without dialog for 5-star users
      if (await _inAppReview.isAvailable()) {
        await _inAppReview.requestReview();
      }
    } else if (context.mounted) {
      print("Showing custom review dialog");
      await showDialog(
        context: context,
        builder: (context) => _NonPremiumReviewDialog(),
      );
      print("Dialog closed");
    }
  }
}

class _NonPremiumReviewDialog extends StatefulWidget {
  @override
  _NonPremiumReviewDialogState createState() => _NonPremiumReviewDialogState();
}

class _NonPremiumReviewDialogState extends State<_NonPremiumReviewDialog> {
  int _rating = 0;
  bool _isHovering = false;
  int _hoverRating = 0;

  
    void _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  void _launchPlayStore() async {
    final Uri playStoreUri = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.invictus.pettracker'
    );
    
    if (await canLaunchUrl(playStoreUri)) {
      await launchUrl(playStoreUri, mode: LaunchMode.externalApplication);
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      title: Text(
        'Enjoying Pet Tracker?',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'How would you rate your experience?',
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => MouseRegion(
                onEnter: (_) => setState(() {
                  _isHovering = true;
                  _hoverRating = index + 1;
                }),
                onExit: (_) => setState(() {
                  _isHovering = false;
                  _hoverRating = 0;
                }),
                child: GestureDetector(
                  onTap: () async {
                    setState(() => _rating = index + 1);
                    if (_rating >= 4) {
                      await NonPremiumReviewService.markAsRatedForNonPremium();
                      _launchPlayStore();
                    } else {
                      _launchURL('https://forms.gle/LgftznGF1rmDAv627');
                    }
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      (_isHovering ? _hoverRating > index : _rating > index)
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: (_isHovering ? _hoverRating > index : _rating > index)
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Maybe Later',
            style: TextStyle(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
