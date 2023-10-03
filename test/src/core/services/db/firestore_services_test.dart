// ignore_for_file: avoid_print

import 'package:chat_hive/src/core/models/chat.dart';
import 'package:chat_hive/src/core/models/message.dart';
import 'package:chat_hive/src/core/models/user_model.dart';
import 'package:chat_hive/src/core/services/db/db_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class MockFirestoreServices extends Mock implements DbServices {}

class FakeUserModel extends Fake implements UserModel {}

class FakeChat extends Fake implements Chat {}

void main() {
  late final MockFirestoreServices mockFirestoreServices;

  setUpAll(() {
    mockFirestoreServices = MockFirestoreServices();
    registerFallbackValue(FakeUserModel());
    registerFallbackValue(FakeChat());
  });

  group("Success tests", () {
    test("should be return Unit when create user", () async {
      when(() => mockFirestoreServices.createUser(user: any(named: "user")))
          .thenAnswer((_) async => Success.unit());

      final res = await mockFirestoreServices.createUser(
          user: const UserModel(
              uuid: "uuid",
              name: "teste",
              lastname: "testando",
              email: "teste.testando@testando",
              password: "teste123"));

      expect(res, equals(Success.unit()));

      verify(
        () => mockFirestoreServices.createUser(user: any(named: "user")),
      ).called(1);
    });

    test("should be return Unit when delete user", () async {
      when(() => mockFirestoreServices.deleteUser(uuid: "uuid"))
          .thenAnswer((_) async => Success.unit());

      final res = await mockFirestoreServices.deleteUser(uuid: "uuid");

      expect(res, equals(Success.unit()));

      verify(
        () => mockFirestoreServices.deleteUser(uuid: "uuid"),
      ).called(1);
    });

    test("should be return UserModel when get user", () async {
      when(() => mockFirestoreServices.getUser(uuid: "uuid")).thenAnswer(
          (_) async => const Success(UserModel(
              uuid: "uuid",
              name: "teste",
              lastname: "testando",
              email: "teste.testando@testando",
              password: "teste123")));

      final res = await mockFirestoreServices.getUser(uuid: "uuid");

      expect(
          res,
          equals(const Success(UserModel(
              uuid: "uuid",
              name: "teste",
              lastname: "testando",
              email: "teste.testando@testando",
              password: "teste123"))));

      verify(
        () => mockFirestoreServices.getUser(uuid: "uuid"),
      ).called(1);
    });

    test("should be return UserModel when update user", () async {
      when(() => mockFirestoreServices.updateUser(
              uuid: "uuid", user: any(named: "user")))
          .thenAnswer((_) async => const Success(UserModel(
              uuid: "uuid",
              name: "teste2",
              lastname: "testando2",
              email: "teste.testando@testando",
              password: "teste123")));

      final res = await mockFirestoreServices.updateUser(
          uuid: "uuid",
          user: const UserModel(
              uuid: "uuid",
              name: "teste2",
              lastname: "testando2",
              email: "teste.testando@testando",
              password: "teste123"));

      expect(
          res,
          equals(const Success<UserModel, String>(UserModel(
              uuid: "uuid",
              name: "teste2",
              lastname: "testando2",
              email: "teste.testando@testando",
              password: "teste123"))));

      verify(
        () => mockFirestoreServices.updateUser(
            uuid: "uuid", user: any(named: "user")),
      ).called(1);
    });

    test("should be return Chat when create chat", () async {
      when(() =>
          mockFirestoreServices.createChat(
              userCurrent: any(named: "userCurrent"),
              userTarget: any(named: "userTarget"))).thenAnswer((_) async =>
          const Success(
              Chat(
                  uuidChat: "uuidChat",
                  senderUuid: "senderUuid",
                  receiverUuid: "receiverUuid",
                  messages: [
                Message(uuid: "uuid", senderUuid: "senderUuid", message: "oi")
              ])));

      final res = await mockFirestoreServices.createChat(
          userCurrent: const UserModel(
              uuid: "uuid",
              name: "teste",
              lastname: "testando",
              email: "teste.testando@testando",
              password: "teste123"),
          userTarget: const UserModel(
              uuid: "uuid",
              name: "teste2",
              lastname: "testando2",
              email: "teste.testando2@testando",
              password: "teste123"));

      expect(
          res,
          equals(const Success<Chat, String>(Chat(
              uuidChat: "uuidChat",
              senderUuid: "senderUuid",
              receiverUuid: "receiverUuid",
              messages: [
                Message(uuid: "uuid", senderUuid: "senderUuid", message: "oi")
              ]))));

      verify(
        () => mockFirestoreServices.createChat(
            userCurrent: any(named: "userCurrent"),
            userTarget: any(named: "userTarget")),
      ).called(1);
    });
    test("should be return Messages when get all messages", () async {
      when(() => mockFirestoreServices.getAllMessages("uuidChat"))
          .thenAnswer((_) => Success(Stream.value(const [
                Message(uuid: "1", senderUuid: "senderUuid", message: "oi"),
                Message(
                    uuid: "2", senderUuid: "senderUuid", message: "tudo bem")
              ]).asBroadcastStream()));

      final res = mockFirestoreServices.getAllMessages("uuidChat");

      final stream = res.fold<Stream<List<Message>>?>(
          (success) => success, (failure) => null);

      expect(
          stream,
          emits(const [
            Message(uuid: "1", senderUuid: "senderUuid", message: "oi"),
            Message(uuid: "2", senderUuid: "senderUuid", message: "tudo bem"),
          ]));

      verify(
        () => mockFirestoreServices.getAllMessages("uuidChat"),
      ).called(1);
    });
    test("should be return Unit when send message", () async {
      when(() => mockFirestoreServices.sendMessage(any(), "tudo bem"))
          .thenAnswer((_) async => Success.unit());

      final res = await mockFirestoreServices.sendMessage(
          const Chat(
              uuidChat: "uuidChat",
              senderUuid: "senderUuid",
              receiverUuid: "receiverUuid",
              messages: [
                Message(uuid: "uuid", senderUuid: "senderUuid", message: "oi")
              ]),
          "tudo bem");

      expect(res, equals(Success.unit<String>()));

      verify(
        () => mockFirestoreServices.sendMessage(any(), "tudo bem"),
      ).called(1);
    });
  });

  group("Failure tests", () {
    test("should be return error message when create user", () async {
      when(() => mockFirestoreServices.createUser(user: any(named: "user")))
          .thenAnswer((_) async => const Failure("Error ao criar o usuario"));

      final res = await mockFirestoreServices.createUser(
          user: const UserModel(
              uuid: "uuid",
              name: "",
              lastname: "testando",
              email: "",
              password: "teste123"));

      expect(res, equals(const Failure("Error ao criar o usuario")));

      verify(
        () => mockFirestoreServices.createUser(user: any(named: "user")),
      ).called(1);
    });
    test("should be return error message when get user", () async {
      when(() => mockFirestoreServices.getUser(uuid: ""))
          .thenAnswer((_) async => const Failure("Usuario não encontrado"));

      final res = await mockFirestoreServices.getUser(uuid: "");

      expect(res, equals(const Failure("Usuario não encontrado")));

      verify(
        () => mockFirestoreServices.getUser(uuid: ""),
      ).called(1);
    });

    test("should be return error message when delete user", () async {
      when(() => mockFirestoreServices.deleteUser(uuid: ""))
          .thenAnswer((_) async => const Failure("Error ao deletar o usuario"));

      final res = await mockFirestoreServices.deleteUser(uuid: "");

      expect(res, equals(const Failure("Error ao deletar o usuario")));

      verify(
        () => mockFirestoreServices.deleteUser(uuid: ""),
      ).called(1);
    });

    test("should be return message error when update user", () async {
      when(() => mockFirestoreServices.updateUser(
              uuid: "", user: any(named: "user")))
          .thenAnswer(
              (_) async => const Failure("Error ao atualizar o usuario"));

      final res = await mockFirestoreServices.updateUser(
          uuid: "",
          user: const UserModel(
              name: "teste2",
              lastname: "testando2",
              email: "teste.testando@testando",
              password: "teste123"));

      expect(res, equals(const Failure("Error ao atualizar o usuario")));

      verify(
        () => mockFirestoreServices.updateUser(
            uuid: "", user: any(named: "user")),
      ).called(1);
    });

    test("should be return message error when create chat", () async {
      when(() => mockFirestoreServices.createChat(
              userCurrent: any(named: "userCurrent"),
              userTarget: any(named: "userTarget")))
          .thenAnswer((_) async => const Failure("Error ao criar o bate papo"));

      final res = await mockFirestoreServices.createChat(
          userCurrent: const UserModel(
              name: "teste",
              lastname: "testando",
              email: "teste.testando@testando",
              password: "teste123"),
          userTarget: const UserModel(
              uuid: "uuid",
              name: "teste2",
              lastname: "testando2",
              email: "teste.testando2@testando",
              password: "teste123"));

      expect(res, equals(const Failure("Error ao criar o bate papo")));

      verify(
        () => mockFirestoreServices.createChat(
            userCurrent: any(named: "userCurrent"),
            userTarget: any(named: "userTarget")),
      ).called(1);
    });

    test("should be return message error when get all messages", () async {
      when(() => mockFirestoreServices.getAllMessages(""))
          .thenAnswer((_) => const Failure("Error ao obter as menssagens"));

      final res = mockFirestoreServices.getAllMessages("");

      expect(res, equals(const Failure("Error ao obter as menssagens")));

      verify(
        () => mockFirestoreServices.getAllMessages(""),
      ).called(1);
    });
    test("should be return message error when send message", () async {
      when(() => mockFirestoreServices.sendMessage(any(), "")).thenAnswer(
          (_) async => const Failure("Error ao enviar as mensagens"));

      final res = await mockFirestoreServices.sendMessage(
          const Chat(
              uuidChat: "uuidChat",
              senderUuid: "senderUuid",
              receiverUuid: "receiverUuid",
              messages: [
                Message(uuid: "uuid", senderUuid: "senderUuid", message: "oi")
              ]),
          "");

      expect(res, equals(const Failure("Error ao enviar as mensagens")));

      verify(
        () => mockFirestoreServices.sendMessage(any(), ""),
      ).called(1);
    });
  });
}
