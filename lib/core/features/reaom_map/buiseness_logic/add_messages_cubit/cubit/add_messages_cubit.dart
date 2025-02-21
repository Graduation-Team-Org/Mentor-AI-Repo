import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:road_map_mentor/core/errors/dio_erros.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/models/chat_messages_model.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/repos/road_map_repos.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/repos/road_map_repos_imp.dart';

part 'add_messages_state.dart';

class AllMessagesCubit extends Cubit<AllMessagesState> {
  final RoadMapRepos roadMapRepos;
  List<ChatMessageModel> messages = [];

  AllMessagesCubit(this.roadMapRepos) : super(AllMessagesInitial());

  Future<void> addmessage({required String content}) async {
    try {
      // Get and emit user message immediately
      final newMessages = await roadMapRepos.addMessage(content);
      messages = newMessages;
      emit(AllMessagesScussess(chatMessagesModel: List.from(messages)));

      // Start listening for assistant's response
      _listenForAssistantResponse();
    } catch (e) {
      emit(AllMessagesFailure(errorMessage: e.toString()));
    }
  }

  Future<void> _listenForAssistantResponse() async {
    try {
      // Poll for new messages
      for (int i = 0; i < 10; i++) {
        final assistantMessages = await (roadMapRepos as RoadMapReposImp).getMessages();
        
        if (assistantMessages.length > messages.length) {
          // We have new messages from the assistant
          messages = assistantMessages;
          emit(AllMessagesScussess(chatMessagesModel: List.from(messages)));
          break;
        }
        // else{
        //   emit();
        // }
        
        await Future.delayed(const Duration(seconds: 1));
      }
    } catch (e) {
      print("Error getting assistant response: $e");
    }
  }

  // List<ChatMessageModel> retrunMessages() {
  //   print('======================MM======================');
  //   print(roadMapRepos.retrunMessages());
  //   print('======================MM======================');
  //   return roadMapRepos.retrunMessages();
  // }

  // Future<void> getmessages() async {
  //   try {
  //     final messages = await roadMapRepos.getMessages();
  //     emit(GetMessagesScussess(chatMessagesModel: messages));
  //     print('===============GetMessages=============>{$messages.}');
  //   } catch (e) {
  //     if (e is DioException) {
  //       ServerFailure.fromDioException(e);
  //     }
  //     emit(AllMessagesFailure(errorMessage: e.toString()));
  //   }
  // }

  // AllMessagesFailure(errorMessage: ServerFailure.fromDioException());

  // AllMessagesScussess(chatMessagesModel: const []);
}
