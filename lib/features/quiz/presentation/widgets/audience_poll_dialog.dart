import 'package:flutter/material.dart';

class AudiencePollDialog extends StatelessWidget {
  final List<String> options;
  final List<int> percentages;
  final int correctIndex;

  const AudiencePollDialog({
    super.key,
    required this.options,
    required this.percentages,
    required this.correctIndex,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Audience Poll'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(options.length, (index) {
          final percent = percentages[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Text('${String.fromCharCode(65 + index)}: '),
                Expanded(
                  child: LinearProgressIndicator(
                    value: percent / 100,
                    color: index == correctIndex ? Colors.green : Colors.blue,
                    backgroundColor: Colors.grey[300],
                  ),
                ),
                const SizedBox(width: 8),
                Text('$percent%'),
              ],
            ),
          );
        }),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        )
      ],
    );
  }
}
