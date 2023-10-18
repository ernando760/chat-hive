import 'package:bloc_test/bloc_test.dart';
import 'package:chat_hive/src/core/models/user_model.dart';
import 'package:chat_hive/src/screens/auth/store/bloc/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  group("Success test bloc", () {
    test("Should be return [LoadedAuthState] when add event SignInEvent", () {
      testBloc(
        build: () => MockAuthBloc(),
        act: (bloc) => bloc.add(const SignInEvent(
            email: "teste.testando@teste.com", password: "teste123")),
        wait: const Duration(seconds: 2),
        verify: (bloc) => verify(() => bloc.add(const SignInEvent(
            email: "teste.testando@teste.com",
            password: "teste123"))).called(1),
        expect: () => [
          const LoadedAuthState(
              userCurrent: UserModel(
                  uuid: "uuid",
                  name: "teste",
                  lastname: "testando",
                  email: "teste.testando@teste.com",
                  password: "teste123"),
              isLogged: true)
        ],
      );
    });

    test("Should be return [LoadedAuthState] when add event SignUpEvent", () {
      testBloc(
        build: () => MockAuthBloc(),
        act: (bloc) => bloc.add(const SignUpEvent(
            name: "teste",
            lastname: "testando",
            email: "teste.testando@teste.com",
            password: "teste123")),
        wait: const Duration(seconds: 2),
        verify: (bloc) => verify(() => bloc.add(const SignUpEvent(
            name: "teste",
            lastname: "testando",
            email: "teste.testando@teste.com",
            password: "teste123"))).called(1),
        expect: () => [
          const LoadedAuthState(
              userCurrent: UserModel(
                  uuid: "uuid",
                  name: "teste",
                  lastname: "testando",
                  email: "teste.testando@teste.com",
                  password: "teste123"),
              isLogged: true)
        ],
      );
    });

    test("Should be return [LoadedAuthState] when add event SignOutEvent", () {
      testBloc(
        build: () => MockAuthBloc(),
        act: (bloc) => bloc.add(SignOutEvent()),
        wait: const Duration(seconds: 2),
        verify: (bloc) => verify(() => bloc.add(SignOutEvent())).called(1),
        expect: () =>
            [const LoadedAuthState(userCurrent: null, isLogged: false)],
      );
    });
  });

  group("Failure test bloc", () {
    test("Should be return [FailureAuthState] when add event SignInEvent", () {
      testBloc(
        build: () => MockAuthBloc(),
        act: (bloc) => bloc.add(const SignInEvent(
            email: "teste.testando@teste.com", password: "teste123")),
        wait: const Duration(seconds: 2),
        verify: (bloc) => verify(() => bloc.add(const SignInEvent(
            email: "teste.testando@teste.com",
            password: "teste123"))).called(1),
        expect: () =>
            [const FailureAuthState(errorMessage: "Usuario não existe")],
      );
    });

    test("Should be return [FailureAuthState] when add event SignUpEvent", () {
      testBloc(
        build: () => MockAuthBloc(),
        act: (bloc) => bloc.add(const SignUpEvent(
            name: "teste",
            lastname: "testando",
            email: "teste.testando@teste.com",
            password: "teste123")),
        wait: const Duration(seconds: 2),
        verify: (bloc) => verify(() => bloc.add(const SignUpEvent(
            name: "teste",
            lastname: "testando",
            email: "teste.testando@teste.com",
            password: "teste123"))).called(1),
        expect: () =>
            [const FailureAuthState(errorMessage: "Este usúario já existe")],
      );
    });
  });
}
