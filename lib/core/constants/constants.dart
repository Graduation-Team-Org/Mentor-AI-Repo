import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Constants {
  static final String? openAIAuth = dotenv.env['OPEN_AI_AUTH'];
  static final String? openAIAssistantID = dotenv.env['OPEN_AI_ASSISTANT_ID'];
}
