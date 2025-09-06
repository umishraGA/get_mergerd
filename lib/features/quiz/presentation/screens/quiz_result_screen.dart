import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

class QuizResultScreen extends StatefulWidget {
  final String categoryName;
  final int level;
  final int correctAnswers;
  final int totalQuestions;
  final String playerName;
  final VoidCallback onPlayAgain;
  final VoidCallback onHome;
  final VoidCallback? onNextLevel;

  const QuizResultScreen({
    super.key,
    required this.categoryName,
    required this.level,
    required this.correctAnswers,
    required this.totalQuestions,
    this.playerName = 'Sanjay',
    required this.onPlayAgain,
    required this.onHome,
    this.onNextLevel,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  final AudioPlayer _correctSoundPlayer = AudioPlayer();
  final AudioPlayer _wrongSoundPlayer = AudioPlayer();
  late ConfettiController _confettiController;

  bool get isWin => widget.correctAnswers >= (widget.totalQuestions / 2).ceil();

  @override
  void initState() {
    super.initState();
    _initAudio();

    // Initialize confetti controller
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));

    // Start animations based on result
    if (isWin) {
      _confettiController.play();
    }
  }

  Future<void> _initAudio() async {
    try {
      await _correctSoundPlayer
          .setAsset('assets/audio/quiz/correct-choice-43861.mp3');
      await _wrongSoundPlayer
          .setAsset('assets/audio/quiz/wronganswer-37702.mp3');

      // Play sound based on result
      _playResultSound();
    } catch (e) {
      debugPrint('Error initializing result audio: $e');
    }
  }

  void _playResultSound() {
    // Play haptic feedback based on result
    if (isWin) {
      HapticFeedback.mediumImpact();
      _correctSoundPlayer.play();
    } else {
      HapticFeedback.heavyImpact();
      _wrongSoundPlayer.play();
    }
  }

  @override
  void dispose() {
    _correctSoundPlayer.dispose();
    _wrongSoundPlayer.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          isWin ? const Color(0xFF4CAF50) : const Color(0xFFE74C3C),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        48, // Account for padding
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 16),

                      // Title and name
                      Text(
                        isWin ? 'Well Done !' : 'Good Effort !',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      Text(
                        widget.playerName,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFC107),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Subtitle text
                      if (!isWin)
                        const Text(
                          'Keep learning and trying again!',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),

                      const SizedBox(height: 24),

                      // Trophy or broken trophy image with animation
                      isWin
                          ? Image.asset(
                              'assets/images/quiz/trophy.png',
                              height: 150,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.emoji_events,
                                  size: 150,
                                  color: Color(0xFFFFC107),
                                );
                              },
                            )
                          : Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/quiz/broken_trophy.png',
                                  height: 150,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.broken_image,
                                      size: 150,
                                      color: Colors.white.withOpacity(0.8),
                                    );
                                  },
                                ),
                                // Lottie animation for loss
                                // SizedBox(
                                //   height: 200,
                                //   width: 200,
                                //   child: Lottie.asset(
                                //     'assets/images/quiz/loss_animation.json',
                                //     repeat: true,
                                //     errorBuilder: (context, error, stackTrace) {
                                //       return const Icon(
                                //         Icons.thumb_down,
                                //         color: Colors.white,
                                //         size: 60,
                                //       );
                                //     },
                                //   ),
                                // ),
                              ],
                            ),

                      const SizedBox(height: 24),

                      // Score badges
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${widget.totalQuestions - widget.correctAnswers}/${widget.totalQuestions}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 40),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${widget.correctAnswers}/${widget.totalQuestions}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Status text
                      if (isWin)
                        Column(
                          children: [
                            Text(
                              'Level ${widget.level}',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              'Completed',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      else
                        const Text(
                          'Not quite there yet, but don\'t give up!\nTry again and see if you can improve\nyour score!',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),

                      const SizedBox(height: 16),

                      Text(
                        'Level ${widget.level} of ${widget.categoryName} quiz',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      // Action buttons
                      isWin && widget.onNextLevel != null
                          ? ElevatedButton(
                              onPressed: widget.onNextLevel,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 56),
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Next Level',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: widget.onPlayAgain,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 56),
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Play Again',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                      const SizedBox(height: 16),

                      // Home button
                      ElevatedButton(
                        onPressed: widget.onHome,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Home',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Confetti animation for win
          if (isWin)
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                particleDrag: 0.05,
                emissionFrequency: 0.05,
                numberOfParticles: 20,
                gravity: 0.1,
                shouldLoop: false,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                  Colors.yellow,
                ],
              ),
            ),
        ],
      ),
    );
  }
}
