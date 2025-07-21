import 'package:flutter/material.dart';

/// A collection of bottom sheet widgets for the quiz feature
class QuizDialogs {
  /// Shows a bottom sheet when a level is locked
  static Future<bool> showLevelLockedDialog(
    BuildContext context, {
    int coinsToUnlock = 100,
  }) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LevelLockedBottomSheet(
        coinsToUnlock: coinsToUnlock,
      ),
    );
    return result ?? false;
  }

  /// Shows a confirmation bottom sheet for using a power-up
  static Future<bool> showPowerUpConfirmation(
    BuildContext context, {
    required String powerUpName,
    int coinCost = 50,
  }) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PowerUpConfirmationBottomSheet(
        powerUpName: powerUpName,
        coinCost: coinCost,
      ),
    );
    return result ?? false;
  }

  /// Shows a bottom sheet to report a question
  static Future<String?> showReportQuestionDialog(
    BuildContext context,
  ) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _ReportQuestionBottomSheet(),
    );
    return result;
  }

  /// Shows a dialog asking if the user wants to quit the quiz
  static Future<bool> showQuitConfirmationDialog(
    BuildContext context,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const _QuitConfirmationDialog(),
    );
    return result ?? false;
  }
}

/// Base bottom sheet widget with common styling
class _BaseBottomSheet extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const _BaseBottomSheet({
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        // Add padding for bottom safe area
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

/// Bottom sheet shown when a level is locked
class _LevelLockedBottomSheet extends StatelessWidget {
  final int coinsToUnlock;

  const _LevelLockedBottomSheet({
    required this.coinsToUnlock,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Level Locked',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Complete previous levels to unlock this one!',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8F7AE8),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('Use $coinsToUnlock coins to Play'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'No thanks',
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet shown to confirm using a power-up
class _PowerUpConfirmationBottomSheet extends StatelessWidget {
  final String powerUpName;
  final int coinCost;

  const _PowerUpConfirmationBottomSheet({
    required this.powerUpName,
    required this.coinCost,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Use $powerUpName',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Are you sure you want to use this for $coinCost Coins?',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8F7AE8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet shown to report a question
class _ReportQuestionBottomSheet extends StatefulWidget {
  const _ReportQuestionBottomSheet();

  @override
  State<_ReportQuestionBottomSheet> createState() =>
      _ReportQuestionBottomSheetState();
}

class _ReportQuestionBottomSheetState
    extends State<_ReportQuestionBottomSheet> {
  String? _selectedReason;
  final List<String> _reportReasons = [
    'Incorrect question',
    'Incorrect answer',
    'Inappropriate content',
    'Duplicate question',
    'Poorly worded question',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return _BaseBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Report this Question',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _showReasonSelector(context),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedReason ?? 'Select a reason',
                    style: TextStyle(
                      color: _selectedReason != null
                          ? Colors.black
                          : Colors.black54,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _selectedReason != null
                      ? () => Navigator.pop(context, _selectedReason)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8F7AE8),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade400,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showReasonSelector(BuildContext context) async {
    final selectedReason = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.3,
          maxChildSize: 0.6,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 4),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Select a reason',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: _reportReasons.length,
                    itemBuilder: (context, index) {
                      final reason = _reportReasons[index];
                      return ListTile(
                        title: Text(reason),
                        onTap: () => Navigator.pop(context, reason),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (selectedReason != null) {
      setState(() {
        _selectedReason = selectedReason;
      });
    }
  }
}

/// Dialog shown when user tries to exit a quiz
class _QuitConfirmationDialog extends StatelessWidget {
  const _QuitConfirmationDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        'Resume Quiz',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      content: const Text(
        'Would you like to resume from where you left off or start over?',
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8F7AE8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Resume Quiz'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Start Over',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
