// ignore_for_file: avoid_print

import 'package:chat_hive/src/core/services/auth/auth_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class MockFirebaseAuthSevices extends Mock implements AuthServices {}

void main() {
  test("should be return uuid when user does login", () async {
    final mockFirebaseAuthServices = MockFirebaseAuthSevices();
    when(() => mockFirebaseAuthServices.signIn(
        email: "teste.testando@teste.com",
        password: "teste123")).thenAnswer((_) async => const Success("id"));

    final uuidUser = await mockFirebaseAuthServices.signIn(
        email: "teste.testando@teste.com", password: "teste123");

    final res = uuidUser.fold((success) => success, (failure) => failure);

    print(res);

    expect(uuidUser, equals(const Success("id")));

    verify(
      () => mockFirebaseAuthServices.signIn(
          email: "teste.testando@teste.com", password: "teste123"),
    ).called(1);
  });

  test("should be return error message when user does login", () async {
    final mockFirebaseAuthServices = MockFirebaseAuthSevices();
    when(() => mockFirebaseAuthServices.signIn(email: "", password: "teste123"))
        .thenAnswer((_) async => const Failure("error ao fazer o login"));

    final uuidUser =
        await mockFirebaseAuthServices.signIn(email: "", password: "teste123");

    final res = uuidUser.fold((success) => success, (failure) => failure);

    print(res);

    expect(uuidUser, equals(const Failure("error ao fazer o login")));

    verify(
      () => mockFirebaseAuthServices.signIn(email: "", password: "teste123"),
    ).called(1);
  });

  test("should be return user when user does sign up", () async {
    final mockFirebaseAuthServices = MockFirebaseAuthSevices();
    when(() => mockFirebaseAuthServices.signUp(
            name: "teste",
            lastname: "testando",
            email: "teste.testando@teste.com",
            password: "teste123"))
        .thenAnswer((_) async => const Failure("error ao fazer o login"));

    final uuidUser = await mockFirebaseAuthServices.signUp(
        name: "teste",
        lastname: "testando",
        email: "teste.testando@teste.com",
        password: "teste123");

    final res = uuidUser.fold((success) => success, (failure) => failure);

    print(res);

    expect(uuidUser, equals(const Failure("error ao fazer o login")));

    verify(
      () => mockFirebaseAuthServices.signUp(
          name: "teste",
          lastname: "testando",
          email: "teste.testando@teste.com",
          password: "teste123"),
    ).called(1);
  });
  test("should be return error message when user does sign up", () async {
    final mockFirebaseAuthServices = MockFirebaseAuthSevices();
    when(() => mockFirebaseAuthServices.signUp(
            name: "teste",
            lastname: "testando",
            email: "",
            password: "teste123"))
        .thenAnswer((_) async => const Failure("error ao fazer o cadastro"));

    final uuidUser = await mockFirebaseAuthServices.signUp(
        name: "teste", lastname: "testando", email: "", password: "teste123");

    final res = uuidUser.fold((success) => success, (failure) => failure);

    print(res);

    expect(uuidUser, equals(const Failure("error ao fazer o cadastro")));

    verify(
      () => mockFirebaseAuthServices.signUp(
          name: "teste", lastname: "testando", email: "", password: "teste123"),
    ).called(1);
  });
}
