import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_hive/src/core/models/user_model.dart';
import 'package:chat_hive/src/core/services/auth/auth_services.dart';
import 'package:chat_hive/src/core/services/db/db_services.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  late final AuthServices _authServices;
  late final DbServices _dbServices;
  bool _isLogged = false;

  get isLogged => _isLogged;
  AuthCubit(AuthServices authServices, DbServices dbServices)
      : super(AuthInitial()) {
    _authServices = authServices;
    _dbServices = dbServices;
    _authServices
        .authStateChanges()
        .asBroadcastStream()
        .listen(_listenUserisLogged);
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(LoadingAuthState());
    final res = await _authServices.signIn(email: email, password: password);
    final userUuid = res.getOrNull();
    if (userUuid != null) {
      final resUser = await _dbServices.getUser(uuid: userUuid);
      final authState = res.map(
        (_) {
          final user = resUser.getOrNull();
          return LoadedAuthState(userCurrent: user, isLogged: true);
        },
      ).mapError(
          (errorMessage) => FailureAuthState(errorMessage: errorMessage));

      authState.fold((state) => emit(state), (state) => emit(state));
    } else {
      final errorMessage = res.exceptionOrNull();
      emit(FailureAuthState(errorMessage: errorMessage!));
    }
  }

  Future<void> signUp(
      {required String name,
      required String lastname,
      required String email,
      required String password}) async {
    emit(LoadingAuthState());

    final res = await _authServices.signUp(
        name: name, lastname: lastname, email: email, password: password);

    final user = res.getOrNull();
    log("$user", name: "User");
    if (user != null) {
      await _dbServices.createUser(user: user);

      final authState = res
          .map((user) => LoadedAuthState(userCurrent: user, isLogged: true))
          .mapError(
              (errorMessage) => FailureAuthState(errorMessage: errorMessage));

      log("${authState.getOrNull()}", name: "Success");
      log("${authState.exceptionOrNull()}", name: "Failure");

      authState.fold((state) => emit(state), (state) => emit(state));
    } else {
      final errorMessage = res.exceptionOrNull();
      emit(FailureAuthState(errorMessage: errorMessage!));
    }
  }

  Future<void> signOut() async {
    emit(LoadingAuthState());
    await _authServices.signOut();
    emit(const LoadedAuthState(userCurrent: null, isLogged: false));
  }

  Future<void> authChangeState() async {
    emit(LoadingAuthState());
    await Future.delayed(const Duration(milliseconds: 800));
    emit(LoadedAuthState(userCurrent: state.userCurrent, isLogged: _isLogged));
  }

  _listenUserisLogged(String? userUuid) {
    if (userUuid != null) {
      print("UserUuid $userUuid");
      _isLogged = true;
    } else {
      _isLogged = false;
    }
    print("$_isLogged");
  }
}
