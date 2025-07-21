import 'package:flutter/material.dart';

class AppTextStyles {
  // Regular Text Styles (w400)
  static const TextStyle regular10 = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
  );

  static const TextStyle regular12 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
  );

  static const TextStyle regular14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
  );

  static const TextStyle regular16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
  );

  static const TextStyle regular18 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
  );

  // Medium Text Styles (w500)
  static const TextStyle medium10 = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  static const TextStyle medium12 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  static const TextStyle medium14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  static const TextStyle medium15 = TextStyle(
    fontSize: 15,
    height: 1.4,
    fontFamily: 'FacebookSans',
  );

  static const TextStyle medium16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  static const TextStyle medium18 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  // SemiBold Text Styles (w600)
  static const TextStyle semiBold10 = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const TextStyle semiBold12 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const TextStyle semiBold14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const TextStyle semiBold16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const TextStyle semiBold18 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  // Bold Text Styles (w700)
  static const TextStyle bold10 = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: Colors.black87,
  );

  static const TextStyle bold12 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: Colors.black87,
  );

  static const TextStyle bold14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Colors.black87,
  );

  static const TextStyle bold16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  static const TextStyle bold18 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Colors.black87,
  );

  // Helper Extensions
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle withOpacity(TextStyle style, double opacity) {
    return style.copyWith(color: style.color?.withOpacity(opacity));
  }

  static TextStyle withFont(TextStyle style, String fontFamily) {
    return style.copyWith(fontFamily: fontFamily);
  }
}

// Extension for easier usage
extension TextStyleExtensions on TextStyle {
  TextStyle get facebookFont => copyWith(fontFamily: 'FacebookSans');

  TextStyle withOpacity(double opacity) =>
      copyWith(color: color?.withOpacity(opacity));
  TextStyle withColor(Color newColor) => copyWith(color: newColor);
  TextStyle withSize(double size) => copyWith(fontSize: size);
  TextStyle withFont(String fontFamily) => copyWith(fontFamily: fontFamily);
}
