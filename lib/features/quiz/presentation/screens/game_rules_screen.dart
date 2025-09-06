import 'package:flutter/material.dart';

class GameRulesScreen extends StatelessWidget {
  final String categoryName;
  final int level;
  final VoidCallback onContinue;

  const GameRulesScreen({
    super.key,
    required this.categoryName,
    required this.level,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8F7AE8), // Purple background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Game Rules',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RuleItem(
                          number: 1, text: 'The quiz consists of 5 questions.'),
                      SizedBox(height: 16),
                      RuleItem(
                          number: 2,
                          text: 'You have 15 seconds to answer each question.'),
                      SizedBox(height: 16),
                      RuleItem(
                        number: 3,
                        text:
                            'If you do not answer within the time limit, the question will be marked as incorrect.',
                      ),
                      SizedBox(height: 16),
                      RuleItem(
                        number: 4,
                        text:
                            'To win the quiz, you must answer at least 3 questions correctly.',
                      ),
                      SizedBox(height: 16),
                      RuleItem(
                          number: 5,
                          text:
                              'Each question will be presented one at a time.'),
                      SizedBox(height: 16),
                      RuleItem(
                        number: 6,
                        text:
                            'You cannot go back to a previous question once you have moved to the next one.',
                      ),
                      SizedBox(height: 16),
                      RuleItem(
                          number: 7,
                          text:
                              'Each question will have multiple-choice answers.'),
                      SizedBox(height: 16),
                      RuleItem(
                          number: 8,
                          text:
                              'Select the correct answer from the given options.'),
                      SizedBox(height: 16),
                      RuleItem(
                        number: 9,
                        text:
                            'Submit your answer before the 15-second timer runs out.',
                      ),
                      SizedBox(height: 16),
                      RuleItem(
                        number: 10,
                        text:
                            'The quiz will automatically end after all 5 questions have been attempted.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RuleItem extends StatelessWidget {
  final int number;
  final String text;

  const RuleItem({
    super.key,
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$number.',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
