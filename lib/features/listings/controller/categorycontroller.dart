import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../utils/dio/auth_helper.dart';
import '../views/filter_screen.dart';
import '../views/vendor_list_page.dart';

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

// RENAMED to avoid conflict
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
  
      final response = await http.get(
        Uri.parse('https://api.gamsgroup.in/user/common/get-category'),
        headers: {
          'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
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
        Get.snackbar(
          'Error',
          'Failed to load categories',
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Network error: ${e.toString()}',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void loadMainCategories() {
    currentCategories.value = categories.value;
    breadcrumb.clear();
  }

  void navigateToSubcategoryPage(BuildContext context, CategoryModel category) {
    if (category.children.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubcategoriesPage(parentCategory: category),
        ),
      );
    } else {
      _navigateToFinalPage(context, category);
    }
  }

  void _navigateToFinalPage(BuildContext context, CategoryModel category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VendorListPage(
          categoryName: category.name, // 👈 send category name here
        ),
      ),
    );
  }


  void goToHome() {
    breadcrumb.clear();
    currentCategories.value = categories.value;
  }

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

  bool hasSubcategories(CategoryModel category) {
    return category.children.isNotEmpty;
  }

  String getBreadcrumbPath() {
    if (breadcrumb.isEmpty) return 'Home';
    return breadcrumb.map((cat) => cat.name).join(' > ');
  }

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

  Future<void> refreshCategories() async {
    await fetchCategories();
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(parentCategory.name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
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
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.category_outlined,
              size: 48,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No subcategories available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This category doesn\'t have any subcategories',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildSubcategoriesList(CategoryControllerTest  controller) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: parentCategory.children.length,
      itemBuilder: (context, index) {
        final subcategory = parentCategory.children[index];
        final hasChildren = subcategory.children.isNotEmpty;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => controller.navigateToSubcategoryPage(context, subcategory),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: hasChildren
                            ? Colors.blue.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        hasChildren ? Icons.folder_outlined : Icons.check_circle_outline,
                        color: hasChildren ? Colors.blue : Colors.green,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subcategory.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            hasChildren
                                ? '${subcategory.children.length} subcategories'
                                : 'Final category',
                            style: TextStyle(
                              color: hasChildren ? Colors.grey[600] : Colors.green,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Final Category Page
