part of 'add_messages_cubit.dart';

abstract class AnalyzeResumeAllMessagesState {}

class AllMessagesInitial extends AnalyzeResumeAllMessagesState {}

class AllMessagesLoading extends AnalyzeResumeAllMessagesState {}

class AnalyzeResumeAllMessagesScussess extends AnalyzeResumeAllMessagesState {
  final List<ChatMessageModel> chatMessagesModel;
  AnalyzeResumeAllMessagesScussess({required this.chatMessagesModel});
}

class AnalyzeResumeAllMessagesFailure extends AnalyzeResumeAllMessagesState {
  final String errorMessage;
  AnalyzeResumeAllMessagesFailure({required this.errorMessage});
}
