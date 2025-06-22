import 'package:road_map_mentor/core/features/cv_analysis/data/models/chat_messages_model.dart';

abstract class AnalyzeResumeRepos {
  Future<List<AnalyzeResumeChatMessageModel>> addMessage(String content);
  Future<List<AnalyzeResumeChatMessageModel>> getMessages();
  Future<void> createThread();
}