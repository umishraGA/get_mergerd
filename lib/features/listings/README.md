# Listings Feature

This feature provides a comprehensive marketplace/directory listing functionality for wedding-related services.

## Structure

The feature is organized into the following directories:

- **models/**: Contains data models
  - `Category.dart`: Model representing a listing category
  - `sample_data.dart`: Sample data for development/testing

- **views/**: Contains screens/pages
  - `ListingsPage.dart`: Main listings page showing categories
  - (Future planned) `CategoryDetailPage.dart`: Page showing services in a specific category
  - (Future planned) `ServiceDetailPage.dart`: Detailed view of a specific service/vendor

- **widgets/**: Contains reusable UI components
  - `CategoryCard.dart`: Card widget to display a category
  - `RequestQuoteForm.dart`: Form for requesting vendor quotes

## Features

1. **Category Browsing**: Users can browse through different wedding service categories
2. **Trending Categories**: Highlighted categories that are trending
3. **Quote Request**: Form to request quotes for services not found
4. **Favorite Categories**: Users can mark categories as favorites

## Integration

The feature is integrated into the main app via the bottom navigation bar in `MainPage.dart`.

## Future Enhancements

- Vendor listing pages within each category
- Detailed vendor profiles with reviews, pricing, and availability
- Direct messaging with vendors
- Booking functionality
- Payment integration 