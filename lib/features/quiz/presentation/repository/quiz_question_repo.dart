import 'package:myapp/common/constant/api_constants.dart';
import 'package:myapp/utils/api_manager/dio_helper.dart';
import '../data_converter/data_decode.dart';
import '../model/quiz_question_model.dart';

class QuizQuestionRepository {
  final DioHelper _dioHelper = DioHelper();

  /// Fetch Quiz Zone Categories
  Future<QuizQuestionModel> getQuizQuestionRepo(levelId, type) async {
    try {
      final response = await _dioHelper.postApi(
        url: ApiConstants.QUIZ_QUESTION_API,
        reqBody: {
          "levelid": levelId.toString(),
          "type": type.toString(),
        },
        isAuthRequired: true,
      );

      final Map<String, dynamic> jsonData = ResponseParser.parseResponseData(response.data);
      return QuizQuestionModel.fromJson(jsonData);
      // return QuizCategoryResponse.fromJson(jsonData);
    } catch (e) {
      // You can throw here to be handled in controller
      rethrow;
    }
  }

}
