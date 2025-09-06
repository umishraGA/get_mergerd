import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/common/enum/enum.dart';
import 'package:myapp/features/quiz/presentation/controller/game_category_controller.dart';
import 'package:myapp/features/quiz/presentation/controller/game_sub_category_controller.dart';
import 'package:myapp/features/quiz/presentation/routes/quiz_routes.dart';
import 'package:myapp/features/quiz/presentation/screens/game/game_sub_category.dart';
import 'package:myapp/features/quiz/presentation/widgets/category_item.dart';

class GameCategoriesScreen extends StatefulWidget {
  const GameCategoriesScreen({super.key});

  @override
  State<GameCategoriesScreen> createState() => _GameCategoriesScreenState();
}

class _GameCategoriesScreenState extends State<GameCategoriesScreen> {
  final controller = Get.put(GameCategoryController());
  final subCategoryController = Get.put(GameSubCategoryController());

  @override
  void initState() {
    controller.fetchCategoriesApi("zone");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.status.value) {
        case ApiStatus.initial:
        case ApiStatus.loading:
        // Show shimmer
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 10),
            itemCount: 5,
            itemBuilder: (context, index) => const CategoryCardShimmer(),
          );

        case ApiStatus.success:
        // Show actual categories
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 10),
            itemCount: controller.categoriesZone.length  > 6 ? 5 : controller.categoriesZone.length,
            itemBuilder: (context, index) {
              var data = controller.categoriesZone[index];
              return CategoryCard(
                icon: data.icon ?? "",
                type: data.categoryName ?? "",
                // viewImage: true,
                onTap: (){
                  subCategoryController.fetchSubCategoriesApi(data.id ?? "", data.type ?? "").then((v){
                    Navigator.pushNamed(context, QuizRoutes.subCategory,
                    arguments: {
                      "type": data.type,
                      "categoryId": data.id ?? ""
                    }
                    );
                    // Get.to(()=> GameSubCategoryScreen(type: data.type ?? "", categoryId: data.id ?? "",));
                  });
                },
              );
            },
          );

        case ApiStatus.error:
        // Show error UI
          return const Center(child: Text('Failed to load categories'));
      }
    });
  }
}
