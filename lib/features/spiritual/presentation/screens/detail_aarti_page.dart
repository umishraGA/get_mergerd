import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class AartiDetailPage extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String description;

  const AartiDetailPage({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.description,
  });

  @override
  State<AartiDetailPage> createState() => _AartiDetailPageState();
}

class _AartiDetailPageState extends State<AartiDetailPage> {
  double _fontSize = 16.0;
  int _selectedTextColor = 0;

  final List<Color> _textColors = [
    Colors.black,
    Colors.red.shade700,
    Colors.blue.shade700,
    Colors.green.shade700,
    Colors.purple.shade700,
    Colors.brown.shade700,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFBB9F9F)),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xFFBB9F9F),
                  size: 18,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.palette, color: Colors.grey.shade700),
            onPressed: _showCustomizationPanel,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.90,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CustomPaint(
            painter: FloralBorderPainter(),
            child: Container(
              margin: const EdgeInsets.all(8), // Margin for the floral border
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: SingleChildScrollView(
                      child: Html(
                        data: widget.description,
                        style: {
                          "body": Style(
                            fontSize: FontSize(_fontSize),
                            color: _textColors[_selectedTextColor],
                            textAlign: TextAlign.center,
                            lineHeight: LineHeight(1.6),
                          ),
                          "p": Style(
                            fontSize: FontSize(_fontSize),
                            color: _textColors[_selectedTextColor],
                            textAlign: TextAlign.center,
                            margin: Margins.only(bottom: 12),
                          ),
                          "h1": Style(
                            fontSize: FontSize(_fontSize * 1.4),
                            color: _textColors[_selectedTextColor],
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                            margin: Margins.only(bottom: 16),
                          ),
                          "h2": Style(
                            fontSize: FontSize(_fontSize * 1.2),
                            color: _textColors[_selectedTextColor],
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.center,
                            margin: Margins.only(bottom: 12),
                          ),
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  void _showCustomizationPanel() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Customize Reading', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),

            // Font Size Section
            const Text('Font Size', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFontButton(Icons.remove, _fontSize > 12, () => setState(() => _fontSize--)),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('${_fontSize.round()}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade700)),
                ),
                _buildFontButton(Icons.add, _fontSize < 24, () => setState(() => _fontSize++)),
              ],
            ),
            const SizedBox(height: 24),

            // Text Color Section
            const Text('Text Color', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            _buildColorSelector(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildFontButton(IconData icon, bool enabled, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: enabled ? Colors.blue : Colors.grey.shade300,
        shape: BoxShape.circle,
        boxShadow: enabled ? [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2))] : null,
      ),
      child: IconButton(
        icon: Icon(icon, color: enabled ? Colors.white : Colors.grey.shade500),
        onPressed: enabled ? onPressed : null,
      ),
    );
  }

  Widget _buildColorSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _textColors.asMap().entries.map((entry) {
        int index = entry.key;
        Color color = entry.value;
        bool isSelected = index == _selectedTextColor;

        return GestureDetector(
          onTap: () => setState(() => _selectedTextColor = index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isSelected ? 50 : 40,
            height: isSelected ? 50 : 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey.shade300,
                width: isSelected ? 3 : 1,
              ),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ] : null,
            ),
            child: isSelected ? const Icon(Icons.check, color: Colors.blue, size: 20) : null,
          ),
        );
      }).toList(),
    );
  }
}

class FloralBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final flowerPaint = Paint()
      ..color = Colors.orange.shade300
      ..style = PaintingStyle.fill;

    final leafPaint = Paint()
      ..color = Colors.green.shade400
      ..style = PaintingStyle.fill;

    const flowerSize = 24.0;
    const spacing = 60.0;
    const flowerCount = 6;

    // Top border flowers
    for (int i = 0; i < flowerCount; i++) {
      final x = spacing + (i * (size.width - 2 * spacing) / (flowerCount - 1));
      _drawFlower(
        canvas,
        Offset(x, 10),
        flowerSize,
        flowerPaint,
        hasLeaves: i % 2 == 0,
        leafPaint: leafPaint,
      );
    }

    // Bottom border flowers
    for (int i = 0; i < flowerCount; i++) {
      final x = spacing + (i * (size.width - 2 * spacing) / (flowerCount - 1));
      _drawFlower(
        canvas,
        Offset(x, size.height - 10),
        flowerSize,
        flowerPaint,
        hasLeaves: i % 2 == 1,
        leafPaint: leafPaint,
      );
    }

    // Left border flowers
    for (int i = 1; i < flowerCount - 1; i++) {
      final y = spacing + (i * (size.height - 2 * spacing) / (flowerCount - 1));
      _drawFlower(
        canvas,
        Offset(10, y),
        flowerSize,
        flowerPaint,
        hasLeaves: i % 2 == 0,
        leafPaint: leafPaint,
      );
    }

    // Right border flowers
    for (int i = 1; i < flowerCount - 1; i++) {
      final y = spacing + (i * (size.height - 2 * spacing) / (flowerCount - 1));
      _drawFlower(
        canvas,
        Offset(size.width - 10, y),
        flowerSize,
        flowerPaint,
        hasLeaves: i % 2 == 1,
        leafPaint: leafPaint,
      );
    }

    // Corner accent flowers (larger with more leaves)
    _drawFlower(canvas, Offset(20, 20), flowerSize*1.5, flowerPaint, hasLeaves: true, leafPaint: leafPaint);
    _drawFlower(canvas, Offset(size.width - 20, 20), flowerSize*1.5, flowerPaint, hasLeaves: true, leafPaint: leafPaint);
    _drawFlower(canvas, Offset(20, size.height - 20), flowerSize*1.5, flowerPaint, hasLeaves: true, leafPaint: leafPaint);
    _drawFlower(canvas, Offset(size.width - 20, size.height - 20), flowerSize*1.5, flowerPaint, hasLeaves: true, leafPaint: leafPaint);
  }

  void _drawFlower(Canvas canvas, Offset center, double size, Paint paint,
      {bool hasLeaves = false, Paint? leafPaint}) {
    final petals = 5;
    final radius = size / 2;

    // Draw leaves first (behind flower)
    if (hasLeaves && leafPaint != null) {
      _drawLeaves(canvas, center, radius * 1.5, leafPaint);
    }

    // Draw petals
    for (int i = 0; i < petals; i++) {
      final angle = i * (2 * pi / petals);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      canvas.drawCircle(Offset(x, y), radius * 0.6, paint);
    }

    // Draw center circle
    canvas.drawCircle(center, radius * 0.3, paint..color = Colors.amber.shade200);
  }

  void _drawLeaves(Canvas canvas, Offset center, double size, Paint paint) {
    final leaves = 4;
    final radius = size;

    for (int i = 0; i < leaves; i++) {
      final angle = i * (2 * pi / leaves) + pi/4;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      // Draw leaf shape (simplified oval)
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: size*0.5, height: size*0.3),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}