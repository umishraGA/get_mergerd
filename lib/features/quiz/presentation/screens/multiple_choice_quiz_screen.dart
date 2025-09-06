import 'dart:async';

import 'package:flutter/material.dart';

class MultipleChoiceQuizScreen extends StatefulWidget {
  final String categoryName;
  final int level;

  const MultipleChoiceQuizScreen({
    super.key,
    required this.categoryName,
    required this.level,
  });

  @override
  State<MultipleChoiceQuizScreen> createState() =>
      _MultipleChoiceQuizScreenState();
}

class _MultipleChoiceQuizScreenState extends State<MultipleChoiceQuizScreen> {
  int _currentQuestionIndex = 0;
  int _timeLeft = 15;
  int _score = 0;
  int? _selectedAnswerIndex;
  bool _isAnswered = false;
  late Timer _timer;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is the capital of France?',
      'options': ['Berlin', 'London', 'Paris', 'Rome'],
      'correctIndex': 2,
    },
    {
      'question': 'What is the largest planet in our solar system?',
      'options': ['Earth', 'Jupiter', 'Saturn', 'Mars'],
      'correctIndex': 1,
    },
    {
      'question': 'What element has the chemical symbol "O"?',
      'options': ['Gold', 'Osmium', 'Oxygen', 'Oganesson'],
      'correctIndex': 2,
    },
    {
      'question': 'Which of these is NOT a primary color?',
      'options': ['Red', 'Yellow', 'Blue', 'Green'],
      'correctIndex': 3,
    },
    {
      'question': 'What is the smallest prime number?',
      'options': ['0', '1', '2', '3'],
      'correctIndex': 2,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer.cancel();
        _handleTimeUp();
      }
    });
  }

  void _handleTimeUp() {
    if (!_isAnswered) {
      setState(() {
        _isAnswered = true;
      });

      Future.delayed(const Duration(seconds: 1), () {
        _nextQuestion();
      });
    }
  }

  void _checkAnswer(int selectedIndex) {
    if (_isAnswered) return;

    _timer.cancel();
    final correctIndex =
        _questions[_currentQuestionIndex]['correctIndex'] as int;

    setState(() {
      _selectedAnswerIndex = selectedIndex;
      _isAnswered = true;
      if (selectedIndex == correctIndex) {
        _score++;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _timeLeft = 15;
        _isAnswered = false;
        _selectedAnswerIndex = null;
      });
      _startTimer();
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Quiz Completed!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your Score: $_score/${_questions.length}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _score >= 3
                    ? 'Congratulations! You passed the quiz.'
                    : 'Keep practicing. You need at least 3 correct answers to pass.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _score >= 3 ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Back to levels screen
              },
              child: const Text('Back to Levels'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                setState(() {
                  _currentQuestionIndex = 0;
                  _timeLeft = 15;
                  _score = 0;
                  _isAnswered = false;
                  _selectedAnswerIndex = null;
                });
                _startTimer();
              },
              child: const Text('Try Again'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];
    final options = currentQuestion['options'] as List<String>;
    final correctIndex = currentQuestion['correctIndex'] as int;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF8F7AE8),
        title: Text(
          '${widget.categoryName} - Level ${widget.level}',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Quit Quiz?'),
                content: const Text(
                    'Are you sure you want to quit? Your progress will be lost.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Close quiz
                    },
                    child: const Text('Quit'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Progress bar and timer
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: Colors.grey[300],
              color: const Color(0xFF8F7AE8),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          _timeLeft > 5 ? const Color(0xFF8F7AE8) : Colors.red,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.timer,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$_timeLeft s',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Question
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                currentQuestion['question'] as String,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Options
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  // Determine the button's style based on answer state
                  Color bgColor = Colors.white;
                  Color borderColor = const Color(0xFF8F7AE8);

                  if (_isAnswered) {
                    if (index == correctIndex) {
                      bgColor = Colors.green.shade100;
                      borderColor = Colors.green;
                    } else if (index == _selectedAnswerIndex) {
                      bgColor = Colors.red.shade100;
                      borderColor = Colors.red;
                    }
                  } else if (_selectedAnswerIndex == index) {
                    bgColor = const Color(0xFFE0D9FF);
                  }

                  return GestureDetector(
                    onTap: _isAnswered ? null : () => _checkAnswer(index),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: bgColor,
                        border: Border.all(color: borderColor, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: _isAnswered
                                  ? (index == correctIndex
                                      ? Colors.green
                                      : (index == _selectedAnswerIndex
                                          ? Colors.red
                                          : Colors.grey))
                                  : const Color(0xFF8F7AE8),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + index), // A, B, C, D
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              options[index],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          if (_isAnswered)
                            Icon(
                              index == correctIndex
                                  ? Icons.check_circle
                                  : (index == _selectedAnswerIndex
                                      ? Icons.cancel
                                      : null),
                              color: index == correctIndex
                                  ? Colors.green
                                  : Colors.red,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
