part of 'saved_all_messages_cubit.dart';

@immutable
sealed class SavedAllMessagesState {}

final class SavedAllMessagesInitial extends SavedAllMessagesState {}


class SavedAllMessagesScussess extends SavedAllMessagesState {
  final List<ChatMessageModel> chatMessagesModel;
  SavedAllMessagesScussess({required this.chatMessagesModel});
}

