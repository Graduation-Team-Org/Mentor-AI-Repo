import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'get_messages_state.dart';

class GetMessagesCubit extends Cubit<GetMessagesState> {
  GetMessagesCubit() : super(GetMessagesInitial());
}
