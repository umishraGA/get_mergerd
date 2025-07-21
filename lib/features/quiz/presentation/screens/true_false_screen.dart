import 'package:flutter/material.dart';

class TrueFalseScreen extends StatefulWidget {
  const TrueFalseScreen({super.key});

  @override
  State<TrueFalseScreen> createState() => _TrueFalseScreenState();
}

class _TrueFalseScreenState extends State<TrueFalseScreen>
    with SingleTickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool? _selectedAnswer;
  bool _isAnswerSelected = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'The Great Wall of China is visible from space.',
      'isTrue': false,
      'explanation':
          'Contrary to popular belief, the Great Wall of China cannot be seen from space with the naked eye.',
    },
    {
      'question': 'A day on Venus is longer than a year on Venus.',
      'isTrue': true,
      'explanation':
          'Venus rotates very slowly on its axis, taking about 243 Earth days to complete one rotation. Its orbital period (year) is only about 225 Earth days.',
    },
    {
      'question': 'The Eiffel Tower can be 15 cm taller during the summer.',
      'isTrue': true,
      'explanation':
          'Due to thermal expansion, the iron structure of the Eiffel Tower expands in the heat, making it taller in summer than in winter.',
    },
    {
      'question': 'Bananas grow on trees.',
      'isTrue': false,
      'explanation':
          'Although commonly referred to as banana trees, bananas actually grow on large herbs. The "trunk" is actually a pseudostem made of tightly packed leaves.',
    },
    {
      'question': 'Humans have five senses.',
      'isTrue': false,
      'explanation':
          'Humans have more than five senses. In addition to sight, smell, taste, touch, and hearing, we have senses like balance, temperature, pain, and proprioception (awareness of our body position).',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _checkAnswer(bool answer) {
    if (_isAnswerSelected) return;

    setState(() {
      _selectedAnswer = answer;
      _isAnswerSelected = true;
    });

    final correctAnswer = _questions[_currentQuestionIndex]['isTrue'] as bool;
    if (answer == correctAnswer) {
      _score++;
    }

    _animationController.forward();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        if (_currentQuestionIndex < _questions.length - 1) {
          setState(() {
            _currentQuestionIndex++;
            _selectedAnswer = null;
            _isAnswerSelected = false;
          });
          _animationController.reset();
        } else {
          // Quiz finished
          _showResultDialog();
        }
      }
    });
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Quiz Completed!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your Score: $_score/${_questions.length}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                _score > _questions.length / 2
                    ? 'Great job!'
                    : 'Better luck next time!',
                style: TextStyle(
                  color: _score > _questions.length / 2
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Back to Quiz Home'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _currentQuestionIndex = 0;
                  _score = 0;
                  _selectedAnswer = null;
                  _isAnswerSelected = false;
                  _animationController.reset();
                });
              },
              child: const Text('Try Again'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('True | False'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: Colors.grey[300],
              color: Colors.red,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Question card
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'TRUE OR FALSE?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _questions[_currentQuestionIndex]['question'] as String,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Answer buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildAnswerButton(true),
                          _buildAnswerButton(false),
                        ],
                      ),

                      // Explanation section (appears after answering)
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return SizeTransition(
                            sizeFactor: _animation,
                            child: child,
                          );
                        },
                        child: _isAnswerSelected
                            ? Padding(
                                padding: const EdgeInsets.only(top: 32),
                                child: Column(
                                  children: [
                                    Icon(
                                      (_selectedAnswer ?? false) ==
                                              (_questions[_currentQuestionIndex]
                                                  ['isTrue'] as bool)
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color: (_selectedAnswer ?? false) ==
                                              (_questions[_currentQuestionIndex]
                                                  ['isTrue'] as bool)
                                          ? Colors.green
                                          : Colors.red,
                                      size: 48,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'The statement is ${(_questions[_currentQuestionIndex]['isTrue'] as bool) ? 'TRUE' : 'FALSE'}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            (_questions[_currentQuestionIndex]
                                                    ['isTrue'] as bool)
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      _questions[_currentQuestionIndex]
                                          ['explanation'] as String,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerButton(bool isTrue) {
    final bool isSelected = (_selectedAnswer ?? false) == isTrue;
    final bool isCorrect =
        isTrue == (_questions[_currentQuestionIndex]['isTrue'] as bool);

    Color buttonColor = Colors.grey.shade200;
    if (_isAnswerSelected && isSelected) {
      buttonColor = isCorrect ? Colors.green.shade100 : Colors.red.shade100;
    }

    return GestureDetector(
      onTap: () => _checkAnswer(isTrue),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isTrue ? Colors.green : Colors.red,
            width: 3,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isTrue ? Icons.check_circle : Icons.cancel,
              color: isTrue ? Colors.green : Colors.red,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              isTrue ? 'TRUE' : 'FALSE',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isTrue ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
