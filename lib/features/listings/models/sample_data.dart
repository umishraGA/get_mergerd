import 'Category.dart';

class ListingsSampleData {
  static List<Category> getSampleCategories() {
    return [
      const Category(
        id: '1',
        name: 'Venues',
        imagePath: 'assets/images/listings/items/electronic.png',
        isTrending: true,
      ),
      const Category(
        id: '2',
        name: 'Decorations',
        imagePath: 'assets/images/listings/items/healthcare.png',
        isTrending: true,
      ),
      const Category(
        id: '3',
        name: 'Photography',
        imagePath: 'assets/images/listings/items/property.png',
        isTrending: true,
      ),
      const Category(
        id: '4',
        name: 'Catering',
        imagePath: 'assets/images/listings/items/electronic.png',
        isTrending: false,
      ),
      const Category(
        id: '5',
        name: 'Makeup Artists',
        imagePath: 'assets/images/listings/items/healthcare.png',
        isTrending: false,
      ),
      const Category(
        id: '6',
        name: 'Wedding Attire',
        imagePath: 'assets/images/listings/items/property.png',
        isTrending: true,
      ),
      const Category(
        id: '7',
        name: 'Entertainment',
        imagePath: 'assets/images/listings/items/electronic.png',
        isTrending: false,
      ),
      const Category(
        id: '8',
        name: 'Jewelry',
        imagePath: 'assets/images/listings/items/healthcare.png',
        isTrending: false,
      ),
    ];
  }
}
