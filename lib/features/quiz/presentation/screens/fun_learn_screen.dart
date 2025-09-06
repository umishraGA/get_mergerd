import 'package:flutter/material.dart';

class FunLearnScreen extends StatefulWidget {
  const FunLearnScreen({super.key});

  @override
  State<FunLearnScreen> createState() => _FunLearnScreenState();
}

class _FunLearnScreenState extends State<FunLearnScreen> {
  int _currentPassageIndex = 0;
  int _currentQuestionIndex = 0;
  int _score = 0;

  final List<Map<String, dynamic>> _passages = [
    {
      'title': 'The Water Cycle',
      'content': 'The water cycle is the process by which water moves around the Earth. '
          'It includes evaporation, condensation, precipitation, and collection. '
          'The sun heats up water from oceans, rivers, and lakes, turning it into vapor. '
          'This vapor rises into the atmosphere and forms clouds through condensation. '
          'When the clouds get heavy enough, the water falls back to Earth as rain or snow. '
          'This water then collects in bodies of water, and the cycle repeats.',
      'questions': [
        {
          'question': 'What powers the water cycle?',
          'options': ['Wind', 'The Sun', 'The Moon', 'Lightning'],
          'correctAnswer': 1,
        },
        {
          'question': 'What happens during evaporation?',
          'options': [
            'Water turns to ice',
            'Water falls from clouds',
            'Water turns to vapor',
            'Clouds form in the sky'
          ],
          'correctAnswer': 2,
        },
        {
          'question': 'What is precipitation?',
          'options': [
            'Water vapor rising',
            'Clouds forming',
            'Water falling as rain or snow',
            'Water collecting in oceans'
          ],
          'correctAnswer': 2,
        },
      ],
    },
    {
      'title': 'Healthy Eating',
      'content': 'Eating a balanced diet is important for good health. '
          'A healthy diet includes fruits, vegetables, whole grains, lean proteins, and healthy fats. '
          'Fruits and vegetables provide essential vitamins and minerals. '
          'Whole grains offer fiber for digestive health. '
          'Proteins are necessary for building and repairing tissues. '
          'Healthy fats support brain function and heart health. '
          'It\'s also important to stay hydrated by drinking plenty of water throughout the day.',
      'questions': [
        {
          'question': 'Why is fiber important in our diet?',
          'options': [
            'For muscle growth',
            'For digestive health',
            'For skin health',
            'For eye health'
          ],
          'correctAnswer': 1,
        },
        {
          'question':
              'Which food group provides essential vitamins and minerals?',
          'options': [
            'Sugars',
            'Processed foods',
            'Fruits and vegetables',
            'Sodas'
          ],
          'correctAnswer': 2,
        },
        {
          'question': 'What supports brain function and heart health?',
          'options': ['Healthy fats', 'Sugar', 'Salt', 'Caffeine'],
          'correctAnswer': 0,
        },
      ],
    },
  ];

  bool _isReadingMode = true;

  void _startQuiz() {
    setState(() {
      _isReadingMode = false;
      _currentQuestionIndex = 0;
    });
  }

  void _answerQuestion(int selectedOption) {
    final correctAnswer = _passages[_currentPassageIndex]['questions']
        [_currentQuestionIndex]['correctAnswer'] as int;
    final isCorrect = selectedOption == correctAnswer;

    if (isCorrect) {
      setState(() {
        _score++;
      });
    }

    final questions = _passages[_currentPassageIndex]['questions'] as List;
    if (_currentQuestionIndex < questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      // Finished all questions for this passage
      _showResultDialog();
    }
  }

  void _nextPassage() {
    if (_currentPassageIndex < _passages.length - 1) {
      setState(() {
        _currentPassageIndex++;
        _currentQuestionIndex = 0;
        _score = 0;
        _isReadingMode = true;
      });
    } else {
      // All passages completed
      Navigator.pop(context);
    }
  }

  void _showResultDialog() {
    final questions = _passages[_currentPassageIndex]['questions'] as List;
    final totalQuestions = questions.length;

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
                'Your Score: $_score/$totalQuestions',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                _score > totalQuestions / 2
                    ? 'Great job!'
                    : 'Better luck next time!',
                style: TextStyle(
                  color:
                      _score > totalQuestions / 2 ? Colors.orange : Colors.red,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _nextPassage();
              },
              child: Text(_currentPassageIndex < _passages.length - 1
                  ? 'Next Passage'
                  : 'Finish'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isReadingMode = true;
                  _currentQuestionIndex = 0;
                  _score = 0;
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
        title: const Text('Fun \'N\' Learn'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: _isReadingMode ? _buildReadingView() : _buildQuizView(),
    );
  }

  Widget _buildReadingView() {
    final passage = _passages[_currentPassageIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            passage['title'] as String,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                passage['content'] as String,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: _startQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text(
                'Start Quiz',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizView() {
    final questions = _passages[_currentPassageIndex]['questions'] as List;
    final currentQuestion =
        questions[_currentQuestionIndex] as Map<String, dynamic>;
    final totalQuestions = questions.length;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / totalQuestions,
            color: Colors.orange,
            backgroundColor: Colors.orange.shade100,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Question ${_currentQuestionIndex + 1} of $totalQuestions',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                currentQuestion['question'] as String,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: (currentQuestion['options'] as List).length,
              itemBuilder: (ctx, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    title: Text(
                      (currentQuestion['options'] as List)[index] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange.shade100,
                      child: Text(
                        String.fromCharCode(65 + index), // A, B, C, D...
                        style: TextStyle(
                          color: Colors.orange.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () => _answerQuestion(index),
                  ),
                );
              },
            ),
          ),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _isReadingMode = true;
              });
            },
            icon: const Icon(Icons.book, color: Colors.orange),
            label: const Text(
              'Review Passage',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}
