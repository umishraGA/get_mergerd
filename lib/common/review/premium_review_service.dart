import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumReviewService {
  static const String _lastReviewPromptKey = 'last_review_prompt';
  static const String _hasRatedKey = 'has_rated_app';
  static const String _hasFiveStarKey = 'has_five_star_rating';
  static const Duration _minTimeBetweenPrompts = Duration(days: 1);

  static final InAppReview _inAppReview = InAppReview.instance;

  static Future<void> _launchPlayStore() async {
    final Uri url = Uri.parse('market://details?id=com.invictus.pettracker');
    if (!await launchUrl(url)) {
      // If the market URL fails, try the web URL
      final Uri webUrl = Uri.parse(
          'https://play.google.com/store/apps/details?id=com.invictus.pettracker');
      if (!await launchUrl(webUrl)) {
        throw Exception('Could not launch store URL');
      }
    }
  }

  static Future<void> markAsFiveStarRating() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasFiveStarKey, true);
    await prefs.setBool(_hasRatedKey, true);
  }

  static Future<void> showReviewDialogIfNeeded(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final lastPrompt = prefs.getInt(_lastReviewPromptKey);
    final hasRated = prefs.getBool(_hasRatedKey) ?? false;
    final hasFiveStar = prefs.getBool(_hasFiveStarKey) ?? false;

    // showDialog(
    //     context: context,
    //     builder: (context) => _PremiumReviewDialog(),
    //   );

    if (hasRated && !hasFiveStar) return;

    final now = DateTime.now().millisecondsSinceEpoch;

    if (lastPrompt != null) {
      final timeSinceLastPrompt = Duration(
        milliseconds: now - lastPrompt,
      );
      if (timeSinceLastPrompt < _minTimeBetweenPrompts) return;
    }

    // Update last prompt time
    await prefs.setInt(_lastReviewPromptKey, now);

    if (hasFiveStar) {
      // Show in-app review directly for 5-star users
      if (await _inAppReview.isAvailable()) {
        await _inAppReview.requestReview();
      }
    } else if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => _PremiumReviewDialog(),
      );
    }
  }
}

class _PremiumReviewDialog extends StatefulWidget {
  @override
  _PremiumReviewDialogState createState() => _PremiumReviewDialogState();
}

class _PremiumReviewDialogState extends State<_PremiumReviewDialog> {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      title: Text(
        'Enjoying This App?',
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
            'How would you rate your premium experience?',
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
                      await PremiumReviewService.markAsFiveStarRating();
                      await PremiumReviewService._launchPlayStore();
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
