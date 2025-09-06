import 'package:get/get.dart';
import 'package:myapp/common/enum/enum.dart';
import 'package:myapp/features/quiz/presentation/model/quiz_question_model.dart';
import 'package:myapp/utils/api_manager/animation_snackbar.dart';
import '../repository/quiz_answer_repo.dart';

class QuizAnswerController extends GetxController {
  final QuizAnswerRepository _repo = QuizAnswerRepository();

  // Quiz questions data
  var quizQuestionDataList = <QuizQuestionModel>[].obs;

  // API Status
  var status = ApiStatus.initial.obs;

  // Error message
  var errorMessage = "".obs;

  /// Fetch quiz questions answer API
  Future<void> fetchQuizAnswerApi(String questionId, String levelId, String type, String answer) async {
    try {
      status(ApiStatus.loading);

      final response = await _repo.getQuizAnswerRepo(questionId, levelId, type, answer);

      if (response.statusCode == 200) {
        customPrint("data answer api ======= ${response.data}");
      } else {
        errorMessage.value = "No data found";
        status(ApiStatus.error);
      }
    } catch (e) {
      errorMessage.value = e.toString();
      status(ApiStatus.error);
    }
  }

}
