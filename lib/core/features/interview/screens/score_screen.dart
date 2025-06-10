// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../constants/constants.dart';
import '../models/interview_model.dart';
import '../utils/background_decorations.dart';

class ScoreScreen extends StatelessWidget {
  final InterviewModel interviewModel;

  const ScoreScreen({super.key, required this.interviewModel});

  // Get color based on score
  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.amber;
    return Colors.red;
  }

  // Get feedback message based on overall score
  String _getFeedbackMessage(int score) {
    if (score >= 90) {
      return "Outstanding! You demonstrated exceptional knowledge and expertise. You would be an excellent candidate for this position.";
    } else if (score >= 80) {
      return "Great job! You showed strong understanding of the concepts. With a bit more practice, you'll be at an expert level.";
    } else if (score >= 70) {
      return "Good work! You have a solid foundation but there are some areas where you could improve your knowledge.";
    } else if (score >= 60) {
      return "You have a basic understanding of the concepts, but need to deepen your knowledge in several areas.";
    } else if (score >= 50) {
      return "You need more practice and study to improve your skills in this area.";
    } else {
      return "Consider spending more time learning the fundamentals before proceeding to interviews in this field.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Stack(
        children: [
          const BackgroundDecorations(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header with back button
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Expanded(
                        child: Text(
                          'Interview Results',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // Balance the header
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Overall score card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.darkPurple,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Overall Score',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 150,
                              height: 150,
                              child: CircularProgressIndicator(
                                value: interviewModel.overallScore / 100,
                                strokeWidth: 12,
                                backgroundColor: Colors.grey.withOpacity(0.3),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _getScoreColor(interviewModel.overallScore),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  '${interviewModel.overallScore}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'out of 100',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _getFeedbackMessage(interviewModel.overallScore),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Question details
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Question Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // List of questions with scores
                  Expanded(
                    child: ListView.builder(
                      itemCount: interviewModel.questions.length,
                      itemBuilder: (context, index) {
                        final question = interviewModel.questions[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: AppColors.darkPurple,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  question.score != null
                                      ? _getScoreColor(question.score!)
                                      : Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: ExpansionTile(
                            collapsedIconColor: Colors.white,
                            iconColor: Colors.white,
                            title: Row(
                              children: [
                                Text(
                                  'Q${index + 1}:',
                                  style: const TextStyle(
                                    color: AppColors.primaryPurple,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    question.question.length > 50
                                        ? '${question.question.substring(0, 50)}...'
                                        : question.question,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                if (question.score != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getScoreColor(question.score!),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${question.score}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Question:',
                                      style: TextStyle(
                                        color: AppColors.primaryPurple,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      question.question,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    if (question.feedback != null) ...[
                                      const Text(
                                        'Feedback:',
                                        style: TextStyle(
                                          color: AppColors.primaryPurple,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        question.feedback!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
