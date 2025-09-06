import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:myapp/common/enum/enum.dart';
import '../../controller/quiz_answer_controller.dart';
import '../../controller/quiz_question_controller.dart';
import '../../model/quiz_question_model.dart';
import '../../widgets/multiple_choice_content.dart';
import '../../widgets/quiz_header.dart';
import '../../widgets/lifeline_buttons.dart';
import '../../widgets/word_guess_screen.dart';
import 'quiz_result_screen.dart';

class QuizQuestionScreen extends StatefulWidget {
  final String levelId;
  final String type;
  final int level;
  final QuizType quizType;

  const QuizQuestionScreen({
    super.key,
    required this.type,
    required this.level,
    required this.levelId,
    this.quizType = QuizType.multipleChoice,
  });

  @override
  State<QuizQuestionScreen> createState() => _QuizQuestionScreenState();
}

class _QuizQuestionScreenState extends State<QuizQuestionScreen> {
  final QuizQuestionController _controller = Get.put(QuizQuestionController());
  final QuizAnswerController _answerController = Get.put(QuizAnswerController());

  int _currentQuestionIndex = 0;
  late int _timeLeft = 10;
  int _score = 0;
  int? _selectedAnswerIndex;
  AnswerState _answerState = AnswerState.unanswered;
  Timer? _timer;
  int _lastPlayedSecond = -1;
  bool _skipUsed = false;
  bool _pollUsed = false;
  bool _timeUsed = false;
  bool _bombUsed = false;
  List<int> _removedOptions = [];

