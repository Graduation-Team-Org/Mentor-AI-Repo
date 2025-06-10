class InterviewQuestion {
  final String question;
  String? answer;
  int? score;
  String? feedback;

  InterviewQuestion({
    required this.question,
    this.answer,
    this.score,
    this.feedback,
  });
}

class InterviewModel {
  final String field;
  final List<String> technologies;
  final String difficulty;
  final List<InterviewQuestion> questions;
  int currentQuestionIndex = 0;
  bool isCompleted = false;

  InterviewModel({
    required this.field,
    required this.technologies,
    required this.difficulty,
    required this.questions,
  });

  // Calculate the overall score
  int get overallScore {
    if (questions.isEmpty) return 0;
    
    int totalScore = 0;
    int answeredQuestions = 0;
    
    for (var question in questions) {
      if (question.score != null) {
        totalScore += question.score!;
        answeredQuestions++;
      }
    }
    
    return answeredQuestions > 0 ? (totalScore ~/ answeredQuestions) : 0;
  }

  // Check if there's a next question
  bool get hasNextQuestion => currentQuestionIndex < questions.length - 1;

  // Get current question
  InterviewQuestion get currentQuestion => questions[currentQuestionIndex];

  // Move to next question
  void nextQuestion() {
    if (hasNextQuestion) {
      currentQuestionIndex++;
    }
  }
}