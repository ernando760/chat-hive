part of 'chat_cubit.dart';

sealed class ChatState extends Equatable {
  const ChatState({this.messages, this.errorMessage});

  final Stream<List<Message>>? messages;
  final String? errorMessage;
  @override
  List<Object?> get props => [messages, errorMessage];
}

final class ChatInitial extends ChatState {}

class LoadedChatState extends ChatState {
  const LoadedChatState({required Stream<List<Message>> messsages})
      : super(messages: messsages);
}

class FailureChatState extends ChatState {
  const FailureChatState({required String errorMessage})
      : super(errorMessage: errorMessage);
}
