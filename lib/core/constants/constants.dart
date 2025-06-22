import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

abstract class Constants {
  static final String? openAIAuth = dotenv.env['OPEN_AI_AUTH'];
  static final String? openAIAssistantID = dotenv.env['OPEN_AI_ASSISTANT_ID'];
  static final String? analyzeResumeAIAssistantID = dotenv.env['ANALYZE-RESUME_ASSISTANT_ID'];
}
class AppColors {
  static const Color primaryDark = Color(0xFF110A2B);
  static const Color primaryPurple = Color(0xFF9860E4);
  static const Color lightPurple = Color(0xFF9747FF);
  static const Color darkPurple = Color(0xFF352250);
  static const Color deepPurple = Color(0xFF40174C);
  static const Color lightText = Color(0xFFF5EFFC);
  static const Color pink = Color(0xFFFF669B);
}