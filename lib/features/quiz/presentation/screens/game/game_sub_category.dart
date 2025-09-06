import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/common/enum/enum.dart';
import 'package:myapp/features/quiz/presentation/routes/quiz_routes.dart';
import 'package:myapp/features/quiz/presentation/screens/game/game_category_level.dart';
import '../../controller/game_category_level_controller.dart';
import '../../controller/game_sub_category_controller.dart';
import '../../widgets/category_item.dart' show CategoryCard;
import '../../widgets/sub_category_widget.dart' show CategoryItemShimmer;

class GameSubCategoryScreen extends StatelessWidget {
  final String type;
  final String categoryId;
  const GameSubCategoryScreen({super.key, required this.type, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    var gameLevelController = Get.put(GameCategoryLevelController());
    final controller = Get.find<GameSubCategoryController>();
    return Scaffold(
      backgroundColor: const Color(0xFFAA98FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA794F6),
        title: const Text("Game Sub Categories"),
      ),
      body: Obx(() {
        switch (controller.apiStatus.value) {
          case ApiStatus.initial:
          case ApiStatus.loading:
            return GridView.builder(
              itemCount: 10,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                mainAxisSpacing: 15,
                crossAxisSpacing: 0,
              ),
              itemBuilder: (context, index) {
                return const CategoryItemShimmer();
              },
            );

          case ApiStatus.success:
            if(controller.subCategories.isNotEmpty){
              return  GridView.builder(
                itemCount: controller.subCategories.length,
                padding: EdgeInsets.symmetric(horizontal: 12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 0,
                ),
                itemBuilder: (context, index) {
                  final data = controller.subCategories[index];
                  return CategoryCard(
                    icon: data.icon ?? "",
                    type: data.categoryName ?? "",
                    // viewImage: true,
                    onTap: (){
                      gameLevelController.fetchCategoriesLevelData(categoryId, data.id ?? "", type).then((_){
                        Navigator.pushNamed(context, QuizRoutes.categoryLevels, arguments: {
                          "type": type,
                          "gameLevelController": gameLevelController,
                        });
                        // Get.to(()=> GameCategoryLevelScreen(type: type, controller: gameLevelController));
                      });
                    },
                  );
                },
              );
            }else {
              return const Center(
                child: Text("Data not found!!", style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center,),
              );
            }

          case ApiStatus.error:
            return const Center(child: Text("Failed to load subcategories"));
        }
      })
    );
  }
}
