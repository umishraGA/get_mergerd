import 'package:flutter/material.dart';

class CategoryFilter extends StatefulWidget {
  final Function(String) onCategorySelected;
  final List<String>? categories;

  const CategoryFilter({
    super.key,
    required this.onCategorySelected,
    this.categories,
  });

  @override
  State<CategoryFilter> createState() => _CategoryFilterState();
}

class _CategoryFilterState extends State<CategoryFilter> {
  String selectedCategory = 'All Events';

  @override
  Widget build(BuildContext context) {
    final categories = widget.categories ??
        [
          'All Events',
          'Arts',
          'Sports',
          'Concert',
          'Theatre',
          'Technology',
          'Food',
        ];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
              widget.onCategorySelected(category);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color:
                    isSelected ? const Color(0xFFFC6E30) : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFFC6E30)
                      : const Color(0xFF909090),
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF909090),
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
