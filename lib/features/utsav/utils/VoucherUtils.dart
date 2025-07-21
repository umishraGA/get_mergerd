import 'dart:math' as math;

import 'package:flutter/material.dart';

// Custom clipper for the voucher shape with circular cutouts on both sides
class VoucherClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const radius = 16.0;
    const cutoutRadius = 8.0;
    const cutoutSpace = 20.0; // Space between cutouts

    // Top left corner
    path.moveTo(radius, 0);

    // Top edge
    path.lineTo(size.width - radius, 0);

    // Top right corner
    path.quadraticBezierTo(size.width, 0, size.width, radius);

    // Right edge with small circular cutouts
    double yRight = radius + cutoutSpace / 2;
    while (yRight < size.height - radius - cutoutSpace / 2) {
      // Draw the line to the cutout
      path.lineTo(size.width, yRight - cutoutRadius);

      // Draw the cutout (half circle)
      path.arcTo(
          Rect.fromCircle(
              center: Offset(size.width, yRight), radius: cutoutRadius),
          -math.pi / 2,
          math.pi,
          false);

      yRight += cutoutSpace;
    }

    // Continue right edge to bottom
    path.lineTo(size.width, size.height - radius);

    // Bottom right corner with rounded edge
    path.quadraticBezierTo(
        size.width, size.height, size.width - radius, size.height);

    // Bottom edge (straight line)
    path.lineTo(radius, size.height);

    // Bottom left corner with rounded edge
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);

    // Left edge with small circular cutouts (symmetrical to right edge)
    double yLeft = size.height - radius - cutoutSpace / 2;
    while (yLeft > radius + cutoutSpace / 2) {
      // Draw the line to the cutout
      path.lineTo(0, yLeft + cutoutRadius);

      // Draw the cutout (half circle)
      path.arcTo(
          Rect.fromCircle(center: Offset(0, yLeft), radius: cutoutRadius),
          math.pi / 2,
          math.pi,
          false);

      yLeft -= cutoutSpace;
    }

    // Continue left edge to top
    path.lineTo(0, radius);

    // Top left corner
    path.quadraticBezierTo(0, 0, radius, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Custom painter for the voucher background and border
class VoucherPainter extends CustomPainter {
  final Color? borderColor;

  VoucherPainter({this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor ?? const Color(0xFFEF3340).withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    const radius = 16.0;
    const cutoutRadius = 8.0;
    const cutoutSpace = 20.0; // Space between cutouts

    // Top left corner
    path.moveTo(radius, 0);

    // Top edge
    path.lineTo(size.width - radius, 0);

    // Top right corner
    path.quadraticBezierTo(size.width, 0, size.width, radius);

    // Right edge with small circular cutouts
    double yRight = radius + cutoutSpace / 2;
    while (yRight < size.height - radius - cutoutSpace / 2) {
      // Draw the line to the cutout
      path.lineTo(size.width, yRight - cutoutRadius);

      // Draw the cutout (half circle)
      path.arcTo(
          Rect.fromCircle(
              center: Offset(size.width, yRight), radius: cutoutRadius),
          -math.pi / 2,
          math.pi,
          false);

      yRight += cutoutSpace;
    }

    // Continue right edge to bottom
    path.lineTo(size.width, size.height - radius);

    // Bottom right corner with rounded edge
    path.quadraticBezierTo(
        size.width, size.height, size.width - radius, size.height);

    // Bottom edge (straight line)
    path.lineTo(radius, size.height);

    // Bottom left corner with rounded edge
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);

    // Left edge with small circular cutouts (symmetrical to right edge)
    double yLeft = size.height - radius - cutoutSpace / 2;
    while (yLeft > radius + cutoutSpace / 2) {
      // Draw the line to the cutout
      path.lineTo(0, yLeft + cutoutRadius);

      // Draw the cutout (half circle)
      path.arcTo(
          Rect.fromCircle(center: Offset(0, yLeft), radius: cutoutRadius),
          math.pi / 2,
          math.pi,
          false);

      yLeft -= cutoutSpace;
    }

    // Continue left edge to top
    path.lineTo(0, radius);

    // Top left corner
    path.quadraticBezierTo(0, 0, radius, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom painter for the dashed divider line
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 1;

    const dashWidth = 5;
    const dashSpace = 5;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
