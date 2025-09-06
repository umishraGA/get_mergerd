import 'package:myapp/common/constant/api_constants.dart';
import 'package:myapp/features/quiz/presentation/model/quiz_answer_model.dart';
import 'package:myapp/utils/api_manager/dio_helper.dart';
import '../data_converter/data_decode.dart';

class QuizAnswerRepository {
  final DioHelper _dioHelper = DioHelper();

  /// Fetch Quiz Zone Categories
  Future<QuizAnswerDataModel> getQuizAnswerRepo(questionId, levelId, type, ans) async {
    try {
      final response = await _dioHelper.postApi(
        url: ApiConstants.QUIZ_ANSWER_API,
        reqBody: {
          "questionid": questionId.toString(),
          "levelid": levelId.toString(),
          "type": type.toString(),
          "answer": ans.toString()
        },
        isAuthRequired: true,
      );

      final Map<String, dynamic> jsonData = ResponseParser.parseResponseData(response.data);
      return QuizAnswerDataModel.fromJson(jsonData);
      // return QuizCategoryResponse.fromJson(jsonData);
    } catch (e) {
      // You can throw here to be handled in controller
      rethrow;
    }
  }

}
