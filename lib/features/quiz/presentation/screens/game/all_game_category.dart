import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/common/enum/enum.dart';
import 'package:myapp/features/quiz/presentation/controller/game_category_controller.dart';
import 'package:myapp/features/quiz/presentation/controller/game_sub_category_controller.dart';
import 'package:myapp/features/quiz/presentation/widgets/TopAppBarQuiz.dart';
import 'package:myapp/features/quiz/presentation/widgets/category_item.dart';

import '../../routes/quiz_routes.dart';
import 'game_sub_category.dart';

class AllGameCategoryScreen extends StatelessWidget {
  const AllGameCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GameCategoryController>();
    final subCategoryController = Get.find<GameSubCategoryController>();
    // Pre-load quiz images to ensure they're available
    _preloadImages(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2C94C), // Yellow background from screenshot
      body: Column(children: [
        const TopAppBarQuiz(),
        Expanded(
          child: Obx(() {
            switch (controller.status.value) {
              case ApiStatus.initial:
              case ApiStatus.loading:
                // Show shimmer
                return GridView.builder(
                  itemCount: 10,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.9,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return const CategoryCardShimmer();
                  },
                );
              case ApiStatus.success:
                // Show actual categories
                return GridView.builder(
                  itemCount: controller.categoriesZone.length,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.9,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    var data = controller.categoriesZone[index];
                    print("shjbns ${data.type}}");
                    return CategoryCard(
                      icon: data.icon ?? "",
                      type: "${data.type}",
                      // viewImage: true,
                      onTap: () async{
                        await subCategoryController.fetchSubCategoriesApi(data.id ?? "", data.type ?? "").then((item) {
                          Navigator.pushNamed(context, QuizRoutes.subCategory,
                              arguments: {
                                "type": data.type,
                                "categoryId": data.id ?? ""
                              }
                          );
                          // Get.to(() => GameSubCategoryScreen(type: data.type ?? "", categoryId: data.id ?? "",));
                        });
                      },
                    );
                  },
                );
              case ApiStatus.error:
                // Show error UI
                return const Center(child: Text('Failed to load categories'));
            }
          }),
        )
      ]),
    );
  }

  // Pre-load images to ensure they're properly cached
  void _preloadImages(BuildContext context) {
    // This forces Flutter to load the image into memory
    precacheImage(
        const AssetImage('assets/images/quiz/quiz_zone.png'), context);
  }

}
