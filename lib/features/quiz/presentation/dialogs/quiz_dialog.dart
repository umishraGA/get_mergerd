import 'package:flutter/material.dart';

class QuizQuestionDialogs {
  /// Quit confirmation dialog
  static Future<bool> showQuitConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Quit Quiz?"),
          content: const Text("Are you sure you want to quit the quiz?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Resume"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Quit"),
            ),
          ],
        );
      },
    ) ??
        false;
  }

  /// Lifeline / power-up confirmation dialog
  static Future<bool> showPowerUpConfirmation(
      BuildContext context, {
        required String powerUpName,
        required int coinCost,
      }) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Use $powerUpName?"),
          content: Text("This will cost $coinCost coins. Continue?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Use"),
            ),
          ],
        );
      },
    ) ??
        false;
  }

  /// Report question dialog
  static Future<String?> showReportQuestionDialog(BuildContext context) async {
    final TextEditingController controller = TextEditingController();

    return await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Report Question"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Enter reason...",
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text("Report"),
            ),
          ],
        );
      },
    );
  }

  /// ✅ Audience Poll dialog (FIX)
  static Future<void> showAudiencePollDialog(
      BuildContext context, {
        required List<String> options,
        required List<int> percentages,
      }) async {
    assert(options.length == percentages.length,
    "Options and percentages must match");

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Audience Poll"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(options.length, (index) {
              return Row(
                children: [
                  Expanded(child: Text(options[index])),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: LinearProgressIndicator(
                      value: percentages[index] / 100,
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue,
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text("${percentages[index]}%"),
                ],
              );
            }),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }


}
