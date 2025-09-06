import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/features/quiz/presentation/controller/quiz_question_controller.dart';

class GameRulesScreen extends StatelessWidget {
  final String rules;
  final String type;
  final String levelId;
  final int level;
  final VoidCallback onContinue;
  const GameRulesScreen({
    super.key,
    required this.rules, required this.onContinue, required this.level, required this.type, required this.levelId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuizQuestionController());
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
                child: RuleItem(number: 1, text: rules),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onContinue,
                //   (){
                //   Get.off(()=> CountdownScreen(type: type, level: level, onCountdownComplete: () {
                //     controller.fetchQuizQuestionApi(levelId, type).then((_){
                //       Get.off(()=> QuizQuestionScreen(type: type, level: level, levelId: levelId,));
                //       // Get.off(()=> EnhancedQuizScreen(categoryName: '', level: 1,));
                //     });
                //   },),);
                // },
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
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
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
                fontSize: 16,
                height: 1.5,
                letterSpacing: 0.3,
                wordSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
