part of 'chat_history_cubit.dart';

@immutable
sealed class ChatHistoryState {}

final class ChatHistoryInitial extends ChatHistoryState {}

final class ChatHistoryLoading extends ChatHistoryState {}

final class ChatHistorySuccess extends ChatHistoryState {
  final List<ChatSessionModel> chatSessions;
  
  ChatHistorySuccess({required this.chatSessions});
}

final class ChatHistoryFailure extends ChatHistoryState {
  final String errorMessage;
  
  ChatHistoryFailure({required this.errorMessage});
}