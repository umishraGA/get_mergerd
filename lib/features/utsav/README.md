# Utsav Feature

The Utsav feature displays promotional categories and offers in a dedicated section of the app.

## Structure

- **models/** - Contains data models
  - `UtsavCategory.dart` - Model for categories

- **views/** - Contains screen UI
  - `UtsavPage.dart` - Main Utsav page with banner carousel and categories
  - `UtsavCategoryPage.dart` - Category detail page

- **widgets/** - Contains reusable UI components
  - `UtsavCategoryCard.dart` - Card widget for displaying a category
  - `UtsavOfferBanner.dart` - Widget for displaying promotional banners

## Image Assets

The feature requires the following image assets:

### Banners
Place offer banner images in: `assets/images/utsav/banners/`
- `utsav_offer.png` - Main offer banner
- `utsav_offer2.png` - Secondary offer banner
- `utsav_offer3.png` - Tertiary offer banner

### Category Images
Place category images in: `assets/images/utsav/categories/`
- `apparel.jpg` - Apparel & Fashion category image
- `ayurvedic.jpg` - Ayurvedic & Medicines category image
- `food.jpg` - Food & Beverages category image

## Usage

To add this feature to your app:
1. Add the Utsav section to your main app navigation
2. Add placeholder images in the specified image asset paths
3. Replace placeholder images with actual content when available 