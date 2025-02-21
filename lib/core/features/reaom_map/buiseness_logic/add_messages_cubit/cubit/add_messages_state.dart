part of 'add_messages_cubit.dart';

abstract class AllMessagesState {}

class AllMessagesInitial extends AllMessagesState {}

class AllMessagesLoading extends AllMessagesState {}

class AllMessagesScussess extends AllMessagesState {
  final List<ChatMessageModel> chatMessagesModel;
  AllMessagesScussess({required this.chatMessagesModel});
}

class AllMessagesFailure extends AllMessagesState {
  final String errorMessage;
  AllMessagesFailure({required this.errorMessage});
}
class LoadingForMessages extends AllMessagesState {
  final String errorMessage;
  LoadingForMessages({required this.errorMessage});
}
// final class GetMessagesScussess extends AllMessagesState {
//   final List<ChatMessageModel> chatMessagesModel;

//   GetMessagesScussess({required this.chatMessagesModel});
// }
