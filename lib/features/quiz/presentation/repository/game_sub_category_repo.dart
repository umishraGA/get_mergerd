
import 'package:myapp/common/constant/api_constants.dart';
import 'package:myapp/features/quiz/presentation/model/game_sub_category_model.dart';
import 'package:myapp/utils/api_manager/dio_helper.dart';

import '../data_converter/data_decode.dart';

class SubCategoryRepository {
  final DioHelper _dioHelper = DioHelper();

  Future<SubCategoryResponse> getSubCategories(String categoryId, String type) async {
    try {
      final response = await _dioHelper.postApi(
        url: ApiConstants.SUB_CATEGORIES_API,
        reqBody: {"categoryid": categoryId, "type": type},
        isAuthRequired: true,
      );

      // Convert to Map safely
      final Map<String, dynamic> jsonData = ResponseParser.parseResponseData(response.data);
      return SubCategoryResponse.fromJson(jsonData);
    } catch (e) {
      rethrow;
    }
  }

}
