import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../views/filter_screen.dart';

class CategoryModel {
  String id;
  String name;
  List<CategoryModel> children;
  String? bannerImage;

  CategoryModel({
    required this.id,
    required this.name,
    required this.children,
    this.bannerImage,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      bannerImage: json['thumbImage']?.toString(),
      children: json['children'] != null
          ? (json['children'] as List)
          .map((child) => CategoryModel.fromJson(child as Map<String, dynamic>))
          .toList()
          : [],
    );
  }
}

class CategoryControllerTest extends GetxController {
  var categories = <CategoryModel>[].obs;
  var currentCategories = <CategoryModel>[].obs;
  var isLoading = true.obs;
  var breadcrumb = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('https://api.gamsgroup.in/user/common/get-category'),
        headers: {
          'Authorization': 'Bearer ${token ?? ''}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          List<CategoryModel> categoryList = (data['data'] as List)
              .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
              .toList();
          categories.value = categoryList;
          loadMainCategories();
        }
      } else {
        Get.snackbar('Error', 'Failed to load categories');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Load only main categories (top level)
  void loadMainCategories() {
    currentCategories.value = categories.value;
    breadcrumb.clear();
  }

  // Navigate to subcategory page (for hierarchical navigation)
  void navigateToSubcategoryPage(BuildContext context, CategoryModel category) {
    if (category.children.isNotEmpty) {
      // Navigate to SubcategoriesPage for categories with children
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubcategoriesPage(parentCategory: category),
        ),
      );
    } else {
      // Navigate to final category page for leaf categories
      _navigateToFinalPage(context, category);
    }
  }

  // Navigate to appropriate final page based on category
  void _navigateToFinalPage(BuildContext context, CategoryModel category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AyurvedicDoctorsPage(),
      ),
    );
  }
  void goToHome() {
    breadcrumb.clear();
    currentCategories.value = categories.value;
  }

  // Go back one level in breadcrumb
  void goBack() {
    if (breadcrumb.isNotEmpty) {
      breadcrumb.removeLast();
      if (breadcrumb.isEmpty) {
        loadMainCategories();
      } else {
        CategoryModel parent = breadcrumb.last;
        currentCategories.value = parent.children;
      }
    }
  }

  // Check if category has subcategories
  bool hasSubcategories(CategoryModel category) {
    return category.children.isNotEmpty;
  }

  // Get breadcrumb path as string
  String getBreadcrumbPath() {
    if (breadcrumb.isEmpty) return 'Home';
    return breadcrumb.map((cat) => cat.name).join(' > ');
  }

  // Get category by ID
  CategoryModel? getCategoryById(String id) {
    return _findCategoryById(categories.value, id);
  }

  CategoryModel? _findCategoryById(List<CategoryModel> categories, String id) {
    for (CategoryModel category in categories) {
      if (category.id == id) return category;
      CategoryModel? found = _findCategoryById(category.children, id);
      if (found != null) return found;
    }
    return null;
  }

  // Search categories by name
  List<CategoryModel> searchCategories(String query) {
    if (query.isEmpty) return [];
    return _searchInCategories(categories.value, query.toLowerCase());
  }

  List<CategoryModel> _searchInCategories(List<CategoryModel> categories, String query) {
    List<CategoryModel> results = [];
    for (CategoryModel category in categories) {
      if (category.name.toLowerCase().contains(query)) {
        results.add(category);
      }
      results.addAll(_searchInCategories(category.children, query));
    }
    return results;
  }

  // Get all leaf categories (categories with no children)
  List<CategoryModel> getLeafCategories() {
    return _getLeafCategories(categories.value);
  }

  List<CategoryModel> _getLeafCategories(List<CategoryModel> categories) {
    List<CategoryModel> leafCategories = [];
    for (CategoryModel category in categories) {
      if (category.children.isEmpty) {
        leafCategories.add(category);
      } else {
        leafCategories.addAll(_getLeafCategories(category.children));
      }
    }
    return leafCategories;
  }

  // Refresh categories
  Future<void> refreshCategories() async {
    await fetchCategories();
  }

  // Clear all data
  void clearData() {
    currentCategories.clear();
    breadcrumb.clear();
    categories.clear();
  }

  // Get category depth/level
  int getCategoryDepth(CategoryModel category) {
    return _getCategoryDepth(categories.value, category, 0);
  }

  int _getCategoryDepth(List<CategoryModel> categories, CategoryModel target, int currentDepth) {
    for (CategoryModel category in categories) {
      if (category.id == target.id) return currentDepth;
      int childDepth = _getCategoryDepth(category.children, target, currentDepth + 1);
      if (childDepth != -1) return childDepth;
    }
    return -1;
  }

  // Add a new method to register custom final page navigation
  void registerCustomFinalPage(String categoryId, Widget Function(BuildContext) pageBuilder) {
    // This can be used to add custom navigation for specific categories
    // Implementation can be added based on your needs
  }
}

// Subcategories Page
class SubcategoriesPage extends StatelessWidget {
  final CategoryModel parentCategory;

  const SubcategoriesPage({Key? key, required this.parentCategory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CategoryControllerTest controller = Get.find<CategoryControllerTest>();

    return Scaffold(
      appBar: AppBar(
        title: Text(parentCategory.name),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: parentCategory.children.isEmpty
          ? _buildEmptyState(context)
          : _buildSubcategoriesList(controller),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No subcategories available',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildSubcategoriesList(CategoryControllerTest controller) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: parentCategory.children.length,
      itemBuilder: (context, index) {
        final subcategory = parentCategory.children[index];
        return Card(
          elevation: 2,
          margin: EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                Icons.category,
                color: Colors.blue,
                size: 24,
              ),
            ),
            title: Text(
              subcategory.name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            subtitle: subcategory.children.isNotEmpty
                ? Text(
              '${subcategory.children.length} subcategories',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            )
                : Text(
              'Final category',
              style: TextStyle(
                color: Colors.green[600],
                fontSize: 12,
              ),
            ),
            trailing: Icon(
              subcategory.children.isNotEmpty
                  ? Icons.arrow_forward_ios
                  : Icons.check_circle_outline,
              size: 16,
              color: subcategory.children.isNotEmpty
                  ? Colors.grey[600]
                  : Colors.green[600],
            ),
            onTap: () => controller.navigateToSubcategoryPage(context, subcategory),
          ),
        );
      },
    );
  }
}

// Final Category Page (for categories with no children)
class FinalCategoryPage extends StatelessWidget {
  final CategoryModel category;

  const FinalCategoryPage({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 60,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 24),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Category ID: ${category.id}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'This is the final category.\nHere you can show products or listings.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to products/listings for this category
                    _showProducts(context);
                  },
                  icon: Icon(Icons.list),
                  label: Text('View Products'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back),
                  label: Text('Go Back'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showProducts(BuildContext context) {
    // Navigate to a generic products page or show appropriate content
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Here you would show products for ${category.name}'),
        backgroundColor: Colors.blue.withOpacity(0.8),
        duration: Duration(seconds: 2),
      ),
    );

    // Alternatively, you could navigate to a products page:
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ProductsPage(categoryId: category.id, categoryName: category.name),
    //   ),
    // );
  }
}