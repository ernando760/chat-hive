import 'package:chat_hive/src/core/models/chat.dart';
import 'package:chat_hive/src/core/models/message.dart';
import 'package:chat_hive/src/core/models/user_model.dart';
import 'package:chat_hive/src/core/services/db/db_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';
import 'package:uuidv6/uuidv6.dart';

class FirestoreServices extends DbServices {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<Result<Unit, String>> createUser({required UserModel user}) async {
    if (user.uuid != null) {
      final col = _firebaseFirestore.collection("/users");

      await col.doc(user.uuid).set(user.toMap());
      return Success.unit();
    }
    return const Failure("Error ao criar o usuario");
  }

  @override
  Future<Result<Unit, String>> deleteUser({required String uuid}) async {
    if (uuid.isNotEmpty) {
      final col = _firebaseFirestore.collection("/users");
      await col.doc(uuid).delete();
      return Success.unit();
    }
    return const Failure("Error ao deletar o usuario");
  }

  @override
  Future<Result<UserModel, String>> getUser({required String uuid}) async {
    if (uuid.isNotEmpty) {
      final col = _firebaseFirestore.collection("/users");
      final doc = await col.doc(uuid).get();
      if (doc.data() != null) {
        final user = UserModel.fromMap(doc.data()!);

        return Success(user);
      }
      return const Failure("Usuaio não encontrado");
    }
    return const Failure("Error ao obter o usuario");
  }

  @override
  Future<Result<List<UserModel>, String>> getAllUsers() async {
    try {
      final query = await _firebaseFirestore.collection("/users").get();
      final users =
          query.docs.map((doc) => UserModel.fromMap(doc.data())).toList();

      return Success(users);
    } catch (e) {
      return const Failure("Error ao obter todos os usuarios");
    }
  }

  @override
  Future<Result<UserModel, String>> updateUser(
      {required String uuid, required UserModel user}) async {
    try {
      if (uuid.isNotEmpty) {
        final doc = _firebaseFirestore.collection("/users").doc(uuid);
        final updateUser = UserModel(
                name: user.name,
                lastname: user.lastname,
                email: user.email,
                password: user.password)
            .copyWith(uuid: uuid);
        await doc.update(updateUser.toMap().cast<Object, Object>());
        return Success(updateUser);
      }
      return const Failure("Usuario não encontrado");
    } catch (_) {
      return const Failure("Error ao atualizar o usuario");
    }
  }

  @override
  Result<Stream<List<Message>>, String> getAllMessages(String uuidChat) {
    try {
      if (uuidChat.isNotEmpty) {
        final doc = _firebaseFirestore.collection("/chats").doc(uuidChat);
        return Success(doc
            .snapshots()
            .map((event) => Chat.fromMap(event.data() ?? {}).messages)
            .distinct());
      }
      return const Failure("Error ao obter todas as messagens");
    } catch (_) {
      return const Failure("Error ao obter todas as messagens");
    }
  }

  @override
  Future<Result<Chat, String>> createChat(
      {required UserModel userCurrent,
      required UserModel userTarget,
      String? message}) async {
    try {
      final uuids = [userCurrent.uuid, userTarget.uuid];
      uuids.sort();
      final uuidChat = uuids.join("-");
      final coll = _firebaseFirestore.collection("/chats");

      final chat = Chat(
        uuidChat: uuidChat,
        senderUuid: userCurrent.uuid,
        receiverUuid: userTarget.uuid,
        messages: const [],
      );

      await coll.doc(uuidChat).set(chat.toMap());

      return Success(chat);
    } catch (_) {
      return const Failure("Error ao criar o bate-papo");
    }
  }

  @override
  Future<Result<Unit, String>> sendMessage(Chat chat, String message) async {
    try {
      final doc = _firebaseFirestore.collection("/chats").doc(chat.uuidChat);
      if (message.isNotEmpty) {
        final newUuid = uuidv6();
        final newMessage = Message(
            uuid: newUuid, senderUuid: chat.senderUuid, message: message);
        chat.messages.add(newMessage);
        await doc.set(chat.toMap());
        return Success.unit();
      }

      return const Failure("Error ao enviar a messagem");
    } catch (_) {
      return const Failure("Error ao enviar a messagem");
    }
  }
}
