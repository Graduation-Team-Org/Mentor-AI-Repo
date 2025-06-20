import 'package:bloc/bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meta/meta.dart';
import 'package:road_map_mentor/core/features/cv_analysis/database/hive/models/preferred/preferred_messages_model.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/hive/constants/hive_constants.dart';

part 'get_all_preferred_messages_state.dart';

class GetAllAnalyzeResumePreferredMessagesCubit extends Cubit<GetAllAnalyzeResumePreferredMessagesCubitState> {
  GetAllAnalyzeResumePreferredMessagesCubit() : super(GetAllAnalyzeResumePreferredMessagesCubitInitial());

  List<PreferredAnalyzeResumeMessagesModel>? preferredMessages;
  fetchAllMessages() {
    var preferredMessagesBox =
        Hive.box<PreferredAnalyzeResumeMessagesModel>(kAnalyzeResumePreferredMessages);

    preferredMessages = preferredMessagesBox.values.toList();
    emit(GetAllAnalyzeResumePreferredMessagesCubitSuccess());
  }
}
