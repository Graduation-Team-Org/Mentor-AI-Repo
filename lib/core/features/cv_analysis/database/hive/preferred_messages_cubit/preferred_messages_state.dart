part of 'preferred_messages_cubit.dart';

@immutable
sealed class PreferredAnalyzeResumeMessagesState {}

final class PreferredAnalyzeResumeMessagesInitial extends PreferredAnalyzeResumeMessagesState {}

final class PreferredAnalyzeResumeMessagesSuccsess extends PreferredAnalyzeResumeMessagesState {}

final class PreferredAnalyzeResumeMessagesFailure extends PreferredAnalyzeResumeMessagesState {
  final String errorMessage;

  PreferredAnalyzeResumeMessagesFailure({required this.errorMessage});
}
