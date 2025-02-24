import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Constants {
  static final String? openAIAuth = dotenv.env['OPEN_AI_AUTH'];
  static final String? openAIAssistantID = dotenv.env['OPEN_AI_ASSISTANT_ID'];
  // static const String openAIAuth =
  //     "Bearer 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";
  // static const String openAIAssistantID = "asst_vA6qUxFYUi6AJiKJGBKPjzKE";
}
