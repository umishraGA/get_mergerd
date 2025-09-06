import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/common/enum/enum.dart';
import '../controller/quiz_question_controller.dart';
import '../model/quiz_question_model.dart';

class MultipleChoiceContent extends StatelessWidget {
  final QuizQuestionData currentQuestion;
  final List<String> currentOptions;
  final List<int>? removedOptions;
  final int? selectedAnswerIndex;
  final AnswerState answerState;
  final Function(int) onTapOption;
  final QuizType quizType;

  const MultipleChoiceContent({
    super.key,
    required this.currentQuestion,
    required this.currentOptions,
    this.removedOptions,
    this.selectedAnswerIndex,
    required this.answerState,
    required this.onTapOption,
    required this.quizType,
  });

  int getCorrectAnswerIndex() {
    switch (currentQuestion.answer?.toUpperCase()) {
      case 'A':
        return 0;
      case 'B':
        return 1;
      case 'C':
        return 2;
      case 'D':
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final QuizQuestionController controller = Get.find();
    final allIndexes = List.generate(currentOptions.length, (i) => i);
    final enabledIndexes = removedOptions == null
        ? allIndexes
        : allIndexes.where((i) => !removedOptions!.contains(i)).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Question card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 1,
                  offset: Offset(0, 1),
                )
              ],
            ),
            child: Text(
              currentQuestion.question ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Options
          ...List.generate(currentOptions.length, (index) {
            bool isSelected = selectedAnswerIndex == index;
            bool isCorrect = answerState != AnswerState.unanswered &&
                index == getCorrectAnswerIndex();
            bool isIncorrect =
                answerState == AnswerState.incorrect && isSelected;
            bool isDisabled =
                removedOptions != null && removedOptions!.contains(index);
            bool isEnabled = enabledIndexes.contains(index);

            Color cardColor;
            Color textColor = Colors.black87;
            Icon? optionIcon;

            if (isCorrect) {
              cardColor = Colors.green[500]!;
              textColor = Colors.white;
              optionIcon = const Icon(Icons.check, color: Colors.white, size: 22);
            } else if (isIncorrect) {
              cardColor = Colors.red[500]!;
              textColor = Colors.white;
              optionIcon = const Icon(Icons.close, color: Colors.white, size: 22);
            } else if (isSelected) {
              cardColor = Colors.blue[200]!;
            } else {
              cardColor = Colors.white;
            }

            return GestureDetector(
              onTap: !isEnabled || answerState != AnswerState.unanswered
                  ? null
                  : () => onTapOption(index),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey[300]!,
                    width: 1.5,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: isSelected || isCorrect || isIncorrect
                          ? Colors.white
                          : Colors.grey[200],
                      child: Text(
                        String.fromCharCode(65 + index),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected || isCorrect || isIncorrect
                              ? Colors.black
                              : Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        currentOptions[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDisabled ? Colors.grey : textColor,
                        ),
                      ),
                    ),
                    if (optionIcon != null) optionIcon,
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 24),

          if (answerState != AnswerState.unanswered)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              decoration: BoxDecoration(
                color: answerState == AnswerState.correct
                    ? Colors.green.withOpacity(0.2)
                    : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                controller.feedbackText(answerState),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: answerState == AnswerState.correct
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
