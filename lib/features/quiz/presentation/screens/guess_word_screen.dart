import 'dart:math';

import 'package:flutter/material.dart';

class GuessWordScreen extends StatefulWidget {
  const GuessWordScreen({super.key});

  @override
  State<GuessWordScreen> createState() => _GuessWordScreenState();
}

class _GuessWordScreenState extends State<GuessWordScreen> {
  late String _currentWord;
  late List<String> _displayWord;
  late List<String> _usedLetters;
  int _wrongGuesses = 0;
  final int _maxWrongGuesses = 6;
  bool _isGameOver = false;
  bool _isWinner = false;

  final List<String> _words = [
    'FLUTTER',
    'DEVELOPER',
    'MOBILE',
    'APPLICATION',
    'WIDGET',
    'MATERIAL',
    'DESIGN',
    'CODING',
    'SOFTWARE',
    'PROGRAMMING',
    'INTERFACE',
    'NAVIGATION',
  ];

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    final random = Random();
    _currentWord = _words[random.nextInt(_words.length)];
    _displayWord = List.filled(_currentWord.length, '_');
    _usedLetters = [];
    _wrongGuesses = 0;
    _isGameOver = false;
    _isWinner = false;
  }

  void _guessLetter(String letter) {
    if (_isGameOver || _usedLetters.contains(letter)) {
      return;
    }

    setState(() {
      _usedLetters.add(letter);

      if (_currentWord.contains(letter)) {
        // Correct guess - reveal the letter
        for (int i = 0; i < _currentWord.length; i++) {
          if (_currentWord[i] == letter) {
            _displayWord[i] = letter;
          }
        }

        // Check if the word is complete
        if (!_displayWord.contains('_')) {
          _isGameOver = true;
          _isWinner = true;
        }
      } else {
        // Wrong guess
        _wrongGuesses++;

        if (_wrongGuesses >= _maxWrongGuesses) {
          _isGameOver = true;
          _isWinner = false;
        }
      }
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_isWinner ? 'Congratulations!' : 'Game Over'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isWinner
                    ? 'You guessed the word: $_currentWord'
                    : 'The word was: $_currentWord',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _isWinner ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _isWinner
                    ? 'Great job! You guessed the word with $_wrongGuesses wrong guesses.'
                    : 'Better luck next time!',
                textAlign: TextAlign.center,
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
                  _startNewGame();
                });
              },
              child: const Text('Play Again'),
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
        title: const Text('Guess The Word'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Hangman progress visualization
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: LinearProgressIndicator(
                value: _wrongGuesses / _maxWrongGuesses,
                backgroundColor: Colors.blue.shade100,
                color: _wrongGuesses < _maxWrongGuesses * 0.6
                    ? Colors.blue
                    : _wrongGuesses < _maxWrongGuesses * 0.8
                        ? Colors.orange
                        : Colors.red,
              ),
            ),
            Text(
              'Wrong Guesses: $_wrongGuesses/$_maxWrongGuesses',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            // Word display
            Expanded(
              flex: 2,
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: _displayWord.map((letter) {
                    return Container(
                      width: 36,
                      height: 48,
                      decoration: BoxDecoration(
                        color: letter == '_'
                            ? Colors.blue.shade50
                            : Colors.blue.shade200,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.blue.shade600),
                      ),
                      child: Center(
                        child: Text(
                          letter,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Game status
            if (_isGameOver)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () => _showGameOverDialog(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isWinner ? Colors.green : Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                  child: Text(
                    _isWinner ? 'You Win!' : 'Game Over',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),

            // Keyboard
            Expanded(
              flex: 3,
              child: Center(
                child: _buildKeyboard(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyboard() {
    const letters = [
      ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
      ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
      ['Z', 'X', 'C', 'V', 'B', 'N', 'M'],
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: letters.map((row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((letter) {
              final isUsed = _usedLetters.contains(letter);
              final isCorrect = _currentWord.contains(letter) && isUsed;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: SizedBox(
                  width: 33,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: isUsed || _isGameOver
                        ? null
                        : () => _guessLetter(letter),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isUsed
                          ? (isCorrect
                              ? Colors.green.shade200
                              : Colors.red.shade200)
                          : Colors.white,
                      foregroundColor: isUsed ? Colors.white : Colors.blue,
                      disabledBackgroundColor: isCorrect
                          ? Colors.green.shade200
                          : Colors.red.shade200,
                      disabledForegroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(
                      letter,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
