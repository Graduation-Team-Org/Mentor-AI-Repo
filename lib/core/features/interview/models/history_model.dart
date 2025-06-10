class InterviewHistory {
  final String id;
  final String field;
  final List<String> technologies;
  final String difficulty;
  final DateTime date;
  final int totalScore;
  final List<QuestionHistory> questions;

  InterviewHistory({
    required this.id,
    required this.field,
    required this.technologies,
    required this.difficulty,
    required this.date,
    required this.totalScore,
    required this.questions,
  });

  factory InterviewHistory.fromJson(Map<String, dynamic> json) {
    return InterviewHistory(
      id: json['id'] as String,
      field: json['field'] as String,
      technologies: List<String>.from(json['technologies']),
      difficulty: json['difficulty'] as String,
      date: DateTime.parse(json['date'] as String),
      totalScore: json['totalScore'] as int,
      questions:
          (json['questions'] as List)
              .map((q) => QuestionHistory.fromJson(q))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'field': field,
      'technologies': technologies,
      'difficulty': difficulty,
      'date': date.toIso8601String(),
      'totalScore': totalScore,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}

class QuestionHistory {
  final String question;
  final String answer;
  final int score;
  final String feedback;

  QuestionHistory({
    required this.question,
    required this.answer,
    required this.score,
    required this.feedback,
  });

  factory QuestionHistory.fromJson(Map<String, dynamic> json) {
    return QuestionHistory(
      question: json['question'] as String,
      answer: json['answer'] as String,
      score: json['score'] as int,
      feedback: json['feedback'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
      'score': score,
      'feedback': feedback,
    };
  }
}
