import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'tasbih_model.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  final int _currentDhikrIndex = 0;
  bool _isAnimating = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    HapticFeedback.lightImpact();
    setState(() {
      _counter++;
      _isAnimating = true;
    });

    _animationController.forward();
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentDhikr = TasbihData.dhikrs[_currentDhikrIndex];
    final goalCount = currentDhikr.goalCount;
    final counterTextColor =
        _counter >= goalCount ? Colors.green : Colors.green.withAlpha(128);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Tasbih',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.green,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.green,
              size: 24,
            ),
            onPressed: _resetCounter,
          ),
          IconButton(
            icon: const Icon(
              Icons.vibration,
              color: Colors.green,
              size: 24,
            ),
            onPressed: () {
              // Toggle vibration
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _incrementCounter,
              child: Container(
                color: Colors.white,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Counter display
                    Text(
                      _counter.toString().padLeft(2, '0'),
                      style: TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.w300,
                        color: counterTextColor,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Tasbih beads
                    SizedBox(
                      height: 100,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Line
                          Container(
                            height: 2,
                            width: MediaQuery.of(context).size.width * 0.8,
                            color: Colors.grey.withAlpha(76),
                          ),

                          // Beads
                          ...List.generate(7, (index) {
                            final position = index / 6; // 0 to 1
                            final xOffset = (position *
                                    MediaQuery.of(context).size.width *
                                    0.8) -
                                (MediaQuery.of(context).size.width * 0.4);

                            return Positioned(
                              left: MediaQuery.of(context).size.width / 2 +
                                  xOffset -
                                  15,
                              top: 35,
                              child: AnimatedBuilder(
                                animation: _animation,
                                builder: (context, child) {
                                  double scale = 1.0;
                                  if (_isAnimating &&
                                      _counter % 7 == index + 1) {
                                    scale = 1.0 + (_animation.value * 0.3);
                                  }
                                  return Transform.scale(
                                    scale: scale,
                                    child: child,
                                  );
                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                    const Text(
                      'Tap anywhere to begin',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom section with current dhikr
          Column(
            children: [
              const Divider(height: 1),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Current Dhikr',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/spiritual/islam/tasbih/dhikr-list',
                        );
                      },
                      child: const Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(13),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      currentDhikr.arabicText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 22,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentDhikr.transliteration,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentDhikr.meaning,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DhikrSelectionSheet extends StatelessWidget {
  final int currentIndex;
  final Function(int) onSelect;

  const DhikrSelectionSheet({
    super.key,
    required this.currentIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Select Dhikr',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: TasbihData.dhikrs.length,
              itemBuilder: (context, index) {
                final dhikr = TasbihData.dhikrs[index];
                final isSelected = index == currentIndex;

                return ListTile(
                  leading: Text(
                    dhikr.arabicText,
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  title: Text(dhikr.transliteration),
                  subtitle: Text(
                    dhikr.meaning,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  onTap: () => onSelect(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
