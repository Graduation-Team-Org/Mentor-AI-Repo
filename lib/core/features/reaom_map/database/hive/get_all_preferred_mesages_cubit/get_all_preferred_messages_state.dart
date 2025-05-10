part of 'get_all_preferred_messages_cubit.dart';

@immutable
sealed class GetAllPreferredMessagesState {}

final class GetAllPreferredMessagesInitial extends GetAllPreferredMessagesState {}
final class GetAllPreferredMessagesSuccess extends GetAllPreferredMessagesState {}
