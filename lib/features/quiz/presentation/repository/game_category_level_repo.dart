import 'package:myapp/common/constant/api_constants.dart';
import 'package:myapp/features/quiz/presentation/data_converter/data_decode.dart';
import 'package:myapp/utils/api_manager/dio_helper.dart';
import '../model/game_category_level_model.dart';

class GameCategoryLevelRepository {
  final DioHelper _dioHelper = DioHelper();

  /// Fetch Quiz Zone Categories
  Future<CategoryLevelModel> getCategoriesLevel(String categoryId, String subCategoryId, String type) async {
    try {
      final response = await _dioHelper.postApi(
        url: ApiConstants.CATEGORIES_LEVEL_API,
        reqBody: {
          "category": categoryId,
          "subcategory": subCategoryId,
          "type": type,
        },
        isAuthRequired: true,
      );

      final Map<String, dynamic> jsonData = ResponseParser.parseResponseData(response.data);
      return CategoryLevelModel.fromJson(jsonData);
      // return QuizCategoryResponse.fromJson(jsonData);
    } catch (e) {
      // You can throw here to be handled in controller
      rethrow;
    }
  }


}
