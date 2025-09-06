import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/common/enum/enum.dart';
import '../controller/quiz_question_controller.dart';
import '../model/quiz_question_model.dart';

class WordGuessScreen extends StatefulWidget {
  final QuizQuestionData currentQuestion;
  final Function(bool) onResult;
  final AnswerState answerState;

  const WordGuessScreen({
    super.key,
    required this.currentQuestion,
    required this.onResult,
    required this.answerState,
  });

  @override
  State<WordGuessScreen> createState() => _WordGuessScreenState();
}

class _WordGuessScreenState extends State<WordGuessScreen> {
  final QuizQuestionController _controller = Get.find();
  List<String> _enteredWord = [];
  Set<String> _lettersSelected = {};
  List<String> _keyboard = [];
  late String answer;
  bool _hasSubmitted = false;

  @override
  void initState() {
    super.initState();
    answer = widget.currentQuestion.answer?.toUpperCase() ?? "";
    _keyboard = _generateKeyboard(answer);
  }

  @override
  void didUpdateWidget(WordGuessScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reset the screen when moving to a new question
    if (oldWidget.currentQuestion.id != widget.currentQuestion.id) {
      _resetWordGuess();
    }

    // Reset when answer state changes from answered to unanswered (new question)
    if (oldWidget.answerState != AnswerState.unanswered &&
        widget.answerState == AnswerState.unanswered) {
      _resetWordGuess();
    }
  }

  List<String> _generateKeyboard(String answer) {
    final random = Random();
    const letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

    List<String> result = answer.split('');
    while (result.length < answer.length + 6) {
      String letter = letters[random.nextInt(letters.length)];
      result.add(letter);
    }

    result.shuffle(random);
    return result;
  }

  void _resetWordGuess() {
    setState(() {
      _enteredWord = [];
      _lettersSelected = {};
      _hasSubmitted = false;
      answer = widget.currentQuestion.answer?.toUpperCase() ?? "";
      _keyboard = _generateKeyboard(answer);
    });
  }

  void _selectLetter(String letter, int index) {
    if (_enteredWord.length >= answer.length || _hasSubmitted) return;
    setState(() {
      _enteredWord.add(letter);
      _lettersSelected.add("$letter-$index");
    });
  }

  void _removeLetter() {
    if (_enteredWord.isNotEmpty && !_hasSubmitted) {
      setState(() {
        String removed = _enteredWord.removeLast();
        _lettersSelected.removeWhere((s) => s.startsWith(removed));
      });
    }
  }

  void _submitWord() {
    if (_hasSubmitted) return;

    bool isCorrect = _enteredWord.join() == answer;
    setState(() {
      _hasSubmitted = true;
    });

    widget.onResult(isCorrect);
  }

  Color _getLetterColor(int index) {
    if (!_hasSubmitted) return Colors.black;

    String correctAnswer = answer;
    String enteredLetter = index < _enteredWord.length ? _enteredWord[index] : "";

    if (index >= correctAnswer.length) return Colors.black;

    String correctLetter = correctAnswer[index];

    if (enteredLetter == correctLetter) {
      return Colors.green; // Correct letter in correct position
    } else if (correctAnswer.contains(enteredLetter)) {
      return Colors.orange; // Correct letter but wrong position
    } else {
      return Colors.red; // Incorrect letter
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Question
          Container(
            height: 160,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F4F8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.currentQuestion.question ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          // Letter slots with feedback colors
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: List.generate(answer.length, (index) {
              String displayLetter = index < _enteredWord.length ? _enteredWord[index] : "";
              return Container(
                width: 40,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(
                    color: Colors.black54,
                    width: 2,
                  )),
                  color: _hasSubmitted ? _getLetterColor(index).withOpacity(0.2) : Colors.transparent,
                ),
                child: Text(
                  displayLetter,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _getLetterColor(index),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),

          // Feedback message based on answer state
          if (widget.answerState != AnswerState.unanswered)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: widget.answerState == AnswerState.correct
                    ? Colors.green.withOpacity(0.2)
                    : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _controller.feedbackText(widget.answerState),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: widget.answerState == AnswerState.correct
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ),
          const SizedBox(height: 10),
          if (widget.answerState == AnswerState.incorrect && _hasSubmitted)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                "Answer: $answer",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          const SizedBox(height: 20),

          // Keyboard
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: List.generate(_keyboard.length, (index) {
                String letter = _keyboard[index];
                bool isSelected = _lettersSelected.contains('$letter-$index');
                bool isDisabled = widget.answerState != AnswerState.unanswered || _hasSubmitted;

                return GestureDetector(
                  onTap: isSelected || isDisabled ? null : () => _selectLetter(letter, index),
                  child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue.withOpacity(0.3)
                          : isDisabled
                          ? Colors.grey.shade300
                          : Colors.white,
                      border: Border.all(
                        color: isDisabled ? Colors.grey : Colors.blue,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: isDisabled ? null : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        )
                      ],
                    ),
                    child: Text(
                      letter,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.blue
                            : isDisabled
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                ),
                onPressed: widget.answerState != AnswerState.unanswered || _hasSubmitted
                    ? null
                    : _removeLetter,
                child: const Text("Back"),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: widget.answerState != AnswerState.unanswered ||
                    _hasSubmitted ||
                    _enteredWord.length != answer.length
                    ? null
                    : _submitWord,
                child: const Text("Submit"),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Status message
          if (_hasSubmitted && widget.answerState != AnswerState.unanswered)
            Text(
              "Moving to next question...",
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
        ],
      ),
    );
  }
}