  final AudioPlayer _correctSoundPlayer = AudioPlayer();
  final AudioPlayer _wrongSoundPlayer = AudioPlayer();
  final AudioPlayer _timeCountSoundPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initializeQuiz();
    _initAudio();
  }

  Future<void> _initializeQuiz() async {
    setState(() async {
      await _controller.fetchQuizQuestionApi(widget.levelId, widget.type).then((v){
        _timeLeft = _controller.quizLevelDataList.value.quesDuration ?? 15;
      });
      _startTimer();
    });
  }

  QuizQuestionData get currentQuestion => _controller.quizQuestionDataList[_currentQuestionIndex];

  List<String> get currentOptions => widget.quizType == QuizType.trueFalse
      ? [currentQuestion.optionA ?? "", currentQuestion.optionB ?? ""]
      : [
          currentQuestion.optionA ?? "",
          currentQuestion.optionB ?? "",
          currentQuestion.optionC ?? "",
          currentQuestion.optionD ?? "",
        ];

  Future<void> _initAudio() async {
    await _correctSoundPlayer.setAsset('assets/audio/quiz/correct-choice-43861.mp3');
    await _wrongSoundPlayer.setAsset('assets/audio/quiz/wronganswer-37702.mp3');
    await _timeCountSoundPlayer.setAsset('assets/audio/time_count.mp3');
    _timeCountSoundPlayer.setLoopMode(LoopMode.one);
  }

  void _startTimer() {
    _timer?.cancel();
    _lastPlayedSecond = -1;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);

        if (_timeLeft <= 5 && _timeLeft >= 1 && _answerState == AnswerState.unanswered) {
          if (_lastPlayedSecond != _timeLeft) {
            _lastPlayedSecond = _timeLeft;
            _playTimeCountSound();
          }
        }
      } else {
        _stopTimeCountSound();
        _submitAnswer();
      }
    });
  }

  void _playTimeCountSound() async {
    try {
      await _timeCountSoundPlayer.seek(Duration.zero);
      await _timeCountSoundPlayer.play();
    } catch (e) {
      print('Error playing time count sound: $e');
    }
  }

  void _stopTimeCountSound() async {
    try {
      await _timeCountSoundPlayer.stop();
      _lastPlayedSecond = -1;
    } catch (e) {
      print('Error stopping time count sound: $e');
    }
  }

  void _checkAnswer(int index) {
    if (_answerState != AnswerState.unanswered) return;
    if (_removedOptions.contains(index)) return; // Can't select removed option

    _timer?.cancel();
    _stopTimeCountSound();

    final correctIndex = _controller.getCorrectAnswerIndex(currentQuestion);
    final answerLetter = ["A", "B", "C", "D"][index];

    _answerController.fetchQuizAnswerApi(
        currentQuestion.id ?? "", widget.levelId, widget.type, answerLetter);

    setState(() {
      _selectedAnswerIndex = index;
      if (index == correctIndex) {
        _answerState = AnswerState.correct;
        _score++;
        _playSound(true);
      } else {
        _answerState = AnswerState.incorrect;
        _playSound(false);
      }
    });

    Future.delayed(const Duration(seconds: 2), _goToNextQuestion);
  }

  void _submitAnswer() {
    if (_answerState != AnswerState.unanswered) return;
    _timer?.cancel();
    _stopTimeCountSound();

    _answerController.fetchQuizAnswerApi(
        currentQuestion.id ?? "", widget.levelId, widget.type, "NA");

    setState(() => _answerState = AnswerState.timeUp);
    _playSound(false);

    Future.delayed(const Duration(seconds: 2), _goToNextQuestion);
  }

  void _playSound(bool correct) {
    if (correct) {
      _correctSoundPlayer.seek(Duration.zero);
      _correctSoundPlayer.play();
    } else {
      _wrongSoundPlayer.seek(Duration.zero);
      _wrongSoundPlayer.play();
    }
  }

  void _goToNextQuestion() {
    _stopTimeCountSound();

    if (_currentQuestionIndex < _controller.quizQuestionDataList.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
        _answerState = AnswerState.unanswered;
        _timeLeft = _controller.quizLevelDataList.value.quesDuration ?? 10;
        _lastPlayedSecond = -1;
        _removedOptions = []; // Reset removed options for next question
      });
      _startTimer();
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    _stopTimeCountSound();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => QuizResultPage(
        type: widget.type,
        level: widget.level,
        correctAnswers: _score,
        totalQuestions: _controller.quizQuestionDataList.length,
        onPlayAgain: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) => QuizQuestionScreen(
                type: widget.type,
                level: widget.level,
                levelId: widget.levelId,
                quizType: widget.quizType,
              )));
        },
        onHome: () => Navigator.of(context).pop(),
      ),
    ));
  }

  void _handleWordGuessResult(bool isCorrect) {
    _timer?.cancel();
    _stopTimeCountSound();

    _answerController.fetchQuizAnswerApi(
        currentQuestion.id ?? "", widget.levelId, widget.type, currentQuestion.answer ?? "");

    setState(() {
      if (isCorrect) {
        _score++;
        _playSound(true);
        _answerState = AnswerState.correct;
      } else {
        _playSound(false);
        _answerState = AnswerState.incorrect;
      }
    });

    Future.delayed(const Duration(seconds: 2), _goToNextQuestion);
  }

  void _skipQuestion() {
    if (_skipUsed) return;

    _timer?.cancel();
    _stopTimeCountSound();

    _answerController.fetchQuizAnswerApi(
        currentQuestion.id ?? "", widget.levelId, widget.type, "SKIP");

    setState(() {
      _skipUsed = true;
      _answerState = AnswerState.unanswered;
      _selectedAnswerIndex = null;
    });

    _goToNextQuestion();
  }

  void _usePollLifeline() {
    if (_pollUsed) return;

    setState(() {
      _pollUsed = true;
    });

    // Show audience poll results
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final correctIndex = _controller.getCorrectAnswerIndex(currentQuestion);
        // Simulate audience poll results (70% chance for correct answer)
        final correctPercentage = 70 + Random().nextInt(20); // 70-90%

        // Calculate percentages for other options based on the number of options
        final otherOptionsCount = currentOptions.length - 1;
        final otherPercentages = List.generate(otherOptionsCount, (index) => Random().nextInt(30));
        final totalOther = otherPercentages.reduce((a, b) => a + b);
        final scaledOther = otherPercentages.map((p) => (p * (100 - correctPercentage) / totalOther).round()).toList();

        return AlertDialog(
          title: Text('Audience Poll'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('The audience votes:'),
              SizedBox(height: 16),
              for (int i = 0; i < currentOptions.length; i++)
                _buildPollResult(
                    String.fromCharCode(65 + i), // A, B, C, D
                    i == correctIndex ? correctPercentage : scaledOther[i < correctIndex ? i : i - 1]
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPollResult(String option, int percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$option: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          SizedBox(width: 8),
          Text('$percentage%'),
        ],
      ),
    );
  }

  void _useTimeLifeline() {
    if (_timeUsed) return;

    setState(() {
      _timeUsed = true;
      _timeLeft += 15; // Add 15 seconds
    });
  }

  void _useBombLifeline() {
    if (_bombUsed) return;
    if (_removedOptions.isNotEmpty) return;

    final correctIndex = _controller.getCorrectAnswerIndex(currentQuestion);
    List<int> wrongOptions = [];

    for (int i = 0; i < currentOptions.length; i++) {
      if (i != correctIndex) {
        wrongOptions.add(i);
      }
    }

    // Shuffle and take 2 wrong options
    wrongOptions.shuffle();
    setState(() {
      _bombUsed = true;
      _removedOptions = wrongOptions.take(2).toList();
    });
  }

  void _showPurchaseDialog(String lifelineType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Lifeline Locked'),
          content: Text('You have already used this lifeline. Would you like to purchase more?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No Thanks'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Implement purchase logic here
                _purchaseLifeline(lifelineType);
              },
              child: Text('Purchase'),
            ),
          ],
        );
      },
    );
  }

  void _purchaseLifeline(String lifelineType) {
    // Implement your purchase logic here
    // This is just a placeholder
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Purchase Lifeline'),
          content: Text('Purchase functionality would be implemented here.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _correctSoundPlayer.dispose();
    _wrongSoundPlayer.dispose();
    _timeCountSoundPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.quizQuestionDataList.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            QuizHeader(
              controller: _controller,
              currentIndex: _currentQuestionIndex,
              level: widget.level,
              timeLeft: _timeLeft,
              onQuit: () => Navigator.pop(context),
              onReport: () {},
            ),
            Expanded(
              child: SingleChildScrollView(
                child: widget.quizType == QuizType.wordGuess
                    ? WordGuessScreen(
                        currentQuestion: currentQuestion,
                        onResult: _handleWordGuessResult,
                        answerState: _answerState,
                      )
                    : MultipleChoiceContent(
                        currentQuestion: currentQuestion,
                        currentOptions: currentOptions,
                        removedOptions: _removedOptions,
                        selectedAnswerIndex: _selectedAnswerIndex,
                        answerState: _answerState,
                        onTapOption: _checkAnswer,
                        quizType: widget.quizType,
                    ),
                  ),
                ),
            if (widget.quizType != QuizType.trueFalse &&
                widget.quizType != QuizType.wordGuess)
              LifeLineButtons(
                hasPoll: !_pollUsed,
                hasTime: !_timeUsed,
                hasBomb: !_bombUsed,
                hasSkip: !_skipUsed,
                onUseLifeline: (type) {
                  if (type == 'skip' && !_skipUsed) {
                    _skipQuestion();
                  } else if (type == 'poll' && !_pollUsed) {
                    _usePollLifeline();
                  } else if (type == 'time' && !_timeUsed) {
                    _useTimeLifeline();
                  } else if (type == 'bomb' && !_bombUsed) {
                    _useBombLifeline();
                  } else {
                    // Show purchase dialog for used lifelines
                    _showPurchaseDialog(type);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}