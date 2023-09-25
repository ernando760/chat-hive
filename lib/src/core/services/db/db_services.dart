import 'package:chat_hive/src/core/models/chat.dart';
import 'package:chat_hive/src/core/models/message.dart';
import 'package:chat_hive/src/core/models/user_model.dart';
import 'package:result_dart/result_dart.dart';

abstract class DbServices {
  Future<Result<List<UserModel>, String>> getAllUsers();
  Future<Result<UserModel, String>> getUser({required String uuid});
  Future<Result<Unit, String>> createUser({required UserModel user});
  Future<Result<UserModel, String>> updateUser(
      {required String uuid, required UserModel user});
  Future<Result<Unit, String>> deleteUser({required String uuid});
  Result<Stream<List<Message>>, String> getAllMessages(String uuidChat);
  Future<Result<Chat, String>> createChat(
      {required UserModel userCurrent, required UserModel userTarget});
  Future<Result<Unit, String>> sendMessage(Chat chat, String message);
}
