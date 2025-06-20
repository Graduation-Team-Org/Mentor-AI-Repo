import 'package:hive/hive.dart';


part 'preferred_messages_model.g.dart';

@HiveType(typeId: 0)
class PreferredAnalyzeResumeMessagesModel extends HiveObject {
  @HiveField(0)
  final String msgContent;
  @HiveField(1)
  final String msgImage;
  @HiveField(2)
  final String likeDate;
  PreferredAnalyzeResumeMessagesModel({
    required this.msgContent,
    required this.msgImage,
    required this.likeDate,
  });
}
