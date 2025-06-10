import 'package:road_map_mentor/core/features/reaom_map/data/models/chat_messages_model.dart';

class HisrtoryChatModel {
 final List<List<ChatMessageModel>> historyChatModel;

  HisrtoryChatModel({required this.historyChatModel});

  factory HisrtoryChatModel.fromJson(Map<String, dynamic> json) {
    return HisrtoryChatModel(
      historyChatModel: (json['historyChatModel'] as List)
          .map((e) => (e as List)
              .map((item) => ChatMessageModel.fromJson(item))
              .toList())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'historyChatModel': historyChatModel
          .map((e) => e.map((item) => item.toJson()).toList())
          .toList(),
    };
  } 
}