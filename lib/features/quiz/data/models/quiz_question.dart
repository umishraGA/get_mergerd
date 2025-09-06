class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
  });

  bool checkAnswer(int selectedIndex) {
    return selectedIndex == correctAnswerIndex;
  }
}

class TrueFalseQuestion {
  final String statement;
  final bool isTrue;
  final String? explanation;

  TrueFalseQuestion({
    required this.statement,
    required this.isTrue,
    this.explanation,
  });

  bool checkAnswer(bool answer) {
    return answer == isTrue;
  }
}

class WordQuestion {
  final String word;
  final String? hint;
  final String? category;

  WordQuestion({
    required this.word,
    this.hint,
    this.category,
  });
}

class ComprehensionPassage {
  final String title;
  final String content;
  final List<QuizQuestion> questions;

  ComprehensionPassage({
    required this.title,
    required this.content,
    required this.questions,
  });
}
