import 'package:chat_hive/src/core/models/chat.dart';
import 'package:chat_hive/src/core/models/message.dart';
import 'package:chat_hive/src/core/models/user_model.dart';
import 'package:result_dart/result_dart.dart';

abstract class DbServices {
  AsyncResult<List<UserModel>, String> getAllUsers();
  AsyncResult<UserModel, String> getUser({required String uuid});
  AsyncResult<Unit, String> createUser({required UserModel user});
  AsyncResult<UserModel, String> updateUser(
      {required String uuid, required UserModel user});
  AsyncResult<Unit, String> deleteUser({required String uuid});
  Result<Stream<List<Message>>, String> getAllMessages(String uuidChat);
  AsyncResult<Chat, String> createChat(
      {required UserModel userCurrent, required UserModel userTarget});
  AsyncResult<Unit, String> sendMessage(Chat chat, String message);
}
