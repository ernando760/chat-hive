import 'dart:developer';

import 'package:chat_hive/src/core/models/message.dart';
import 'package:chat_hive/src/core/models/user_model.dart';
import 'package:chat_hive/src/core/services/db/db_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';
import 'package:uuidv6/uuidv6.dart';

class FirestoreServices extends DbServices {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  AsyncResult<Unit, String> createUser({required UserModel user}) async {
    if (user.uuid != null) {
      final col = _firebaseFirestore.collection("/users");

      await col.doc(user.uuid).set(user.toMap());
      return Success.unit();
    }
    return const Failure("Error ao criar o usuario");
  }

  @override
  AsyncResult<Unit, String> deleteUser({required String uuid}) async {
    if (uuid.isNotEmpty) {
      final col = _firebaseFirestore.collection("/users");

      await col.doc(uuid).delete();
      return Success.unit();
    }
    return const Failure("Error ao deletar o usuario");
  }

  @override
  AsyncResult<UserModel, String> getUser({required String uuid}) async {
    if (uuid.isNotEmpty) {
      final col = _firebaseFirestore.collection("/users");
      final doc = await col.doc(uuid).get();
      if (doc.data() != null) {
        final user = UserModel.fromMap(doc.data()!);

        return Success(user);
      }
      return const Failure("Usuario não encontrado");
    }
    return const Failure("Error ao obter o usuario");
  }

  @override
  AsyncResult<List<UserModel>, String> getAllUsers() async {
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
  AsyncResult<UserModel, String> updateUser(
      {required String uuid,
      required String name,
      required String lastname,
      required String email,
      required String password,
      String? photoUrl}) async {
    try {
      if (uuid.isNotEmpty) {
        final doc = _firebaseFirestore.collection("/users").doc(uuid);
        final updateUser = UserModel(
                name: name,
                lastname: lastname,
                email: email,
                photoUrl: photoUrl,
                password: password)
            .copyWith(uuid: uuid);
        await doc.update(updateUser.toMap());
        return Success(updateUser);
      }
      return const Failure("Usuario não encontrado");
    } on FirebaseException catch (e) {
      log("${e.code} -> ${e.message}", name: "Error update user");
      return const Failure("Error ao atualizar o usuario");
    }
  }

  @override
  Result<Stream<List<Message>>, String> getAllMessages(
      {required String senderUuid, required String receiverUuid}) {
    try {
      List<String> chatUuids = [senderUuid, receiverUuid];
      chatUuids.sort();
      String chatUuid = chatUuids.join("-");
      if (senderUuid.isNotEmpty && receiverUuid.isNotEmpty) {
        final doc = _firebaseFirestore
            .collection("/chats")
            .doc(chatUuid)
            .collection("messages")
            .orderBy("timestamp", descending: false);

        doc.snapshots().listen((event) {
          final list = event.docs
              .map(
                (e) => Message.fromMap(e.data()),
              )
              .toList();
          print(list);
        });
        return Success(doc
            .snapshots()
            .map((event) =>
                event.docs.map((e) => Message.fromMap(e.data())).toList())
            .distinct());
      }
      return const Failure("Error ao obter todas as messagens");
    } catch (_) {
      return const Failure("Error ao obter todas as messagens");
    }
  }

  @override
  AsyncResult<Unit, String> sendMessage(
      {required String senderUuid,
      required String receiverUuid,
      required String message}) async {
    try {
      List<String> chatUuids = [senderUuid, receiverUuid];
      chatUuids.sort();
      String chatUuid = chatUuids.join("-");
      if (message.isNotEmpty) {
        final newUuid = uuidv6();
        final timestamp = Timestamp.now();
        final newMessage = Message(
            uuid: newUuid,
            senderUuid: senderUuid,
            message: message,
            timestamp: timestamp);
        final coll = _firebaseFirestore
            .collection("/chats")
            .doc(chatUuid)
            .collection("messages");
        await coll.add(newMessage.toMap());
        return Success.unit();
      }

      return const Failure("Error ao enviar a messagem");
    } catch (_) {
      return const Failure("Error ao enviar a messagem");
    }
  }
}
