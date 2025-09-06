import 'dart:math';
import 'package:flutter/material.dart';

class TasbihScreen extends StatefulWidget {
  @override
  _TasbihScreenState createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen>
    with SingleTickerProviderStateMixin {
  int count = 0;
  int goal = 33;
  int loop = 1;
  bool vibrate = true;
  late AnimationController _animationController;
  final TextEditingController _goalEditController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void incrementCounter() {
    setState(() {
      count++;
      if (count > goal) {
        count = 1;
        loop++;
      }
    });
    _animationController.forward().then((_) {
      _animationController.reset();
    });
  }

  void resetCounter() {
    setState(() {
      count = 0;
      loop = 1;
    });
  }

  void showGoalEditDialog() {
    _goalEditController.text = goal.toString();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Update Goal"),
        content: TextField(
          controller: _goalEditController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: "Enter new goal"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final int? newGoal = int.tryParse(_goalEditController.text);
              if (newGoal != null && newGoal > 0) {
                setState(() {
                  goal = newGoal;
                  count = 0;
                  loop = 1;
                });
              }
              Navigator.pop(context);
            },
            child: Text("Update"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Loop $loop",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.grey[700]),
            onPressed: resetCounter,
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 60),

          // Main Counter
          Text(
            '$count',
            style: TextStyle(
              fontSize: 120,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4CAF50),
            ),
          ),

          // Goal with edit icon
          GestureDetector(
            onTap: showGoalEditDialog,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "/ $goal",
                  style: TextStyle(fontSize: 24, color: Colors.grey[500]),
                ),
                SizedBox(width: 8),
                Icon(Icons.edit_outlined, size: 20, color: Colors.grey[500]),
              ],
            ),
          ),

          SizedBox(height: 80),

          // Tasbih Beads Animation
          Container(
            height: 120,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: TasbihBeadsPainter(
                    count: count,
                    maxCount: goal,
                    animation: _animationController.value,
                  ),
                  size: Size(MediaQuery.of(context).size.width - 40, 120),
                );
              },
            ),
          ),

          SizedBox(height: 80),

          // Tap Button
          GestureDetector(
            onTap: incrementCounter,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.touch_app,
                size: 40,
                color: Color(0xFF4CAF50),
              ),
            ),
          ),

          Spacer(),

          // Current Dhikr Section
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "Current Dhikr",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'سُبْحَانَ ٱللَّٰهِ وَبِحَمْدِهِ، سُبْحَانَ ٱللَّٰهِ ٱلْعَظِيمِ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, height: 1.5),
                ),
                SizedBox(height: 8),
                Text(
                  'Subhan Allahi wa bi Hamdihi, Subhan Allahil Adhim',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4CAF50),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class TasbihBeadsPainter extends CustomPainter {
  final int count;
  final int maxCount;
  final double animation;

  TasbihBeadsPainter({
    required this.count,
    required this.maxCount,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint beadPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    final Paint stringPaint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final double beadRadius = 8;
    final double centerY = size.height / 2;
    final double centerX = size.width / 2;

    // String line
    canvas.drawLine(
      Offset(50, centerY),
      Offset(size.width - 50, centerY),
      stringPaint,
    );

    // Calculate bead positions - FIXED LOGIC
    int leftBeads = maxCount - count;  // Remaining beads (not counted yet)
    int rightBeads = count;             // Counted beads

    // Left side beads (remaining/uncounted)
    if (leftBeads > 0) {
      double leftStartX = 60;
      double leftEndX = centerX - 20;
      double leftSpacing = (leftEndX - leftStartX) / (leftBeads > 1 ? leftBeads - 1 : 1);

      for (int i = 0; i < leftBeads; i++) {
        double x = leftStartX + (leftSpacing * i);
        // Add slight vertical offset for visual appeal
        double y = centerY + sin(i * 0.5) * 3;
        canvas.drawCircle(Offset(x, y), beadRadius, beadPaint);
      }
    }

    // Right side beads (counted)
    if (rightBeads > 0) {
      double rightStartX = centerX + 20;
      double rightEndX = size.width - 60;
      double rightSpacing = (rightEndX - rightStartX) / (rightBeads > 1 ? rightBeads - 1 : 1);

      Paint countedBeadPaint = Paint()
        ..color = Color(0xFF4CAF50).withOpacity(0.7)
        ..style = PaintingStyle.fill;

      for (int i = 0; i < rightBeads; i++) {
        double x = rightStartX + (rightSpacing * i);
        // Add slight vertical offset for visual appeal
        double y = centerY + sin(i * 0.5) * 3;
        canvas.drawCircle(Offset(x, y), beadRadius, countedBeadPaint);
      }
    }

    // Moving bead animation (when tapped)
    if (animation > 0 && leftBeads > 0) {
      // Calculate start position (last bead on left side)
      double leftStartX = 60;
      double leftEndX = centerX - 20;
      double leftSpacing = leftBeads > 1 ? (leftEndX - leftStartX) / (leftBeads - 1) : 0;
      double startX = leftStartX + (leftSpacing * (leftBeads - 1));

      // Calculate end position (first position on right side)
      double rightStartX = centerX + 20;
      double endX = rightStartX;

      double movingX = startX + (endX - startX) * animation;
      double movingY = centerY - 15 * sin(animation * pi); // Arc movement

      Paint movingBeadPaint = Paint()
        ..color = Color(0xFF4CAF50)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(movingX, movingY),
        beadRadius + 2, // Slightly larger for emphasis
        movingBeadPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}