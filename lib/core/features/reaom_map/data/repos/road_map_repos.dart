import 'package:road_map_mentor/core/features/reaom_map/data/models/chat_messages_model.dart';

abstract class RoadMapRepos {
  Future<List<ChatMessageModel>> addMessage(String content);
  Future<List<ChatMessageModel>> getMessages();
  Future<void> createThread();
}