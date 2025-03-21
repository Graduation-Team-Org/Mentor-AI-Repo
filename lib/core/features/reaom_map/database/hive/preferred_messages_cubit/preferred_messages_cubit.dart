import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'preferred_messages_state.dart';

class PreferredMessagesCubit extends Cubit<PreferredMessagesState> {
  PreferredMessagesCubit() : super(PreferredMessagesInitial());
}
