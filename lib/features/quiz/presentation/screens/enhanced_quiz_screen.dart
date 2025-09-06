import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

import '../widgets/quiz_dialog.dart';
import './quiz_result_screen.dart';

enum QuizType { multipleChoice, wordGuess }

enum AnswerState { unanswered, correct, incorrect, timeUp }

class EnhancedQuizScreen extends StatefulWidget {
  final String categoryName;
  final int level;
  final QuizType quizType;

  const EnhancedQuizScreen({
    super.key,
    required this.categoryName,
    required this.level,
    this.quizType = QuizType.multipleChoice,
  });

  @override
  State<EnhancedQuizScreen> createState() => _EnhancedQuizScreenState();
}

class _EnhancedQuizScreenState extends State<EnhancedQuizScreen>
    with SingleTickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  int _timeLeft = 20;
  int _score = 0;
  int? _selectedAnswerIndex;
  AnswerState _answerState = AnswerState.unanswered;
  late Timer _timer;

  // Animation controller for lifeline usage animation
  late AnimationController _lifelineAnimController;
  String? _activeLifeline;

  // For word guess mode
  String _enteredWord = '';
  // Updated to store letter-index combinations to handle duplicate letters
  List<String> _lettersSelected = [];

  // Lifelines
  bool _hasPollLifeline = true;
  bool _hasTimeLifeline = true;
  bool _hasBombLifeline = true;
  bool _hasSkipLifeline = true;

  // Hints counter - limit to 2 per question
  int _hintsUsed = 0;

  // Audience poll data
  List<int>? _audiencePollPercentages;
  int? _pollQuestionIndex; // Track which question used the poll lifeline
  // Removed wrong options (for bomb lifeline)
  List<int>? _removedOptions;
  int? _bombQuestionIndex; // Track which question used the bomb lifeline

  // Multiple choice questions
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'How many planets are in the Solar System?',
      'options': ['9', '10', '7', '5'],
      'correctIndex': 3,
    },
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
  ];

  // Word guess questions
  final List<Map<String, dynamic>> _wordGuessQuestions = [
    {
      'question': 'What is the name of this batsman?',
      'image': 'assets/images/quiz/quiz_zone.png',
      'answer': 'VIRAT',
      'keyboard': ['V', 'A', 'O', 'L', 'I', 'H', 'A', 'R', 'T', 'I', 'K', '_'],
    },
    {
      'question': 'What is the capital city of Japan?',
      'answer': 'TOKYO',
      'keyboard': ['T', 'O', 'K', 'Y', 'M', 'N', 'A', 'S', 'P', 'E', 'L', 'O'],
    },
  ];

  // Audio players
  final AudioPlayer _correctSoundPlayer = AudioPlayer();
  final AudioPlayer _wrongSoundPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _startTimer();
    _initAudio();

    // Initialize animation controller
    _lifelineAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _lifelineAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _lifelineAnimController.reverse();
        Future.delayed(const Duration(milliseconds: 600), () {
          setState(() {
            _activeLifeline = null;
          });
        });
      }
    });
  }

  Future<void> _initAudio() async {
    try {
      await _correctSoundPlayer
          .setAsset('assets/audio/quiz/correct-choice-43861.mp3');
      await _wrongSoundPlayer
          .setAsset('assets/audio/quiz/wronganswer-37702.mp3');
    } catch (e) {
      debugPrint('Error initializing audio: $e');
    }
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
    if (_answerState == AnswerState.unanswered) {
      setState(() {
        _answerState = AnswerState.timeUp;
      });

      _playSound(false);

      Future.delayed(const Duration(seconds: 2), () {
        _goToNextQuestion();
      });
    }
  }

  void _checkAnswer(int selectedIndex) {
    if (_answerState != AnswerState.unanswered) return;

    _timer.cancel();
    final correctIndex =
        _questions[_currentQuestionIndex]['correctIndex'] as int;

    setState(() {
      _selectedAnswerIndex = selectedIndex;
      _answerState = selectedIndex == correctIndex
          ? AnswerState.correct
          : AnswerState.incorrect;

      if (selectedIndex == correctIndex) {
        _score++;
      }
    });

    _playSound(_answerState == AnswerState.correct);

    Future.delayed(const Duration(seconds: 2), () {
      _goToNextQuestion();
    });
  }

  void _selectOption(int index) {
    if (_answerState != AnswerState.unanswered) return;

    setState(() {
      _selectedAnswerIndex = index;
    });
  }

  void _submitAnswer() {
    if (_answerState != AnswerState.unanswered || _selectedAnswerIndex == null)
      return;

    _timer.cancel();
    final correctIndex =
        _questions[_currentQuestionIndex]['correctIndex'] as int;

    setState(() {
      _answerState = _selectedAnswerIndex == correctIndex
          ? AnswerState.correct
          : AnswerState.incorrect;

      if (_selectedAnswerIndex == correctIndex) {
        _score++;
      }
    });

    // Play feedback sound and haptic
    _playSound(_answerState == AnswerState.correct);

    // Automatically proceed to next question after delay
    Future.delayed(const Duration(seconds: 2), () {
      _goToNextQuestion();
    });
  }

  void _checkWordGuess() {
    if (_answerState != AnswerState.unanswered) return;

    _timer.cancel();
    final correctAnswer =
        _wordGuessQuestions[_currentQuestionIndex]['answer'] as String;

    setState(() {
      _answerState = _enteredWord == correctAnswer
          ? AnswerState.correct
          : AnswerState.incorrect;

      if (_enteredWord == correctAnswer) {
        _score++;
      }
    });

    _playSound(_answerState == AnswerState.correct);

    Future.delayed(const Duration(seconds: 2), () {
      _goToNextQuestion();
    });
  }

  void _selectLetter(String letter, [int? specificIndex]) {
    if (_answerState != AnswerState.unanswered) return;

    setState(() {
      if (_enteredWord.length < 5) {
        // Assuming max word length is 5
        _enteredWord += letter;

        // Use the provided specific index if available (for identifying exact button position)
        final String letterKey = specificIndex != null
            ? '$letter-$specificIndex'
            : '$letter-${(_wordGuessQuestions[_currentQuestionIndex]['keyboard'] as List<String>).indexOf(letter)}';

        _lettersSelected.add(letterKey);
      }
    });
  }

  void _removeLetter() {
    if (_enteredWord.isNotEmpty) {
      setState(() {
        _lettersSelected.removeLast();
        _enteredWord = _enteredWord.substring(0, _enteredWord.length - 1);
      });
    }
  }

  void _playSound(bool isCorrect) {
    // Play sound effect
    HapticFeedback.mediumImpact();
    try {
      if (isCorrect) {
        _correctSoundPlayer.seek(Duration.zero);
        _correctSoundPlayer.play();
      } else {
        _wrongSoundPlayer.seek(Duration.zero);
        _wrongSoundPlayer.play();
      }
    } catch (e) {
      debugPrint('Error playing quiz sound: $e');
    }
  }

  void _goToNextQuestion() {
    if (widget.quizType == QuizType.multipleChoice) {
      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _timeLeft = 20;
          _answerState = AnswerState.unanswered;
          _selectedAnswerIndex = null;
          _hintsUsed = 0; // Reset hints counter for new question

          // Clear removed options if they were for the previous question
          if (_bombQuestionIndex != _currentQuestionIndex) {
            _removedOptions = null;
          }
        });
        _startTimer();
      } else {
        _showResultDialog();
      }
    } else {
      if (_currentQuestionIndex < _wordGuessQuestions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _timeLeft = 20;
          _answerState = AnswerState.unanswered;
          _enteredWord = '';
          _lettersSelected = [];
          _hintsUsed = 0; // Reset hints counter for new question
        });
        _startTimer();
      } else {
        _showResultDialog();
      }
    }
  }

  void _showResultDialog() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(
          categoryName: widget.categoryName,
          level: widget.level,
          correctAnswers: _score,
          totalQuestions: widget.quizType == QuizType.multipleChoice
              ? _questions.length
              : _wordGuessQuestions.length,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => EnhancedQuizScreen(
                  categoryName: widget.categoryName,
                  level: widget.level,
                  quizType: widget.quizType,
                ),
              ),
            );
          },
          onHome: () {
            Navigator.of(context).pop();
          },
          onNextLevel: _score >=
                  (widget.quizType == QuizType.multipleChoice
                          ? _questions.length
                          : _wordGuessQuestions.length) /
                      2
              ? () {
                  // Show level unlock dialog if it's a higher level
                  if (widget.level >= 5) {
                    QuizDialogs.showLevelLockedDialog(
                      context,
                      coinsToUnlock: 100 + (widget.level * 10),
                    ).then((bool unlocked) {
                      if (unlocked) {
                        _goToNextLevel();
                      } else {
                        Navigator.of(context).pop();
                      }
                    });
                  } else {
                    _goToNextLevel();
                  }
                }
              : null,
        ),
      ),
    );
  }

  void _goToNextLevel() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => EnhancedQuizScreen(
          categoryName: widget.categoryName,
          level: widget.level + 1,
          quizType: widget.quizType,
        ),
      ),
    );
  }

  void _useLifeline(String lifeline) {
    setState(() {
      _activeLifeline = lifeline;
    });
    _lifelineAnimController.forward();

    switch (lifeline) {
      case 'poll':
        if (_hasPollLifeline) {
          QuizDialogs.showPowerUpConfirmation(
            context,
            powerUpName: 'Audience Poll',
            coinCost: 50,
          ).then((bool confirmed) {
            if (confirmed) {
              setState(() {
                _hasPollLifeline = false;

                // Generate audience poll percentages
                if (widget.quizType == QuizType.multipleChoice) {
                  final correctIndex =
                      _questions[_currentQuestionIndex]['correctIndex'] as int;
                  _audiencePollPercentages =
                      _generateAudiencePollData(correctIndex);
                  _pollQuestionIndex =
                      _currentQuestionIndex; // Store the current question index

                  // Show audience poll bottom sheet
                  _showAudiencePollResults();
                }
              });
            }
          });
        }
        break;
      case 'time':
        if (_hasTimeLifeline) {
          QuizDialogs.showPowerUpConfirmation(
            context,
            powerUpName: 'Extra Time',
            coinCost: 30,
          ).then((bool confirmed) {
            if (confirmed) {
              setState(() {
                _hasTimeLifeline = false;
                _timeLeft += 30; // Increase by 30 seconds instead of 10
              });
            }
          });
        }
        break;
      case 'bomb':
        if (_hasBombLifeline && widget.quizType == QuizType.multipleChoice) {
          QuizDialogs.showPowerUpConfirmation(
            context,
            powerUpName: 'Bomb (Remove 2 Wrong Options)',
            coinCost: 40,
          ).then((bool confirmed) {
            if (confirmed) {
              setState(() {
                _hasBombLifeline = false;
                // Remove two wrong answers
                _removedOptions = _removeTwoWrongOptions();
                _bombQuestionIndex =
                    _currentQuestionIndex; // Store the current question index
              });
            }
          });
        }
        break;
      case 'skip':
        if (_hasSkipLifeline) {
          QuizDialogs.showPowerUpConfirmation(
            context,
            powerUpName: 'Skip Question',
            coinCost: 60,
          ).then((bool confirmed) {
            if (confirmed) {
              setState(() {
                _hasSkipLifeline = false;
              });
              _goToNextQuestion();
            }
          });
        }
        break;
    }
  }

  // Generate audience poll data with higher percentage for correct answer
  List<int> _generateAudiencePollData(int correctIndex) {
    // Create a list to hold percentages for each option
    final optionsCount =
        (_questions[_currentQuestionIndex]['options'] as List<dynamic>).length;
    List<int> percentages = List.filled(optionsCount, 0);

    // Assign a high percentage (40-70%) to the correct answer
    percentages[correctIndex] = 40 + (DateTime.now().millisecond % 30);

    // Distribute remaining percentage among other options
    int remainingPercentage = 100 - percentages[correctIndex];
    for (int i = 0; i < optionsCount; i++) {
      if (i != correctIndex) {
        // Assign a random percentage from the remaining pool
        int randomPercent = remainingPercentage ~/ (optionsCount - 1);
        // Add some randomness (±5%)
        randomPercent += (DateTime.now().microsecond % 10) - 5;
        randomPercent = randomPercent.clamp(5, remainingPercentage);
        percentages[i] = randomPercent;
        remainingPercentage -= randomPercent;
      }
    }

    // Assign any remaining percentage to the last wrong option
    for (int i = 0; i < optionsCount; i++) {
      if (i != correctIndex && remainingPercentage > 0) {
        percentages[i] += remainingPercentage;
        break;
      }
    }

    return percentages;
  }

  // Show audience poll results in a bottom sheet
  void _showAudiencePollResults() {
    if (_audiencePollPercentages == null) return;

    // Show a custom bottom sheet with poll results
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Audience Poll Results',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(_audiencePollPercentages!.length, (index) {
                final options = _questions[_currentQuestionIndex]['options']
                    as List<String>;
                final percentage = _audiencePollPercentages![index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Text(
                        '${String.fromCharCode(65 + index)}:',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              options[index],
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Stack(
                              children: [
                                Container(
                                  height: 16,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: percentage / 100.0,
                                  child: Container(
                                    height: 16,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF8F7AE8),
                                          Color(0xFF9D8AE6)
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$percentage%',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF4A44A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Got it'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Remove two wrong options for bomb lifeline
  List<int> _removeTwoWrongOptions() {
    final correctIndex =
        _questions[_currentQuestionIndex]['correctIndex'] as int;
    final optionsCount =
        (_questions[_currentQuestionIndex]['options'] as List<dynamic>).length;

    // Create a list of wrong option indices
    List<int> wrongIndices = [];
    for (int i = 0; i < optionsCount; i++) {
      if (i != correctIndex) {
        wrongIndices.add(i);
      }
    }

    // Shuffle the wrong indices and take 2 (or less if not enough wrong answers)
    wrongIndices.shuffle();
    return wrongIndices.take(2).toList();
  }

  void _reportCurrentQuestion() {
    if (_answerState != AnswerState.unanswered) return;

    QuizDialogs.showReportQuestionDialog(context).then((String? reason) {
      if (reason != null && reason.isNotEmpty) {
        // Show a confirmation that the question was reported
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Question reported: $reason'),
            duration: const Duration(seconds: 2),
          ),
        );

        // In a real app, you would send this to the backend
        // reportQuestionToBackend(
        //   questionId: _currentQuestionIndex,
        //   reason: reason,
        //   category: widget.categoryName,
        // );
      }
    });
  }

  void _showHint() {
    if (_answerState != AnswerState.unanswered) return;

    // Only proceed if we're in word guess mode
    if (widget.quizType != QuizType.wordGuess) return;

    // Check if user has already used maximum hints
    if (_hintsUsed >= 4) {
      // Show message that no more hints are available
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have used all available hints for this question'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final String answer =
        _wordGuessQuestions[_currentQuestionIndex]['answer'] as String;
    final keyboard =
        _wordGuessQuestions[_currentQuestionIndex]['keyboard'] as List<String>;

    // Don't provide hint if word is already complete
    if (_enteredWord.length >= answer.length) return;

    // Find the next correct letter that should be added
    final int nextPosition = _enteredWord.length;
    final String nextLetter = answer[nextPosition];

    // Find this letter in the keyboard
    List<int> letterKeyboardIndices = [];

    // First check the first row
    for (int i = 0; i < 7 && i < keyboard.length; i++) {
      if (keyboard[i] == nextLetter) {
        letterKeyboardIndices.add(i);
      }
    }

    // Also check the second row
    for (int i = 7; i < keyboard.length; i++) {
      if (keyboard[i] == nextLetter) {
        letterKeyboardIndices.add(i);
      }
    }

    // Get the first available (not already selected) index
    int? letterKeyboardIndex;
    for (int idx in letterKeyboardIndices) {
      final String letterKey = '$nextLetter-$idx';
      if (!_lettersSelected.contains(letterKey)) {
        letterKeyboardIndex = idx;
        break;
      }
    }

    // If we found an available instance of the letter in the keyboard, select it
    if (letterKeyboardIndex != null) {
      _selectLetter(nextLetter, letterKeyboardIndex);

      // Increment hints used counter (with safety check)
      setState(() {
        if (_hintsUsed < 4) {
          _hintsUsed++;
        }
      });

      // Show a toast
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hint $_hintsUsed/4: Letter "$nextLetter" added'),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      // If all instances are already selected, show a helpful message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Letter "$nextLetter" is already selected'),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _lifelineAnimController.dispose();
    _correctSoundPlayer.dispose();
    _wrongSoundPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show the quit confirmation dialog
        final bool shouldResume =
            await QuizDialogs.showQuitConfirmationDialog(context);

        if (shouldResume) {
          // User wants to continue the quiz
          return false;
        } else {
          // User wants to quit
          _timer.cancel();
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SafeArea(
          child: Column(
            children: [
              _buildQuizHeader(),
              Expanded(
                child: SingleChildScrollView(
                  child: widget.quizType == QuizType.multipleChoice
                      ? _buildMultipleChoiceContent()
                      : _buildWordGuessContent(),
                ),
              ),
              _buildLifelines(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizHeader() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  // Show the quit confirmation dialog when back button is tapped
                  final bool shouldResume =
                      await QuizDialogs.showQuitConfirmationDialog(context);

                  if (shouldResume) {
                    // User wants to continue the quiz
                    return;
                  } else {
                    // User wants to quit
                    _timer.cancel();
                    Navigator.pop(context);
                  }
                },
                child: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 16),
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
                      // Progress bar
                      FractionallySizedBox(
                        widthFactor: (widget.quizType == QuizType.multipleChoice
                            ? (_currentQuestionIndex + 1) / _questions.length
                            : (_currentQuestionIndex + 1) /
                                _wordGuessQuestions.length),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFF4A44A), Color(0xFFEF9A38)],
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      // Question count
                      Center(
                        child: Text(
                          "${_currentQuestionIndex + 1}/${widget.quizType == QuizType.multipleChoice ? _questions.length : _wordGuessQuestions.length}",
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: _reportCurrentQuestion,
                child: const Icon(Icons.flag_outlined),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMultipleChoiceContent() {
    final currentQuestion = _questions[_currentQuestionIndex];
    final options = currentQuestion['options'] as List<String>;

    String feedbackText = '';
    if (_answerState == AnswerState.correct) {
      feedbackText = 'Yeah!';
    } else if (_answerState == AnswerState.incorrect) {
      feedbackText = 'Uhh!';
    } else if (_answerState == AnswerState.timeUp) {
      feedbackText = 'Oops\nTime Out!';
    }

    // Check if poll should be shown for this question
    final bool shouldShowPoll = _pollQuestionIndex == _currentQuestionIndex &&
        _audiencePollPercentages != null;

    // Check if bomb should be applied for this question
    final bool shouldApplyBomb =
        _bombQuestionIndex == _currentQuestionIndex && _removedOptions != null;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Question
          Container(
            width: double.infinity,
            height: 300, // Fixed height to prevent fluctuation
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F4F8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                _answerState == AnswerState.unanswered
                    ? currentQuestion['question'] as String
                    : feedbackText,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Timer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.timer, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                '$_timeLeft',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _timeLeft > 5 ? Colors.black87 : Colors.red,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Options
          ...List.generate(
            options.length,
            (index) {
              Color backgroundColor = Colors.white;
              Color borderColor = Colors.grey;
              IconData? icon;

              // Check if this option is removed by the bomb lifeline
              bool isRemovedByBomb =
                  shouldApplyBomb && _removedOptions!.contains(index);

              // Styling based on answer state
              if (_answerState != AnswerState.unanswered) {
                final correctIndex = currentQuestion['correctIndex'] as int;

                if (index == correctIndex) {
                  backgroundColor = const Color(0xFFE0F4E0);
                  borderColor = Colors.green;
                  icon = Icons.check;
                } else if (index == _selectedAnswerIndex) {
                  backgroundColor = const Color(0xFFFADDDD);
                  borderColor = Colors.red;
                  icon = Icons.close;
                }
              } else {
                // When question is unanswered but option is selected
                if (index == _selectedAnswerIndex) {
                  backgroundColor =
                      const Color(0xFFE0D9FF); // Light purple for selection
                  borderColor =
                      const Color(0xFF9D8AE6); // Darker purple for border
                }

                // If this option was removed by bomb lifeline
                if (isRemovedByBomb) {
                  backgroundColor = Colors.grey.shade200;
                  borderColor = Colors.grey.shade400;
                }
              }

              // Build audience poll indicator if poll lifeline was used
              Widget? pollIndicator;
              if (shouldShowPoll && _answerState == AnswerState.unanswered) {
                final percentage = _audiencePollPercentages![index];
                pollIndicator = Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 26,
                      decoration: BoxDecoration(
                        color: Colors.purple.shade100,
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(color: Colors.purple.shade300),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$percentage%',
                        style: TextStyle(
                          color: Colors.purple.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                );
              }

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: (_answerState == AnswerState.unanswered &&
                            !isRemovedByBomb)
                        ? () => _selectOption(index)
                        : null,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (isRemovedByBomb)
                            const Expanded(
                              child: Text(
                                '-- Option Removed --',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            )
                          else
                            Expanded(
                              child: Text(
                                options[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: isRemovedByBomb ? Colors.grey : null,
                                ),
                              ),
                            ),
                          if (icon != null)
                            Icon(
                              icon,
                              color: icon == Icons.check
                                  ? Colors.green
                                  : Colors.red,
                            )
                          else if (pollIndicator != null)
                            pollIndicator,
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // Submit button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _answerState == AnswerState.unanswered &&
                      _selectedAnswerIndex != null
                  ? () => _submitAnswer()
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF4A44A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordGuessContent() {
    final currentQuestion = _wordGuessQuestions[_currentQuestionIndex];
    final String answer = currentQuestion['answer'] as String;
    final keyboard = currentQuestion['keyboard'] as List<String>;
    final isTablet = MediaQuery.of(context).size.width > 600;

    // Configure feedback when showing answer states
    String feedbackText = '';
    if (_answerState == AnswerState.correct) {
      feedbackText = 'Great!';
    } else if (_answerState == AnswerState.incorrect) {
      feedbackText = 'Incorrect!';
    } else if (_answerState == AnswerState.timeUp) {
      feedbackText = 'Time Out!';
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question
          Container(
            width: double.infinity,
            height: 150, // Fixed height to prevent fluctuation
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F4F8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                currentQuestion['question'] as String,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Image
          if (currentQuestion.containsKey('image'))
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                currentQuestion['image'] as String,
                height: isTablet ? 240 : 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

          const SizedBox(height: 20),

          // Timer
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '$_timeLeft',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _timeLeft > 5 ? Colors.black87 : Colors.red,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Word slots - displayed as a row of letter slots with underlines
          // Including slots that are already filled
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              answer.length,
              (index) {
                bool hasLetter = index < _enteredWord.length;

                // Only display letters that have been entered by the user
                Color letterColor = Colors.black;
                Color underlineColor = Colors.black;
                String displayLetter = '';

                if (hasLetter) {
                  displayLetter = _enteredWord[index];
                }

                return Container(
                  width: 30,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      Text(
                        displayLetter,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: letterColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 2,
                        color: underlineColor,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 40),

          // Keyboard - two rows of letters
          Center(
            child: Column(
              children: [
                // First row - replaced Row with Wrap
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8, // horizontal spacing
                  runSpacing: 8, // vertical spacing
                  children:
                      List.generate(keyboard.sublist(0, 7).length, (index) {
                    String letter = keyboard.sublist(0, 7)[index];
                    int letterIndex =
                        index; // Use index directly to ensure unique identification
                    bool isSelected =
                        _lettersSelected.contains('$letter-$letterIndex');

                    return Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.grey.shade300
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 1,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: (isSelected ||
                                  _answerState != AnswerState.unanswered)
                              ? null
                              : () => _selectLetter(letter, letterIndex),
                          child: Center(
                            child: Text(
                              letter,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.grey.shade500
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 8),

                // Second row - replaced Row with Wrap
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8, // horizontal spacing
                  runSpacing: 8, // vertical spacing
                  children: List.generate(keyboard.sublist(7).length, (index) {
                    String letter = keyboard.sublist(7)[index];
                    if (letter == '_') {
                      return const SizedBox(width: 40, height: 40);
                    }

                    int letterIndex = 7 +
                        index; // Use absolute index to ensure unique identification
                    bool isSelected =
                        _lettersSelected.contains('$letter-$letterIndex');
                    return Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.grey.shade300
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 1,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: (isSelected ||
                                  _answerState != AnswerState.unanswered)
                              ? null
                              : () => _selectLetter(letter, letterIndex),
                          child: Center(
                            child: Text(
                              letter,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.grey.shade500
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed:
                    (_answerState == AnswerState.unanswered && _hintsUsed < 4)
                        ? () => _showHint()
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: _hintsUsed >= 4 ? Colors.grey : Colors.black,
                  minimumSize: const Size(120, 44),
                ),
                child: Text(
                  _hintsUsed >= 4 ? 'No Hints Left' : 'Hint ($_hintsUsed/4)',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _answerState == AnswerState.unanswered
                    ? () => _removeLetter()
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(120, 44),
                ),
                child: const Text(
                  'Back',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Submit button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _answerState == AnswerState.unanswered &&
                      _enteredWord.length == answer.length
                  ? () => _checkWordGuess()
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF4A44A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLifelines() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildLifelineButton(
              'Bomb', Icons.local_fire_department, _hasBombLifeline, 'bomb'),
          _buildLifelineButton('Poll', Icons.poll, _hasPollLifeline, 'poll'),
          _buildLifelineButton(
              'Add time', Icons.access_time, _hasTimeLifeline, 'time'),
          _buildLifelineButton(
              'Skip', Icons.fast_forward, _hasSkipLifeline, 'skip'),
        ],
      ),
    );
  }

  Widget _buildLifelineButton(
      String label, IconData icon, bool isAvailable, String type) {
    final bool isActive = _activeLifeline == type;

    return GestureDetector(
      onTap: () {
        if (_answerState != AnswerState.unanswered) {
          // Show toast for attempting to use lifeline when question is already answered
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cannot use lifeline after answering!'),
              duration: Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(bottom: 70, left: 20, right: 20),
            ),
          );
        } else if (!isAvailable) {
          // Show toast for already used lifeline
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$label already used!'),
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.only(bottom: 70, left: 20, right: 20),
            ),
          );
        } else {
          _useLifeline(type);
        }
      },
      child: AnimatedBuilder(
        animation: _lifelineAnimController,
        builder: (context, child) {
          return Transform.scale(
            scale: isActive ? 1.0 + (_lifelineAnimController.value * 0.2) : 1.0,
            child: Opacity(
              opacity: isAvailable ? 1.0 : 0.5,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isActive
                      ? Color.lerp(const Color(0xFF9D8AE6), Colors.white,
                          _lifelineAnimController.value)
                      : isAvailable
                          ? const Color(0xFF9D8AE6)
                          : Colors
                              .grey, // Changed to plain grey when unavailable
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: const Color(0xFF9D8AE6).withOpacity(0.5),
                            blurRadius: 10 * _lifelineAnimController.value,
                            spreadRadius: 5 * _lifelineAnimController.value,
                          )
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.white, size: 24),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
