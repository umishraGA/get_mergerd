import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/category_controller.dart';

class CategoryFilterView extends StatelessWidget {
  const CategoryFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryFilterController controller = Get.put(CategoryFilterController());

    return SizedBox(
      height: 40,
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.categories.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            final isSelected = controller.selectedCategory.value == category;

            return GestureDetector(
              onTap: () => controller.selectCategory(category),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFFC6E30)
                      : Colors.transparent,
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
                    color: isSelected
                        ? Colors.white
                        : const Color(0xFF909090),
                    fontWeight: isSelected
                        ? FontWeight.w500
                        : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
