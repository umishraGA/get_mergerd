import 'dart:io';

import 'package:flutter/material.dart';

/// Utility class for ensuring the Utsav feature has all required assets
class UtsavSetup {
  /// Ensures all required directories and files exist for Utsav feature
  static void ensureUtsavSetup() {
    _ensureDirectoriesExist();
    _createDefaultPlaceholder();
    _checkRequiredAssets();
    print('✅ Utsav setup check completed');
  }

  /// Ensures all required directories exist
  static void _ensureDirectoriesExist() {
    final directories = [
      'assets/images',
      'assets/images/utsav',
      'assets/images/utsav/categories',
      'assets/images/utsav/banners',
    ];

    for (final dir in directories) {
      final directory = Directory(dir);
      if (!directory.existsSync()) {
        print('⚠️ Creating directory: $dir');
        try {
          directory.createSync(recursive: true);
          print('✅ Created directory: $dir');
        } catch (e) {
          print('❌ Failed to create directory: $dir');
          print('   Error: $e');
        }
      }
    }
  }

  /// Check if all required asset files exist
  static void _checkRequiredAssets() {
    // Check for required category images
    final requiredCategoryImages = [
      'assets/images/utsav/categories/apparel.png',
      'assets/images/utsav/categories/ayurvedic.png',
      'assets/images/utsav/categories/food.png',
    ];

    for (final imagePath in requiredCategoryImages) {
      final file = File(imagePath);
      if (file.existsSync()) {
        print('✓ Found image: $imagePath');
      } else {
        print('⚠️ Missing image: $imagePath');
      }
    }

    // Check for required banner images
    final requiredBannerImages = [
      'assets/images/utsav/banners/offer_banner.png',
    ];

    for (final imagePath in requiredBannerImages) {
      final file = File(imagePath);
      if (file.existsSync()) {
        print('✓ Found banner: $imagePath');
      } else {
        print('⚠️ Missing banner: $imagePath');
      }
    }
  }

  /// Creates default placeholder images if they don't exist
  static void _createDefaultPlaceholder() {
    // Check for main placeholder
    final placeholderFile = File('assets/images/placeholder.png');
    if (!placeholderFile.existsSync()) {
      print('⚠️ Warning: Default placeholder image is missing');
      print('Create a placeholder.png at assets/images/placeholder.png');
      print('Use a simple gray image with 300x300 dimensions');
    }

    // Check for Utsav offer banner
    final offerBannerFile =
        File('assets/images/utsav/banners/offer_banner.png');
    if (!offerBannerFile.existsSync()) {
      print('⚠️ Warning: Default Utsav offer banner is missing');
      print(
          'Create a banner image at assets/images/utsav/banners/offer_banner.png');
    }
  }

  /// Returns a widget that displays a warning if assets are missing
  static Widget missingAssetsWarning({VoidCallback? onCheckPressed}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.amber[100],
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.amber[800]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Some assets may be missing. Click to check required files.',
              style: TextStyle(color: Colors.amber[900], fontSize: 12),
            ),
          ),
          TextButton(
            onPressed: onCheckPressed,
            style: TextButton.styleFrom(
              backgroundColor: Colors.amber[800],
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              minimumSize: const Size(80, 30),
            ),
            child: const Text(
              'Check Now',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
