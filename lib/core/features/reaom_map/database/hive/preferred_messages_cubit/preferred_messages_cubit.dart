import 'package:bloc/bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meta/meta.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/hive/constants/hive_constants.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/hive/models/preferred_messages_model.dart';

part 'preferred_messages_state.dart';

class PreferredMessagesCubit extends Cubit<PreferredMessagesState> {
  PreferredMessagesCubit() : super(PreferredMessagesInitial());

  addPrefrredMessages(PreferredMessagesModel prefrredMessage) async {
    try {
      var preferredMessagesBox =
          Hive.box<PreferredMessagesModel>(kPreferredMessages);
      await preferredMessagesBox.add(prefrredMessage);
      emit(PreferredMessagesSuccsess());
    } catch (e) {
      emit(
        PreferredMessagesFailure(errorMessage: e.toString()),
      );
    }
  }
}
