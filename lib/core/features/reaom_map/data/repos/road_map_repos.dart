import 'package:dartz/dartz.dart';
import 'package:road_map_mentor/core/errors/dio_erros.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/models/chat_messages_model.dart';

abstract class RoadMapRepos {
  Future<List<ChatMessageModel>> addMessage(String content);
  Future<List<ChatMessageModel>> getMessages();
  // List<ChatMessageModel> retrunMessages();
  Future<void> createThread();
  // Future<Either<Failure, List<ChatMessageModel>>> getMessages();
}