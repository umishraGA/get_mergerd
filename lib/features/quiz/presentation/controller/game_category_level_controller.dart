import 'package:get/get.dart';
import 'package:myapp/common/enum/enum.dart';
import '../model/game_category_level_model.dart';
import '../repository/game_category_level_repo.dart';

class GameCategoryLevelController extends GetxController {
  final GameCategoryLevelRepository _repo = GameCategoryLevelRepository();

  var categoriesLevelData = <CategoryLevelData>[].obs;
  var status = ApiStatus.initial.obs;
  var errorMessage = "".obs;

  Future<void> fetchCategoriesLevelData(String categoryId, String subCategoryId, String type) async {
    try {
      status(ApiStatus.loading); // set loading
      final response = await _repo.getCategoriesLevel(categoryId, subCategoryId, type);

      if (response.success == true && response.data != null) {
        categoriesLevelData.assignAll(response.data!);
        status(ApiStatus.success); // set success

      } else {
        errorMessage(response.message ?? "Failed to fetch categories");
        status(ApiStatus.error); // set error
      }
    } catch (e) {
      errorMessage(e.toString());
      status(ApiStatus.error); // set error
    }
  }
}
