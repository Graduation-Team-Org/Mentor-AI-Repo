import 'package:bloc/bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meta/meta.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/hive/constants/hive_constants.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/hive/models/preferred_messages_model.dart';

part 'get_all_preferred_messages_state.dart';

class GetAllPreferredMessagesCubit extends Cubit<GetAllPreferredMessagesState> {
  GetAllPreferredMessagesCubit() : super(GetAllPreferredMessagesInitial());

  List<PreferredMessagesModel>? preferredMessages;
  fetchAllMessages() {
    var preferredMessagesBox =
        Hive.box<PreferredMessagesModel>(kPreferredMessages);

    preferredMessages = preferredMessagesBox.values.toList();
    emit(GetAllPreferredMessagesSuccess());
  }
}
