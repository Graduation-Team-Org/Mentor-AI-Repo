part of 'preferred_messages_cubit.dart';

@immutable
sealed class PreferredMessagesState {}

final class PreferredMessagesInitial extends PreferredMessagesState {}

final class PreferredMessagesSuccsess extends PreferredMessagesState {}

final class PreferredMessagesFailure extends PreferredMessagesState {
  final String errorMessage;

  PreferredMessagesFailure({required this.errorMessage});
}
