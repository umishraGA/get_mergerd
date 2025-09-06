import 'package:get/get.dart';
import 'package:myapp/common/enum/enum.dart';
import '../model/game_category_model.dart';
import '../repository/game_category_repo.dart';

class GameCategoryController extends GetxController {
  final GameCategoryRepository _repo = GameCategoryRepository();

  var categoriesZone = <QuizCategoryData>[].obs;
  var categoriesFun = <QuizCategoryData>[].obs;
  var categoriesTrue = <QuizCategoryData>[].obs;
  var categoriesWord = <QuizCategoryData>[].obs;
  var status = ApiStatus.initial.obs;
  var errorMessage = "".obs;

  Future<void> fetchCategoriesApi(String type) async {
    try {
      status(ApiStatus.loading); // set loading
      final response = await _repo.getQuizZoneCategories(type);

      if (response.success == true && response.data != null) {
        if(type == "zone") {
          categoriesZone.assignAll(response.data!);
        }
        if(type == "fun") {
          categoriesFun.assignAll(response.data!);
        }
        if(type == "true") {
          categoriesTrue.assignAll(response.data!);
        }
        if(type == "guess") {
          categoriesWord.assignAll(response.data!);
        }

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
