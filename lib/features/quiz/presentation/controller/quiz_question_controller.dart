import 'package:get/get.dart';
import 'package:myapp/common/enum/enum.dart';
import 'package:myapp/features/quiz/presentation/model/quiz_question_model.dart';
import '../repository/quiz_question_repo.dart';

class QuizQuestionController extends GetxController {
  final QuizQuestionRepository _repo = QuizQuestionRepository();

  // Quiz questions data
  var quizQuestionDataList = <QuizQuestionData>[].obs;
  var quizLevelDataList = LevelData().obs;

  // API Status
  var status = ApiStatus.initial.obs;

  // Error message
  var errorMessage = "".obs;

  /// Fetch quiz questions from API
  Future<void> fetchQuizQuestionApi(String levelId, String type) async {
    try {
      status(ApiStatus.loading);

      final response = await _repo.getQuizQuestionRepo(levelId, type);

      if (response.statusCode == 200 && response.allData != null) {
        quizQuestionDataList.assignAll(response.allData!);
        if (response.levelData != null) {
          quizLevelDataList.value = response.levelData!;
        }
        status(ApiStatus.success);
      } else {
        errorMessage.value = "No data found";
        status(ApiStatus.error);
      }
    } catch (e) {
      errorMessage.value = e.toString();
      status(ApiStatus.error);
    }
  }

  /// Get correct answer index for a question
  int getCorrectAnswerIndex(QuizQuestionData question) {
    switch (question.answer?.toUpperCase()) {
      case 'A':
        return 0;
      case 'B':
        return 1;
      case 'C':
        return 2;
      case 'D':
        return 3;
      default:
        return 0;
    }
  }

  String feedbackText(AnswerState answerState) {
    switch (answerState) {
      case AnswerState.correct:
        return '🎉 Correct! Well done!';
      case AnswerState.incorrect:
        return '❌ Oops! That’s not quite right.';
      case AnswerState.timeUp:
        return '⏰ Time’s up! Try the next one!';
      default:
        return '';
    }
  }


}
