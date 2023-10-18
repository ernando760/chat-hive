import 'package:bloc/bloc.dart';
import 'package:chat_hive/src/core/models/message.dart';
import 'package:chat_hive/src/core/services/db/db_services.dart';
import 'package:equatable/equatable.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  late final DbServices _dbServices;
  ChatCubit(DbServices dbServices) : super(ChatInitial()) {
    _dbServices = dbServices;
  }

  void getAllMessages(
      {required String senderUuid, required String receiverUuid}) {
    final res = _dbServices.getAllMessages(
        senderUuid: senderUuid, receiverUuid: receiverUuid);

    final chatState = res
        .map((messages) => LoadedChatState(messsages: messages))
        .mapError(
            (errorMessage) => FailureChatState(errorMessage: errorMessage));
    chatState.fold((success) => emit(success), (failure) => emit(failure));
  }

  Future<void> sendMessage(
      {required String receiverUuid,
      required String senderUuid,
      required String message}) async {
    final res = await _dbServices.sendMessage(
        receiverUuid: receiverUuid, senderUuid: senderUuid, message: message);
    final resMessage = _dbServices.getAllMessages(
        receiverUuid: receiverUuid, senderUuid: senderUuid);
    final messages = resMessage.getOrNull();
    final chatState = res
        .map((_) => LoadedChatState(messsages: messages!))
        .mapError(
            (errorMessage) => FailureChatState(errorMessage: errorMessage));

    chatState.fold((success) => emit(success), (failure) => emit(failure));
  }
}
