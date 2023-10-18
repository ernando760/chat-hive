import 'package:chat_hive/src/core/models/message.dart';
import 'package:chat_hive/src/core/models/user_model.dart';
import 'package:result_dart/result_dart.dart';

abstract class DbServices {
  AsyncResult<List<UserModel>, String> getAllUsers();
  AsyncResult<UserModel, String> getUser({required String uuid});
  AsyncResult<Unit, String> createUser({required UserModel user});
  AsyncResult<UserModel, String> updateUser(
      {required String uuid,
      required String name,
      required String lastname,
      required String email,
      required String password,
      String? photoUrl});
  AsyncResult<Unit, String> deleteUser({required String uuid});
  Result<Stream<List<Message>>, String> getAllMessages(
      {required String senderUuid, required String receiverUuid});

  AsyncResult<Unit, String> sendMessage(
      {required String senderUuid,
      required String receiverUuid,
      required String message});
}
