import 'package:bloc/bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meta/meta.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/hive/constants/hive_constants.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/hive/models/preferred_messages_model.dart';

part 'preferred_messages_state.dart';

class PreferredMessagesCubit extends Cubit<PreferredMessagesState> {
  PreferredMessagesCubit() : super(PreferredMessagesInitial());
  
  // List to keep track of preferred messages
  List<PreferredMessagesModel> preferredMessages = [];

  // Add a message to preferred messages
  Future<void> addPrefrredMessages(PreferredMessagesModel prefrredMessage) async {
    try {
      var preferredMessagesBox =
          Hive.box<PreferredMessagesModel>(kPreferredMessages);
      await preferredMessagesBox.add(prefrredMessage);
      
      // Update our local list
      preferredMessages = preferredMessagesBox.values.toList();
      
      emit(PreferredMessagesSuccsess());
    } catch (e) {
      emit(
        PreferredMessagesFailure(errorMessage: e.toString()),
      );
    }
  }
  
  // Remove a message from preferred messages by index
  Future<void> removePreferredMessage(int index) async {
    try {
      var preferredMessagesBox =
          Hive.box<PreferredMessagesModel>(kPreferredMessages);
      await preferredMessagesBox.deleteAt(index);
      
      // Update our local list
      preferredMessages = preferredMessagesBox.values.toList();
      
      emit(PreferredMessagesSuccsess());
    } catch (e) {
      emit(
        PreferredMessagesFailure(errorMessage: e.toString()),
      );
    }
  }
  
  // Get all preferred messages
  void getAllPreferredMessages() {
    try {
      var preferredMessagesBox =
          Hive.box<PreferredMessagesModel>(kPreferredMessages);
      preferredMessages = preferredMessagesBox.values.toList();
      emit(PreferredMessagesSuccsess());
    } catch (e) {
      emit(
        PreferredMessagesFailure(errorMessage: e.toString()),
      );
    }
  }
}
