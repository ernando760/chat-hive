// ignore_for_file: avoid_print

import 'package:chat_hive/src/core/models/user_model.dart';
import 'package:chat_hive/src/core/services/auth/auth_services.dart';
import 'package:chat_hive/src/core/services/errors/auth_error.dart';
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

    expect(uuidUser, equals(const Success("id")));

    verify(
      () => mockFirebaseAuthServices.signIn(
          email: "teste.testando@teste.com", password: "teste123"),
    ).called(1);
  });

  test("should be return error message when user does login", () async {
    final mockFirebaseAuthServices = MockFirebaseAuthSevices();
    when(() => mockFirebaseAuthServices.signIn(email: "", password: "teste123"))
        .thenAnswer(
            (_) async => Failure(SignInError("error ao fazer o login")));

    final uuidUser =
        await mockFirebaseAuthServices.signIn(email: "", password: "teste123");

    expect(
        uuidUser.exceptionOrNull()?.errorMessage,
        equals(
            Failure<String, SignInError>(SignInError("error ao fazer o login"))
                .exceptionOrNull()
                .errorMessage));

    verify(
      () => mockFirebaseAuthServices.signIn(email: "", password: "teste123"),
    ).called(1);
  });

  test("should be return user when user does sign up", () async {
    final mockFirebaseAuthServices = MockFirebaseAuthSevices();
    when(() => mockFirebaseAuthServices.signUp(
        email: "teste.testando@teste.com",
        password: "teste123")).thenAnswer((_) async => const Success("uuid"));

    final uuidUser = await mockFirebaseAuthServices.signUp(
        email: "teste.testando@teste.com", password: "teste123");

    expect(uuidUser, equals(const Success<String, String>("uuid")));

    verify(
      () => mockFirebaseAuthServices.signUp(
          email: "teste.testando@teste.com", password: "teste123"),
    ).called(1);
  });
  test("should be return error message when user does sign up", () async {
    final mockFirebaseAuthServices = MockFirebaseAuthSevices();
    when(() => mockFirebaseAuthServices.signUp(email: "", password: "teste123"))
        .thenAnswer(
            (_) async => Failure(SignUpError("error ao fazer o cadastro")));

    final uuidUser =
        await mockFirebaseAuthServices.signUp(email: "", password: "teste123");

    expect(
        uuidUser.exceptionOrNull()?.errorMessage,
        equalsIgnoringCase(Failure<UserModel, SignUpError>(
                SignUpError("error ao fazer o cadastro"))
            .exceptionOrNull()
            .errorMessage
            .toString()));

    verify(
      () => mockFirebaseAuthServices.signUp(email: "", password: "teste123"),
    ).called(1);
  });
}
