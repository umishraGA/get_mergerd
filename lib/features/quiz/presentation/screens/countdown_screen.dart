import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

class CountdownScreen extends StatefulWidget {
  final String type;
  final int level;
  final VoidCallback onCountdownComplete;

  const CountdownScreen({
    super.key,
    required this.type,
    required this.level,
    required this.onCountdownComplete,
  });

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen>
    with SingleTickerProviderStateMixin {
  // Start countdown from 3
  int _displayNumber = 3;
  final int _elapsedSeconds = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final AudioPlayer _tickSoundPlayer = AudioPlayer();
  bool _isAudioReady = false;
  bool _isAnimating = false;
  bool _countdownStarted = false;

  // Timers for cleanup
  final List<Timer> _timers = [];

  @override
  void initState() {
    super.initState();

    // Initialize animation with longer duration for more visibility
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = Tween<double>(begin: 1.0, end: 3.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          setState(() {
            _isAnimating = false;
          });
        }
      });

    // Initialize audio and start countdown sequence with initial delay
    _initializeAndStart();
  }

  Future<void> _initializeAndStart() async {
    // Initialize audio
    await _initAudio();
    setState(() {
      _isAudioReady = true;
    });

    // _triggerSoundAndAnimation();
    _playTickSound();

    // Add initial delay of 1 second before starting the countdown
    _timers.add(Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _countdownStarted = true;
          _displayNumber = 3;
        });

        // First beep at 1 second with number "3"
        _triggerSoundAndAnimation();
        // Schedule remaining beeps
        _scheduleRemainingBeeps();
      }
    }));
  }

  Future<void> _initAudio() async {
    try {
      // Load the sound file
      await _tickSoundPlayer
          .setAsset('assets/audio/quiz/countdown-beep-104007.mp3');
      // Set volume to maximum
      await _tickSoundPlayer.setVolume(1.0);
    } catch (e) {
      debugPrint('Error initializing countdown audio: $e');
    }
  }

  void _scheduleRemainingBeeps() {
    // Second beep at 3 seconds (1+2) with number "2"
    _timers.add(Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _displayNumber = 2;
        });
        _triggerSoundAndAnimation();
      }
    }));

    _timers.add(Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _displayNumber = 1;
        });
        _triggerSoundAndAnimation();
      }
    }));

    // Complete the countdown at 7 seconds (1+6)
    _timers.add(Timer(const Duration(seconds: 5), () {
      if (mounted) {
        widget.onCountdownComplete();
      }
    }));
  }

  void _triggerSoundAndAnimation() {
    // _playTickSound();
    setState(() {
      _isAnimating = true;
    });
    _animationController.reset();
    _animationController.forward();
  }

  Future<void> _playTickSound() async {
    if (!_isAudioReady) return;

    // Play a tick sound effect with haptic feedback
    HapticFeedback.mediumImpact();

    try {
      // Reset to the beginning of the audio
      await _tickSoundPlayer.seek(Duration.zero);

      // Play the sound and ensure it plays to completion
      await _tickSoundPlayer.play();

      // Debug message to confirm sound is playing
      debugPrint('Playing sound for number: $_displayNumber');
    } catch (e) {
      debugPrint('Error playing countdown sound: $e');
    }
  }

  @override
  void dispose() {
    // Cancel all timers
    for (var timer in _timers) {
      timer.cancel();
    }

    _animationController.dispose();
    _tickSoundPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2C94C), // Yellow background
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value,
              child: child,
            );
          },
          child: Text(
            _countdownStarted ? '$_displayNumber' : '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 120,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black26,
                  offset: Offset(5.0, 5.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
