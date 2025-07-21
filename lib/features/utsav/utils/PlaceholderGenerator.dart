import 'package:flutter/material.dart';

/// Generates colored placeholder containers for development and testing
class PlaceholderGenerator {
  /// Generate a banner placeholder with "OFFER" text
  static Widget offerBanner({
    required double width,
    required double height,
    Color? backgroundColor,
    String? text,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.amber.shade300, // Yellow base color
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: DottedPatternPainter(
                color: Colors.amber.shade400,
                dotSize: 8,
                spacing: 24,
              ),
            ),
          ),

          // Top wavy decoration
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 60,
              child: CustomPaint(
                painter: WavyPainter(
                  color: Colors.indigo.shade900.withOpacity(0.8),
                  waveHeight: 30,
                ),
              ),
            ),
          ),

          // Bottom wavy decoration
          Positioned(
            bottom: -10,
            right: 0,
            child: SizedBox(
              width: 120,
              height: 60,
              child: CustomPaint(
                painter: WavyPainter(
                  color: Colors.white.withOpacity(0.4),
                  waveHeight: 20,
                  direction: true,
                ),
              ),
            ),
          ),

          // Blue diagonal banner
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Transform.rotate(
              angle: -0.08,
              child: Container(
                height: 80,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade900,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'THIS WEEK',
                      style: TextStyle(
                        color: Colors.amber.shade300,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      text ?? 'OFFERS',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Orange cashback banner
          Positioned(
            bottom: 35,
            right: 30,
            child: Transform.rotate(
              angle: -0.08,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.deepOrange.shade600,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'EXTRA 10% CASHBACK',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Generate a category placeholder with the category name
  static Widget categoryImage({
    required double width,
    required double height,
    required String categoryName,
    Color? backgroundColor,
  }) {
    // Generate a color based on the category name for consistent colors
    final int nameHash = categoryName.hashCode;
    Color color;

    // Special case for Ayurvedic & Medicines to match the herb image
    if (categoryName.toLowerCase().contains('ayurvedic') ||
        categoryName.toLowerCase().contains('medicine')) {
      color = backgroundColor ?? const Color(0xFF6E4D1B); // Earthy brown color
    } else {
      color = backgroundColor ??
          Color.fromARGB(
            255,
            100 + (nameHash % 155),
            100 + ((nameHash >> 8) % 155),
            100 + ((nameHash >> 16) % 155),
          );
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background pattern
          if (categoryName.toLowerCase().contains('ayurvedic') ||
              categoryName.toLowerCase().contains('medicine'))
            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'assets/images/utsav/categories/herbs_pattern.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback if image not found
                    return CustomPaint(
                      painter: LeafPatternPainter(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    );
                  },
                ),
              ),
            ),

          // Decorative elements
          Positioned(
            top: height * 0.1,
            right: width * 0.1,
            child: Icon(
              _getCategoryIcon(categoryName),
              size: height * 0.3,
              color: Colors.white.withOpacity(0.3),
            ),
          ),

          // Diagonal pattern
          Positioned.fill(
            child: CustomPaint(
              painter: DiagonalStripesPainter(
                color: Colors.white.withOpacity(0.1),
                stripeWidth: 20,
              ),
            ),
          ),

          // Center icon
          Icon(
            _getCategoryIcon(categoryName),
            size: 40,
            color: Colors.white.withOpacity(0.7),
          ),
        ],
      ),
    );
  }

  /// Get an appropriate icon for a category
  static IconData _getCategoryIcon(String categoryName) {
    final normalizedName = categoryName.toLowerCase();

    if (normalizedName.contains('food') ||
        normalizedName.contains('beverage')) {
      return Icons.restaurant;
    } else if (normalizedName.contains('apparel') ||
        normalizedName.contains('fashion')) {
      return Icons.shopping_bag;
    } else if (normalizedName.contains('ayuvedic') ||
        normalizedName.contains('medicine')) {
      return Icons.healing;
    } else if (normalizedName.contains('electronics')) {
      return Icons.devices;
    } else if (normalizedName.contains('book')) {
      return Icons.book;
    } else if (normalizedName.contains('beauty')) {
      return Icons.face;
    } else if (normalizedName.contains('sport')) {
      return Icons.sports_soccer;
    } else {
      return Icons.category;
    }
  }
}

/// Painter for creating diagonal stripes
class DiagonalStripesPainter extends CustomPainter {
  final Color color;
  final double stripeWidth;

  DiagonalStripesPainter({
    required this.color,
    this.stripeWidth = 10,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = stripeWidth
      ..style = PaintingStyle.stroke;

    double lineOffset = -2 * size.width;
    while (lineOffset < size.width + size.height) {
      canvas.drawLine(
        Offset(lineOffset, 0),
        Offset(lineOffset + size.height, size.height),
        paint,
      );
      lineOffset += stripeWidth * 2;
    }
  }

  @override
  bool shouldRepaint(DiagonalStripesPainter oldDelegate) =>
      color != oldDelegate.color || stripeWidth != oldDelegate.stripeWidth;
}

/// Painter for creating dotted pattern background
class DottedPatternPainter extends CustomPainter {
  final Color color;
  final double dotSize;
  final double spacing;

  DottedPatternPainter({
    required this.color,
    this.dotSize = 5,
    this.spacing = 20,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(
          Offset(x, y),
          dotSize / 2,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(DottedPatternPainter oldDelegate) =>
      color != oldDelegate.color ||
      dotSize != oldDelegate.dotSize ||
      spacing != oldDelegate.spacing;
}

/// Painter for creating wavy decorations
class WavyPainter extends CustomPainter {
  final Color color;
  final double waveHeight;
  final bool direction;

  WavyPainter({
    required this.color,
    this.waveHeight = 30,
    this.direction = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height - waveHeight);

    // Create a wavy bottom edge
    double x = 0;
    while (x < size.width) {
      // Draw a half circle bulge
      if (direction) {
        path.relativeQuadraticBezierTo(
            waveHeight / 2, -waveHeight, waveHeight, 0);
        path.relativeQuadraticBezierTo(
            waveHeight / 2, waveHeight, waveHeight, 0);
      } else {
        path.relativeQuadraticBezierTo(
            waveHeight / 2, waveHeight, waveHeight, 0);
        path.relativeQuadraticBezierTo(
            waveHeight / 2, -waveHeight, waveHeight, 0);
      }
      x += waveHeight * 2;
    }

    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavyPainter oldDelegate) =>
      color != oldDelegate.color ||
      waveHeight != oldDelegate.waveHeight ||
      direction != oldDelegate.direction;
}

/// Painter for creating a leaf/herb pattern background
class LeafPatternPainter extends CustomPainter {
  final Color color;

  LeafPatternPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final random = DateTime.now().microsecondsSinceEpoch;

    // Draw simplified herb patterns
    for (int i = 0; i < 10; i++) {
      final startX = (random % (i + 1) * 17) % size.width;
      final startY = (random % (i + 3) * 23) % size.height;

      // Draw a simple leaf shape
      final path = Path();
      path.moveTo(startX, startY);
      path.quadraticBezierTo(startX + 30, startY - 20, startX + 60, startY);
      path.quadraticBezierTo(startX + 30, startY + 20, startX, startY);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(LeafPatternPainter oldDelegate) =>
      color != oldDelegate.color;
}
