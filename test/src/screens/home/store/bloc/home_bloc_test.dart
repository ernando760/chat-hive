import 'package:bloc_test/bloc_test.dart';
import 'package:chat_hive/src/core/models/user_model.dart';
import 'package:chat_hive/src/screens/home/store/bloc/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}

const users = [
  UserModel(
      uuid: "uuid",
      name: "teste",
      lastname: "testando",
      email: "teste.testando@teste.com",
      password: "teste123"),
  UserModel(
      uuid: "uuid2",
      name: "teste2",
      lastname: "testando2",
      email: "teste.testando2@teste.com",
      password: "teste123"),
  UserModel(
      uuid: "uuid3",
      name: "teste3",
      lastname: "testando3",
      email: "teste.testando3@teste.com",
      password: "teste123"),
];

void main() {
  group("Success test bloc", () {
    test("Should be return [LoadedHomeState] when add event getAllUsers", () {
      testBloc(
        build: () => MockHomeBloc(),
        act: (bloc) => bloc.add(GetAllUsersEvent()),
        wait: const Duration(seconds: 2),
        expect: () => [const LoadedHomeState(users: users)],
      );
    });

    test("Should be return [LoadedHomeState] when add event getUser", () {
      testBloc(
        build: () => MockHomeBloc(),
        act: (bloc) => bloc.add(const GetUserEvent(userUuid: "uuid")),
        wait: const Duration(seconds: 2),
        verify: (bloc) =>
            verify(() => bloc.add(const GetUserEvent(userUuid: "uuid")))
                .called(1),
        expect: () => [
          const LoadedHomeState(
              users: users,
              user: UserModel(
                  name: "teste",
                  lastname: "testando",
                  email: "teste.testando@teste.com",
                  password: "teste123"))
        ],
      );
    });
  });

  group("Failure test bloc", () {
    test("Should be return [FailureHomeState] when add event getAllUsers", () {
      testBloc(
        build: () => MockHomeBloc(),
        act: (bloc) => bloc.add(GetAllUsersEvent()),
        wait: const Duration(seconds: 2),
        verify: (bloc) => verify(() => bloc.add(GetAllUsersEvent())).called(1),
        expect: () => [
          const FailureHomeState(
              errorMessage: "Error ao obter todos os usuarios")
        ],
      );
    });

    test("Should be return [FailureHomeState] when add event getUser", () {
      testBloc(
        build: () => MockHomeBloc(),
        act: (bloc) => bloc.add(const GetUserEvent(userUuid: "uuid")),
        wait: const Duration(seconds: 2),
        verify: (bloc) =>
            verify(() => bloc.add(const GetUserEvent(userUuid: "uuid")))
                .called(1),
        expect: () => [
          const FailureHomeState(errorMessage: "Error ao obter o usuario uuid")
        ],
      );
    });
  });
}
