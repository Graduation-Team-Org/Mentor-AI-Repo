import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/models/chat_messages_model.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/repos/road_map_repos.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/repos/road_map_repos_imp.dart';

part 'saved_all_messages_state.dart';

class SavedAllMessagesCubit extends HydratedCubit<SavedAllMessagesState> {
  SavedAllMessagesCubit(this.roadMapRepos) : super(SavedAllMessagesInitial());

  final RoadMapRepos roadMapRepos;
  List<ChatMessageModel> messages = [];

  Future<void> addmessage({required String content}) async {
    // Get and emit user message immediately
    final newMessages = await roadMapRepos.addMessage(content);
    messages = newMessages;
    emit(SavedAllMessagesScussess(chatMessagesModel: List.from(messages)));

    // Start listening for assistant's response
    _listenForAssistantResponse();
  }

  Future<void> _listenForAssistantResponse() async {
    try {
      // Poll for new messages
      for (int i = 0; i < 10; i++) {
        final assistantMessages =
            await (roadMapRepos as RoadMapReposImp).getMessages();

        if (assistantMessages.length > messages.length) {
          // We have new messages from the assistant
          messages = assistantMessages;
          emit(SavedAllMessagesScussess(chatMessagesModel: List.from(messages)));
          break;
        }
        // emit(AllMessagesLoading());

        await Future.delayed(const Duration(seconds: 1));
      }
    } catch (e) {
      print("Error getting assistant response: $e");
    }
  }
  
  @override
  SavedAllMessagesState? fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }
  
  @override
  Map<String, dynamic>? toJson(SavedAllMessagesState state) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
