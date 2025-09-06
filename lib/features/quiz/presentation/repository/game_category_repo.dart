import 'package:myapp/common/constant/api_constants.dart';
import 'package:myapp/utils/api_manager/dio_helper.dart';
import '../data_converter/data_decode.dart';
import '../model/game_category_model.dart';

class GameCategoryRepository {
  final DioHelper _dioHelper = DioHelper();

  /// Fetch Quiz Zone Categories
  Future<QuizCategoryDataModel> getQuizZoneCategories(String type) async {
    try {
      final response = await _dioHelper.postApi(
        url: ApiConstants.CATEGORIES_API,
        reqBody: {"category": type},
        isAuthRequired: true,
      );

      final Map<String, dynamic> jsonData = ResponseParser.parseResponseData(response.data);
      return QuizCategoryDataModel.fromJson(jsonData);
      // return QuizCategoryResponse.fromJson(jsonData);
    } catch (e) {
      // You can throw here to be handled in controller
      rethrow;
    }
  }

}
