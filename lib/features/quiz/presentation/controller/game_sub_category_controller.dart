import 'package:get/get.dart';
import 'package:myapp/common/enum/enum.dart';
import 'package:myapp/features/quiz/presentation/model/game_sub_category_model.dart';
import 'package:myapp/features/quiz/presentation/repository/game_sub_category_repo.dart';

class GameSubCategoryController extends GetxController {
  // Observable list of subcategories
  var subCategories = <SubCategory>[].obs;

  // Observable API status
  var apiStatus = ApiStatus.initial.obs;

  // Repository instance
  final SubCategoryRepository repository = SubCategoryRepository();

  /// Fetch subcategories by category ID
  Future<void> fetchSubCategoriesApi(String categoryId, String type) async {
    apiStatus.value = ApiStatus.loading;

    try {
      final SubCategoryResponse response = await repository.getSubCategories(categoryId, type);

      if (response.success == true) {
        subCategories.value = response.data ?? [];
        apiStatus.value = ApiStatus.success;
        print("successfully done!!");
      } else {
        apiStatus.value = ApiStatus.error;
      }
    } catch (e) {
      print("Error fetching subcategories: $e");
      apiStatus.value = ApiStatus.error;
    }
  }
}
