import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_hive/src/core/models/user_model.dart';
import 'package:chat_hive/src/core/services/auth/auth_services.dart';
import 'package:chat_hive/src/core/services/db/db_services.dart';
import 'package:chat_hive/src/core/services/storage/storage_services.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late final AuthServices _authServices;
  late final DbServices _dbServices;
  late final StorageServices _storageServices;

  bool get isLogged => _authServices.isLogged;
  AuthBloc(AuthServices authServices, DbServices dbServices,
      StorageServices storageServices)
      : super(AuthInitial()) {
    _authServices = authServices;
    _dbServices = dbServices;
    _storageServices = storageServices;
    on<SignInEvent>((event, emit) async {
      emit(LoadingAuthState());
      final res = await _authServices.signIn(
          email: event.email, password: event.password);
      final userUuid = res.getOrNull();
      final userAuthException = res.exceptionOrNull();

      if (userAuthException != null) {
        emit(FailureAuthState(errorMessage: userAuthException.errorMessage!));
        return;
      }
      if (userUuid != null) {
        final resUser = await _dbServices.getUser(uuid: userUuid);

        final resUserException = resUser.exceptionOrNull();

        if (resUserException != null) {
          emit(FailureAuthState(errorMessage: resUserException));
          return;
        }

        final authState = res.map(
          (_) {
            final user = resUser.getOrNull();
            return LoadedAuthState(userCurrent: user, isLogged: isLogged);
          },
        ).mapError((signInError) =>
            FailureAuthState(errorMessage: signInError.errorMessage!));

        authState.fold((state) => emit(state), (state) => emit(state));
      }
    });
    on<SignUpEvent>((event, emit) async {
      emit(LoadingAuthState());

      final resSignUp = await _authServices.signUp(
          email: event.email, password: event.password);

      final resSignUpException = resSignUp.exceptionOrNull();

      if (resSignUpException != null) {
        emit(FailureAuthState(errorMessage: resSignUpException.errorMessage!));
        return;
      }

      final userUuid = resSignUp.getOrNull();

      log("$userUuid", name: "User");
      if (userUuid != null) {
        String? photo;
        if (event.photoUrl != null) {
          final resPhoto = await _storageServices.addPhotoAvartar(
              userUuid: userUuid, photoPathLocalAvartar: event.photoUrl);
          final resPhotoException = resPhoto.exceptionOrNull();
          if (resPhotoException != null) {
            emit(
                FailureAuthState(errorMessage: resPhotoException.errorMessage));
          }
          photo = resPhoto.getOrNull();
        }

        final newUser = UserModel(
            uuid: userUuid,
            name: event.name,
            lastname: event.lastname,
            email: event.email,
            password: event.password,
            photoUrl: photo);
        final resCreateUser = await _dbServices.createUser(user: newUser);
        final resCreateUserException = resCreateUser.exceptionOrNull();
        if (resCreateUserException != null) {
          emit(FailureAuthState(errorMessage: resCreateUserException));
        }
        final authState = resSignUp
            .map((_) =>
                LoadedAuthState(userCurrent: newUser, isLogged: isLogged))
            .mapError((signUpError) =>
                FailureAuthState(errorMessage: signUpError.errorMessage!));

        authState.fold((state) => emit(state), (state) => emit(state));
      }
    });
    on<SignOutEvent>((event, emit) async {
      emit(LoadingAuthState());
      await _authServices.signOut();
      emit(const LoadedAuthState(userCurrent: null, isLogged: false));
    });

    on<CheckUserIsLoggedEvent>((event, emit) async {
      if (_authServices.userCurrentUuid != null) {
        emit(LoadingAuthState());
        final res =
            await _dbServices.getUser(uuid: _authServices.userCurrentUuid!);

        final authState = res
            .map((user) =>
                LoadedAuthState(userCurrent: user, isLogged: isLogged))
            .mapError((error) => FailureAuthState(errorMessage: error));

        authState.fold((success) => emit(success), (failure) => emit(failure));
      }
    });
  }
}
