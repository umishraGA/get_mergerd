import 'package:flutter/material.dart';

import '../controller/quiz_question_controller.dart';

class QuizHeader extends StatelessWidget {
  final QuizQuestionController controller;
  final int currentIndex;
  final int level;
  final int timeLeft;
  final VoidCallback onQuit;
  final VoidCallback onReport;

  const QuizHeader({
    super.key,
    required this.controller,
    required this.currentIndex,
    required this.level,
    required this.timeLeft,
    required this.onQuit,
    required this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(onTap: onQuit, child: const Icon(Icons.arrow_back)),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Stack(
                    children: [
                      FractionallySizedBox(
                        widthFactor: (currentIndex + 1) /
                            controller.quizQuestionDataList.length,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFF4A44A), Color(0xFFEF9A38)],
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "${currentIndex + 1}/${controller.quizQuestionDataList.length}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(onTap: onReport, child: const Icon(Icons.flag_outlined)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Level $level | Question ${currentIndex + 1}/${controller.quizQuestionDataList.length}',
                  style: const TextStyle(fontSize: 16, color: Colors.black45)),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 45,
                    height: 45,
                    child: CircularProgressIndicator(
                      value: timeLeft / 20,
                      strokeWidth: 5,
                      color: timeLeft <= 5 ? Colors.red : Colors.green,
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                  Text('$timeLeft s',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
