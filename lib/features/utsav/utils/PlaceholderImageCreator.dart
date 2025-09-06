import 'dart:io';

/// This class provides instructions for manually creating placeholder images
/// You can use these instructions to create actual image files when needed
class PlaceholderImageCreator {
  /// Instructions for creating the placeholder.png file
  static String getPlaceholderInstructions() {
    return '''
To create a placeholder.png file:
1. Create a 300x300 pixel image with a light gray background (#E0E0E0)
2. Add a darker gray rectangle (#BDBDBD) covering the center 200x200 pixels
3. Add a gray camera icon in the center
4. Add text "Image Placeholder" at the bottom
5. Save as PNG format to assets/images/placeholder.png
''';
  }

  /// Instructions for creating the banner placeholder images
  static String getBannerInstructions() {
    return '''
To create utsav_offer.png banner files:
1. Create a 1200x675 pixel image (16:9 aspect ratio)
2. Use a bright gradient background (orange to red)
3. Add "THIS WEEK" text in a blue banner at the top
4. Add large "OFFERS" text in the center
5. Add "EXTRA 10% CASHBACK" text in a red banner at the bottom
6. Save as PNG format to assets/images/utsav/banners/utsav_offer.png
7. Create variations for utsav_offer2.png and utsav_offer3.png with different colors or layouts
''';
  }

  /// Instructions for creating the category placeholder images
  static String getCategoryInstructions() {
    return '''
To create category image files:
1. Create 600x600 pixel square images
2. For "Apparel & Fashion":
   - Use lifestyle image with clothing items
   - Save as assets/images/utsav/categories/apparel.jpg
3. For "Ayurvedic & Medicines":
   - Use image with herbs, powders, or natural medicine ingredients
   - Save as assets/images/utsav/categories/ayurvedic.jpg
4. For "Food & Beverages":
   - Use food image with a drink
   - Save as assets/images/utsav/categories/food.jpg
''';
  }

  /// Call this function from a temporary widget to print all instructions to console
  static void printAllInstructions() {
    print('\n=== PLACEHOLDER IMAGE CREATION INSTRUCTIONS ===\n');
    print(getPlaceholderInstructions());
    print('\n${getBannerInstructions()}');
    print('\n${getCategoryInstructions()}');
    print('\n=== END INSTRUCTIONS ===\n');
  }

  /// Check if all required directories exist, create them if they don't
  static void ensureDirectoriesExist() {
    // Create base assets directory
    Directory('assets').createSync(recursive: true);

    // Create other required directories
    Directory('assets/images').createSync(recursive: true);
    Directory('assets/images/utsav').createSync(recursive: true);
    Directory('assets/images/utsav/banners').createSync(recursive: true);
    Directory('assets/images/utsav/categories').createSync(recursive: true);

    print('Created all required directories for Utsav feature images');
  }
}
